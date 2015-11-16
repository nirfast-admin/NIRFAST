#include "mex.h"
#include <vector>
#include <cmath>
#include <limits>
#include "vector.h"
#include <iostream>
#include <assert.h>
#include "geomath.h"


template<class T> inline T sqr(T x) { return (x)*(x); }
template<class T> inline T length(T x,T y,T z) { return sqrt(sqr(x)+sqr(y)+sqr(z)); }

struct points {
    double c[3];
};

struct crossed_facets {
	std::vector<ULONG> facets;
	std::vector<points> int_points;
};

unsigned char isinvolume_randRay(double *p0, const mxArray *mxP, const mxArray *mxT, double tiny, 
					   double *facets_bbx, int numPerturb, double minX, double maxX,
					   std::vector<ULONG>& int_facets, std::vector<points>& int_points);
