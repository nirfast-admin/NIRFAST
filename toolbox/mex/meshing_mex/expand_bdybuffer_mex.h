#ifndef __expand_bdybuffer_mex
#define __expand_bdybuffer_mex

#include <cmath>
#include <algorithm>
#include <vector>
#include "mex.h"

#include "isinvolume_randRay.h"

//P = expand_bdybuffer_mex(P,prismp,ds,prismbbx,prismfbbx,delta,llc,edgelen,edgeidx,tiny);
#define _edgelen prhs[7]
#define _edgeidx prhs[8]
#define _ds prhs[2]
#define _delta prhs[5]
#define _llc prhs[6]
#define _prismbbx prhs[3]
#define _prismp prhs[1]
#define _prismfbbx prhs[4]
#define _P prhs[0]
#define _tiny prhs[9]
//#define _prismn prhs[]


#define outside 5
#define inside 6
#define NA 3
#define node_code 2
#define boundary_node_code 1
#define on_facet 7

#define round(x) ((long int)((x) > 0.0 ? (x) + 0.5 : (x) - 0.5))


ULONG pconn[8][3] ={{1,           2,           3},
					{4,           6,           5},
					{2,           1,           5},
					{5,           1,           4},
					{3,           2,           6},
					{6,           2,           5},
					{1,           3,           6},
					{6,           4,		   1}};


					
					
void mapxyz2ijk(double inp[3], std::vector<ULONG>& IJK, double *delta, std::vector<int> Psize, double *llc);

#endif
