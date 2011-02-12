#ifndef _RGBIMHISTMEX_H
#define _RGBIMHISTMEX_H
#include "mex.h"
#include <math.h>

class RgbImhist
{
  private:

    //Member variables
    //////////////////

    const mxArray *fImageRed;
    const mxArray *fImageGreen;
    const mxArray *fImageBlue;
          int     fNBins;

    //Template method
    /////////////////////

    //////////////////////////////////////////////////////////////////////////
    //  local_rgbimhist calculates the imhist of a neighborhood
    //  around every pixel
    /////////////////////////////////////////////////////////////////////////

    template< typename _T >
        void local_rgbimhist(_T *inBufRed, _T *inBufGreen, _T *inBufBlue, double *outBuf)
        {
            const mwSize      numElements  = mxGetNumberOfElements(fImageRed);
			const int         numBins      = fNBins;
            mwSize			p;
			
            for (p = 0; p < numElements; p++)
            {
				outBuf[((int)inBufRed[p]) + numBins * ((int)inBufGreen[p]) + numBins * numBins * ((int)inBufBlue[p])]++;
            }
        }

 public:

    RgbImhist();

    void setImageRed(const mxArray *origImageRed);
    void setImageGreen(const mxArray *origImageGreen);
    void setImageBlue(const mxArray *origImageBlue);
    void setNBins(const mxArray *numBins);

    mxArray *evaluate(void);
};

#endif
