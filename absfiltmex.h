#ifndef _ABSFILTMEX_H
#define _ABSFILTMEX_H
// #define _DEBUG
#include "mex.h"
#include <math.h>
#include "/usr/local/matlabR2008a/toolbox/images/images/private/neighborhood.h"
#define ABSOLUTE(a,b) ((a)>(b)?(a-b):(b-a))
//#include "neighborhood.h"

class AbsFilter
{
  private:

    //Member variables
    //////////////////

    const mxArray *fPadImage;
    const mxArray *fMeanImage;
    const mxArray *fPadImageSize;
    const mxArray *fNHood;

    //Template method
    /////////////////////

    //////////////////////////////////////////////////////////////////////////
    //  local_abs calculates the abs of a neighborhood
    //  around every pixel
    /////////////////////////////////////////////////////////////////////////

    template< typename _T >
        void local_abs(_T *inBuf, double *meanBuf, double *outBuf)
        {
            const mwSize      numElements  = mxGetNumberOfElements(fPadImage);
            const mwSize      numPadDims   = mxGetNumberOfDimensions(fPadImage);
			mwSize           *padSize      = (mwSize *) mxMalloc(numPadDims * sizeof(mwSize));
            double           *pr           = (double *) mxGetData(fPadImageSize);

            for (mwSize p = 0; p < numPadDims; p++)
            {
                padSize[p] = (mwSize) pr[p];
			}
			
            double         mean;
            double         accum;

            mwSize         numNeighbors;
            mwSize         n;

            Neighborhood_T       nHood;
            NeighborhoodWalker_T walker;

            mwSize           p;
#ifdef _DEBUG
			int				num;
#endif

            //Create Walker
            nHood = nhMakeNeighborhood(fNHood, NH_CENTER_MIDDLE_ROUNDDOWN);

            walker = nhMakeNeighborhoodWalker(nHood, padSize, numPadDims,
                                              NH_USE_ALL);
            numNeighbors = nhGetNumNeighbors(walker);

            //Go to every pixel in the padded image, and get the indices of its
            //neighbors.  Use the indices to calculate the histogram counts and
            //then the abs of that neighborhood.

            for (p = 0; p < numElements; p++)
            {
                nhSetWalkerLocation(walker,p);
				mean = meanBuf[p];
				accum = 0;
#ifdef _DEBUG
				num = 0;			
#endif
				
                // Get Idx into image
                while (nhGetNextInboundsNeighbor(walker, &n, NULL))
                {
#ifdef _DEBUG
					num++;
					if(p==numElements / 2)
						mexPrintf("accum before %lg pixel %d ", accum,num);				
#endif
					accum += ABSOLUTE((double)inBuf[n], mean);
#ifdef _DEBUG
					if(p==numElements / 2)
						mexPrintf("n %d inBuf %lg meanBuf %lg diff %lg accum %lg\n",n,(double)inBuf[n],mean,ABSOLUTE((double)inBuf[n], mean),accum);
#endif
                }
				accum = accum / numNeighbors;
				outBuf[p] = accum;
            }

            // Clean up
            nhDestroyNeighborhood(nHood);
            nhDestroyNeighborhoodWalker(walker);
            mxFree(padSize);
        }

 public:

    AbsFilter();

    void setPadImage(const mxArray *padImage);
    void setMeanImage(const mxArray *meanImage);
    void setPadImageSize(const mxArray *padSize);
    void setNHood(const mxArray *nHood);

    mxArray *evaluate(void);
};

#endif
