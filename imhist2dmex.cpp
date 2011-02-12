//////////////////////////////////////////////////////////////////////////////
//  Helper MEX-file for IMHIST2D.
//
//  Inputs:
//  prhs[0] - mxArray - Image 1
//  prhs[1] - mxArray - Image 2
//  prhs[3] - double  - Number of bins per histogram dimension
//
//////////////////////////////////////////////////////////////////////////////

#include "imhist2dmex.h"
#include "/usr/local/matlabR2008a/toolbox/images/images/private/iptutil_cpp.h"
//#include "iptutil_cpp.h"

//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
mxArray *Imhist2d::evaluate(void)
{
    mxAssert((fImage1 != NULL),
             ERR_STRING("Imhist2d::fImage1","evaluate()"));
    mxAssert((fImage2 != NULL),
             ERR_STRING("Imhist2d::fImage2","evaluate()"));
    mxAssert((fNBins != 0),
             ERR_STRING("Imhist2d::fNBins","evaluate()"));

    // Initialize variables
    void             *In1;
    void             *In2;
    void             *Out;
    mxArray          *outputImage;

    const mxClassID  imageClass      = mxGetClassID(fImage1);

    outputImage =  mxCreateDoubleMatrix(fNBins*fNBins,
										1,
                                        mxREAL);

    In1 = mxGetData(fImage1);
    In2 = mxGetData(fImage2);
    Out = mxGetData(outputImage);

    //calculate imhist2d
    switch (imageClass)
    {
    case mxLOGICAL_CLASS:
        local_imhist2d((mxLogical *)In1, (mxLogical *)In2, (double *)Out);
        break;
    case mxUINT8_CLASS:
        local_imhist2d((uint8_T *)In1, (uint8_T *)In2, (double *)Out);
        break;
    default:
        mexErrMsgIdAndTxt("Images:imhist2dmex:invalidMexInput",
                          "Image should be uint8 or logical.");
        break;
    }

    return(outputImage);
}

//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
Imhist2d::Imhist2d()
{
    //Initialize member variables
    fImage1     = NULL;
    fImage2     = NULL;
    fNBins      = 0;

}

//////////////////////////////////////////////////////////////////////////////
// image 1
//////////////////////////////////////////////////////////////////////////////
void Imhist2d::setImage1(const mxArray *origImage1)
{
    fImage1 = origImage1;
}

//////////////////////////////////////////////////////////////////////////////
// image 2
//////////////////////////////////////////////////////////////////////////////
void Imhist2d::setImage2(const mxArray *origImage2)
{
    fImage2 = origImage2;
}

//////////////////////////////////////////////////////////////////////////////
// Number of Bins (int)
//////////////////////////////////////////////////////////////////////////////
void Imhist2d::setNBins(const mxArray *nBins)
{
    fNBins = (int)mxGetScalar(nBins);
}

//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
Imhist2d imhist2d;

extern "C"
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    (void) nlhs;  // unused parameter

    if (nrhs != 3)
    {
        mexErrMsgIdAndTxt("Images:imhist2dmex:invalidNumInputs",
                          "%s",
                          "IMHIST2DMEX needs 3 input arguments.");
    }

    imhist2d.setImage1(prhs[0]);
    imhist2d.setImage2(prhs[1]);
    imhist2d.setNBins(prhs[2]);

    //Filter the image
    plhs[0] = imhist2d.evaluate();
}
