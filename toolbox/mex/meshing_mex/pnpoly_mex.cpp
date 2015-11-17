#include "mex.h"
#ifndef TinyZero
#define TinyZero 1e-10
#endif 

// inflag = pnpoly_mex(vertx, verty, testx, testy)
// returns 1 if (testx,testy) is inside polygin defined by points in vectors
// vertx and verty

// To mex under all platforms:
// mex -v pnpoly_mex.cpp

int pnpoly(int nvert, double *vertx, double *verty, double testx, double testy);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    if (nlhs!=1 || nrhs!=4)
        mexErrMsgTxt("pnpoly_mex: needs 4 input and 1 output\n");
    
    unsigned long nvert = mxGetM(prhs[0]);
    if (mxGetM(prhs[1])!=nvert)
        mexErrMsgTxt("pnpoly_mex: vertx and verty are not the same size\n");
    unsigned long ntest = mxGetM(prhs[2]);
    
    double *vertx = mxGetPr(prhs[0]);
    double *verty = mxGetPr(prhs[1]);
    double *testx = mxGetPr(prhs[2]);
    double *testy = mxGetPr(prhs[3]);
    
    // Output variable
    plhs[0] = mxCreateNumericMatrix(ntest, 1, mxINT8_CLASS, mxREAL);
	char *c = (char *) mxGetData(plhs[0]);
    
    for (unsigned long i=0; i<ntest; ++i) {
        *(c+i) = pnpoly(nvert,vertx,verty,testx[i],testy[i]);
    }
}
int pnpoly(int nvert, double *vertx, double *verty, double testx, double testy)
{
  int i, j, c = 0;
  for (i = 0, j = nvert-1; i < nvert; j = i++) {
    if ( ((verty[i]>testy) != (verty[j]>testy)) &&
	 (testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]) )
       c = !c;
  }
  return c;
}