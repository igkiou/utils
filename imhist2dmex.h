#ifndef _IMHIST2DMEX_H
#define _IMHIST2DMEX_H
#include "mex.h"
#include <math.h>

class Imhist2d
{
  private:

    //Member variables
    //////////////////

    const mxArray *fImage1;
    const mxArray *fImage2;
          int     fNBins;

    //Template method
    /////////////////////

    //////////////////////////////////////////////////////////////////////////
    //  local_rgbimhist calculates the imhist of a neighborhood
    //  around every pixel
    /////////////////////////////////////////////////////////////////////////

    template< typename _T >
        void local_imhist2d(_T *inBuf1, _T *inBuf2, double *outBuf)
        {
            const mwSize      numElements  = mxGetNumberOfElements(fImage1);
			const int         numBins      = fNBins;
            mwSize			p;
			
            for (p = 0; p < numElements; p++)
            {
				outBuf[((int)inBuf1[p]) + numBins * ((int)inBuf2[p])]++;
            }
        }

 public:

    Imhist2d();

    void setImage1(const mxArray *padImage1);
    void setImage2(const mxArray *padImage2);
    void setNBins(const mxArray *numBins);

    mxArray *evaluate(void);
};

#endif
