// $Revision: 1.1.8.2 $
// Copyright 1993-2007 The MathWorks, Inc.

#ifndef _IMCORRELATIONMEX_H
#define _IMCORRELATIONMEX_H

#include "mex.h"
#include <math.h>
#include "/usr/local/matlabR2008a/toolbox/images/images/private/neighborhood.h"

class ImCorrelation
{
  private:

    //Member variables
    //////////////////

    const mxArray *fImage1;
    const mxArray *fImage2;
    const mxArray *fImageSize;
    const mxArray *fNHood;

    //Template method
    /////////////////////

    //////////////////////////////////////////////////////////////////////////
    //  local_correlation calculates the entropy of a neighborhood 
    //  around every pixel 
    /////////////////////////////////////////////////////////////////////////

    template< typename _T >
        void local_correlation(_T *inBuf1, _T *inBuf2, double *outBuf)
        {
            const mwSize      numElements  = mxGetNumberOfElements(fImage1);
            const mwSize      numDims   = mxGetNumberOfDimensions(fImage1);
            mwSize           *size      = (mwSize *) mxMalloc(numDims * sizeof(mwSize));
            double           *pr           = (double *) mxGetData(fImageSize);

            for (mwSize p = 0; p < numDims; p++)
            {
                size[p] = (mwSize) pr[p];
//				mexPrintf("size %d: %d\n",p,size[p]);
            }

		    mwSize         p;
            mwSize         n;

            Neighborhood_T       nHood;
            NeighborhoodWalker_T walker;

      
            //Create Walker
            nHood = nhMakeNeighborhood(fNHood, NH_CENTER_MIDDLE_ROUNDDOWN);
            walker = nhMakeNeighborhoodWalker(nHood, size, numDims,
                                              NH_USE_ALL);
      
            //Go to every pixel in the padded image, and get the indices of its
            //neighbors.  Use the indices to calculate the histogram counts and
            //then the entropy of that neighborhood.

			double sum_sq_x, sum_sq_y, sum_coproduct;
			double mean_x, mean_y;
			int index;
			double sweep;
			double delta_x, delta_y;
			double pop_sd_x, pop_sd_y, cov_x_y;
			double correlation;
			
            for (p = 0; p < numElements; p++)
            {       
//				mexPrintf("pixel %d: %lf %lf\n",p,inBuf1[p],inBuf2[p]);
				sum_sq_x = 0;
				sum_sq_y = 0;
				sum_coproduct = 0;
					
                nhSetWalkerLocation(walker,p);
				nhGetNextInboundsNeighbor(walker, &n, NULL);
				mean_x = inBuf1[n];
				mean_y = inBuf2[n];
				index = 1;
//				mexPrintf("index %d pixel %d: %lf %lf\n",index,n,inBuf1[n],inBuf2[n]);

				while (nhGetNextInboundsNeighbor(walker, &n, NULL))
                {
					index++;
//					mexPrintf("index %d pixel %d: %lf %lf\n",index,n,inBuf1[n],inBuf2[n]);
					sweep = (index - 1.0) / index;
					delta_x = inBuf1[n] - mean_x;
					delta_y = inBuf2[n] - mean_y;
					sum_sq_x = sum_sq_x + delta_x * delta_x * sweep;
					sum_sq_y = sum_sq_y + delta_y * delta_y * sweep;
					sum_coproduct = sum_coproduct + delta_x * delta_y * sweep;
					mean_x = mean_x + delta_x / index;
					mean_y = mean_y + delta_y / index; 
                }				
				pop_sd_x = sqrt( sum_sq_x / index );
				pop_sd_y = sqrt( sum_sq_y / index );
				cov_x_y = sum_coproduct / index;
				correlation = cov_x_y / (pop_sd_x * pop_sd_y);
				outBuf[p] = correlation;
            }

            // Clean up
            nhDestroyNeighborhood(nHood);
            nhDestroyNeighborhoodWalker(walker);
            mxFree(size);
        }

 public:

    ImCorrelation();
    
    void setImage1(const mxArray *image1);
    void setImage2(const mxArray *image2);
    void setImageSize(const mxArray *size);
    void setNHood(const mxArray *nHood);

    mxArray *evaluate(void);
};

#endif
