#ifndef __PointInPolyhedron_mex_h
#define __PointInPolyhedron_mex_h

#include "polyhedron2BSP.h"

#include "mex.h"

#ifndef TinyZero
#define TinyZero 1e-10
#endif 


bool CheckArgsIn(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);

#endif
