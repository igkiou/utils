//////////////////////////////////////////////////////////////////////////////
//  Helper MEX-file for RGBIMHIST.
//
//  Inputs:
//  prhs[0] - mxArray - Image (red plane)
//  prhs[1] - mxArray - Image (green plane)
//  prhs[2] - mxArray - Image (blue plane)
//  prhs[3] - double  - Number of bins per histogram dimension
//
//////////////////////////////////////////////////////////////////////////////

#include "rgbimhistmex.h"
#include "/usr/local/matlabR2008a/toolbox/images/images/private/iptutil_cpp.h"
//#include "iptutil_cpp.h"

//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
mxArray *RgbImhist::evaluate(void)
{
    mxAssert((fImageRed != NULL),
             ERR_STRING("RgbImhist::fImageRed","evaluate()"));
    mxAssert((fImageGreen != NULL),
             ERR_STRING("RgbImhist::fImageGreen","evaluate()"));
    mxAssert((fImageBlue != NULL),
             ERR_STRING("RgbImhist::fImageBlue","evaluate()"));
    mxAssert((fNBins != 0),
             ERR_STRING("RgbImhist::fNBins","evaluate()"));

    // Initialize variables
    void             *InRed;
    void             *InGreen;
    void             *InBlue;
    void             *Out;
    mxArray          *outputImage;

    const mxClassID  imageClass      = mxGetClassID(fImageRed);

    outputImage =  mxCreateDoubleMatrix(fNBins*fNBins*fNBins,
										1,
                                        mxREAL);

    InRed = mxGetData(fImageRed);
    InGreen = mxGetData(fImageGreen);
    InBlue = mxGetData(fImageBlue);
    Out = mxGetData(outputImage);

    //calculate rgbimhist
    switch (imageClass)
    {
    case mxLOGICAL_CLASS:
        local_rgbimhist((mxLogical *)InRed, (mxLogical *)InGreen, (mxLogical *)InBlue, (double *)Out);
        break;
    case mxUINT8_CLASS:
        local_rgbimhist((uint8_T *)InRed, (uint8_T *)InGreen, (uint8_T *)InBlue, (double *)Out);
        break;
    default:
        mexErrMsgIdAndTxt("Images:rgbimhistmex:invalidMexInput",
                          "Image should be uint8 or logical.");
        break;
    }

    return(outputImage);
}

//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
RgbImhist::RgbImhist()
{
    //Initialize member variables
    fImageRed     = NULL;
    fImageGreen   = NULL;
    fImageBlue    = NULL;
    fNBins           = 0;

}

//////////////////////////////////////////////////////////////////////////////
// original image (red plane)
//////////////////////////////////////////////////////////////////////////////
void RgbImhist::setImageRed(const mxArray *origImageRed)
{
    fImageRed = origImageRed;
}

//////////////////////////////////////////////////////////////////////////////
// original image (green plane)
//////////////////////////////////////////////////////////////////////////////
void RgbImhist::setImageGreen(const mxArray *origImageGreen)
{
    fImageGreen = origImageGreen;
}

//////////////////////////////////////////////////////////////////////////////
// original image (blue plane)
//////////////////////////////////////////////////////////////////////////////
void RgbImhist::setImageBlue(const mxArray *origImageBlue)
{
    fImageBlue = origImageBlue;
}

//////////////////////////////////////////////////////////////////////////////
// Number of Bins (int)
//////////////////////////////////////////////////////////////////////////////
void RgbImhist::setNBins(const mxArray *nBins)
{
    fNBins = (int)mxGetScalar(nBins);
}

//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
RgbImhist rgbImhist;

extern "C"
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    (void) nlhs;  // unused parameter

    if (nrhs != 4)
    {
        mexErrMsgIdAndTxt("Images:rgbimhistmex:invalidNumInputs",
                          "%s",
                          "RGBIMHISTMEX needs 4 input arguments.");
    }

    rgbImhist.setImageRed(prhs[0]);
    rgbImhist.setImageGreen(prhs[1]);
    rgbImhist.setImageBlue(prhs[2]);
    rgbImhist.setNBins(prhs[3]);

    //Filter the image
    plhs[0] = rgbImhist.evaluate();
}
