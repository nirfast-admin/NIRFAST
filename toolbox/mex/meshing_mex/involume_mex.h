#ifndef __involume_mex_h
#define __involume_mex_h
#include "mex.h"
#include <vector>
#include <cmath>
#include <limits>
#include "vector.h"
#include <iostream>
#include <assert.h>
#include "geomath.h"
//#include "isinvolume_randRay.h"
template<class T> inline T sqr(T x) { return (x)*(x); }
template<class T> inline T length(T x,T y,T z) { return sqrt(sqr(x)+sqr(y)+sqr(z)); }

struct points {
    double c[3];
};

unsigned char isinvolume_randRay(double *p0, double *pp, unsigned long npp,
					   double *tt, unsigned long nee, double tiny,
					   double *myfacets_bbx, int numPerturb, double minX, double maxX,
					std::vector<ULONG>& int_facets, std::vector<points>& int_points);
					
#define _inqp     prhs[0]
#define _inele    prhs[1]
#define _innode   prhs[2]
#define _inntries    prhs[3]
#define _infacets  prhs[4]
#define _inxmin    prhs[5]
#define _inxmax    prhs[6]
#define _intiny prhs[7]


#define _outst        plhs[0]

#endif
