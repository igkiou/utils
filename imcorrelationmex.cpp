//////////////////////////////////////////////////////////////////////////////
//  Helper MEX-file for IMCORRELATION.  
//  
//  Inputs:
//  prhs[0] - mxArray - Image 1
//  prhs[1] - mxArray - Image 2
//  prhs[2] - int32_T - Size of original image
//  prhs[3] - mxArray - Neighborhood
//////////////////////////////////////////////////////////////////////////////

#include "imcorrelationmex.h"
#include "/usr/local/matlabR2008a/toolbox/images/images/private/iptutil_cpp.h"

//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
mxArray *ImCorrelation::evaluate(void)
{
    mxAssert((fImage1 != NULL), 
             ERR_STRING("ImCorrelation::fImage1","evaluate()"));
    mxAssert((fImage2 != NULL), 
             ERR_STRING("ImCorrelation::fImage1","evaluate()"));
    mxAssert((fImageSize != NULL), 
             ERR_STRING("ImCorrelation::fNoImageSize","evaluate()"));
    mxAssert((fNHood != NULL), 
             ERR_STRING("ImCorrelation::fNHood","evaluate()"));

    // Initialize variables
    void             *In1;
    void             *In2;
    void             *Out;
    mxArray          *outputImage;

    const mxClassID  imageClass      = mxGetClassID(fImage1);
    const mwSize     nImageDims      = mxGetNumberOfElements(fImageSize);
    mwSize          *imageSize    = (mwSize *) mxMalloc(nImageDims * sizeof(mwSize));
    double          *pr              = (double *) mxGetData(fImageSize);

    for (mwSize p = 0; p < nImageDims; p++)
    {
        imageSize[p] = (mwSize) pr[p];
    }

    outputImage =  mxCreateNumericArray(nImageDims,
                                        imageSize,
                                        mxDOUBLE_CLASS,
                                        mxREAL);
    mxFree(imageSize);

    In1 = mxGetData(fImage1);    
    In2 = mxGetData(fImage2);    
    Out = mxGetData(outputImage);

    //calculate entropy
    switch (imageClass)
    {
    case mxLOGICAL_CLASS:
        local_correlation((mxLogical *)In1, (mxLogical *)In2, (double *)Out);
        break;
    case mxUINT8_CLASS:
        local_correlation((uint8_T *)In1, (uint8_T *)In2, (double *)Out);
        break;
    case mxUINT16_CLASS:
        local_correlation((uint8_T *)In1, (uint8_T *)In2, (double *)Out);
        break;
    case mxDOUBLE_CLASS:
        local_correlation((real_T *)In1, (real_T *)In2, (double *)Out);
        break;
    default:
        mexErrMsgIdAndTxt("Images:imcorrelationmex:invalidMexInput",
                          "Image should be uint8, uint16, double or logical.");
        break;
    }

    return(outputImage);
}

//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
ImCorrelation::ImCorrelation()
{
    //Initialize member variables
    fImage1        = NULL;
    fImage2        = NULL;
    fImageSize     = NULL;    
    fNHood         = NULL;

}

//////////////////////////////////////////////////////////////////////////////
// image 1
//////////////////////////////////////////////////////////////////////////////
void ImCorrelation::setImage1(const mxArray *image1)
{
    fImage1 = image1;
}

//////////////////////////////////////////////////////////////////////////////
// image 2
//////////////////////////////////////////////////////////////////////////////
void ImCorrelation::setImage2(const mxArray *image2)
{
    fImage2 = image2;
}

//////////////////////////////////////////////////////////////////////////////
// Size of padded image (int32_T)
//////////////////////////////////////////////////////////////////////////////
void ImCorrelation::setImageSize(const mxArray *size)
{
    fImageSize = size;
}

//////////////////////////////////////////////////////////////////////////////
// Full neighborhood 
//////////////////////////////////////////////////////////////////////////////
void ImCorrelation::setNHood(const mxArray *nHood)
{
    fNHood = nHood;
}

//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
ImCorrelation imCorrelation;

extern "C"
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    (void) nlhs;  // unused parameter
 
    if (nrhs != 4)
    {
        mexErrMsgIdAndTxt("Images:imcorrelationmex:invalidNumInputs",
                          "%s",
                          "IMCORRELATION needs 4 input arguments.");
    }

    imCorrelation.setImage1(prhs[0]);
    imCorrelation.setImage2(prhs[1]);
    imCorrelation.setImageSize(prhs[2]);
    imCorrelation.setNHood(prhs[3]);

    //Filter the image
    plhs[0] = imCorrelation.evaluate();
}
