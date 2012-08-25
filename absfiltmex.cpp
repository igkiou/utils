//////////////////////////////////////////////////////////////////////////////
//  Helper MEX-file for ABSFILT.
//
//  Inputs:
//  prhs[0] - mxArray - Padded image
//  prhs[1] - mxArray - Mean image
//  prhs[2] - int32_T - Size of unpadded image
//  prhs[3] - mxArray - Neighborhood
//////////////////////////////////////////////////////////////////////////////

#include "absfiltmex.h"
#include "/usr/local/matlabR2008a/toolbox/images/images/private/iptutil_cpp.h"
//#include "iptutil_cpp.h"

//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
mxArray *AbsFilter::evaluate(void)
{
    mxAssert((fPadImage != NULL),
             ERR_STRING("AbsFilter::fPadImage","evaluate()"));
    mxAssert((fMeanImage != NULL),
             ERR_STRING("AbsFilter::fMeanImage","evaluate()"));
    mxAssert((fPadImageSize != NULL),
             ERR_STRING("AbsFilter::fNoPadImageSize","evaluate()"));
    mxAssert((fNHood != NULL),
             ERR_STRING("AbsFilter::fNHood","evaluate()"));

    // Initialize variables
    void             *In;
    void             *Mean;
    void             *Out;
    mxArray          *outputImage;

    const mxClassID  imageClass      = mxGetClassID(fPadImage);
    const mwSize     nImageDims      = mxGetNumberOfElements(fPadImageSize);
    mwSize          *padImageSize    = (mwSize *) mxMalloc(nImageDims * sizeof(mwSize));
    double          *pr              = (double *) mxGetData(fPadImageSize);

    for (mwSize p = 0; p < nImageDims; p++)
    {
        padImageSize[p] = (mwSize) pr[p];
    }

    outputImage =  mxCreateNumericArray(nImageDims,
                                        padImageSize,
                                        mxDOUBLE_CLASS,
                                        mxREAL);
    mxFree(padImageSize);

    In = mxGetData(fPadImage);
    Mean = mxGetData(fMeanImage);
    Out = mxGetData(outputImage);

    //calculate abs
    switch (imageClass)
    {
    case mxLOGICAL_CLASS:
        local_abs((mxLogical *)In, (double *)Mean, (double *)Out);
        break;
    case mxUINT8_CLASS:
        local_abs((uint8_T *)In, (double *)Mean, (double *)Out);
        break;
    case mxDOUBLE_CLASS:
        local_abs((double *)In, (double *)Mean, (double *)Out);
        break;
    default:
        mexErrMsgIdAndTxt("Images:absfiltmex:invalidMexInput",
                          "Image should be uint8, double or logical.");
        break;
    }

    return(outputImage);
}

//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
AbsFilter::AbsFilter()
{
    //Initialize member variables
    fPadImage        = NULL;
    fMeanImage        = NULL;
    fPadImageSize    = NULL;
    fNHood           = NULL;

}

//////////////////////////////////////////////////////////////////////////////
// padded image
//////////////////////////////////////////////////////////////////////////////
void AbsFilter::setPadImage(const mxArray *padImage)
{
    fPadImage = padImage;
}

//////////////////////////////////////////////////////////////////////////////
// mean image
//////////////////////////////////////////////////////////////////////////////
void AbsFilter::setMeanImage(const mxArray *meanImage)
{
    fMeanImage = meanImage;
}


//////////////////////////////////////////////////////////////////////////////
// Size of padded image (int32_T)
//////////////////////////////////////////////////////////////////////////////
void AbsFilter::setPadImageSize(const mxArray *padSize)
{
    fPadImageSize = padSize;
}

//////////////////////////////////////////////////////////////////////////////
// Full neighborhood
//////////////////////////////////////////////////////////////////////////////
void AbsFilter::setNHood(const mxArray *nHood)
{
    fNHood = nHood;
}


//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
AbsFilter absFilter;

extern "C"
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    (void) nlhs;  // unused parameter

    if (nrhs != 4)
    {
        mexErrMsgIdAndTxt("Images:absfiltmex:invalidNumInputs",
                          "%s",
                          "ABSFILTMEX needs 4 input arguments.");
    }

    absFilter.setPadImage(prhs[0]);
    absFilter.setMeanImage(prhs[1]);
    absFilter.setPadImageSize(prhs[2]);
    absFilter.setNHood(prhs[3]);

    //Filter the image
    plhs[0] = absFilter.evaluate();
}
