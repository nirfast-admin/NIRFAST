#include <stdio.h>
#include <math.h>
#include <mex.h>
double Intdd(int i, int j, int k, \
	     double g00, double g01, double g02, \
	     double g10, double g11, double g12, \
	     double g20, double g21, double g22, \
	     double g30, double g31, double g32);
/* -------- Heart of the mex file----------- */
void mainloop(double *nodes,
	      double *elements,
	      double *element_area,
	      double *dphir,
	      double *dphii,
	      double *aphir,
	      double *aphii,
	      double *Jr,
	      double *Ji,
	      int nodem,
	      int noden,
	      int elemm,
	      int elemn)
{
  int ele, i, j, k, index[4]; 
  double tri_vtx[4][3], indextmp, val;

  for (ele=0; ele<elemm; ++ele){
    for (i=0; i<elemn; ++i){
      indextmp = *(elements+(ele+(i*elemm)));
      index[i] = indextmp;
    }

    for (i=0; i<elemn; ++i){
      for (j=0; j<noden; ++j){
	tri_vtx[i][j] = *(nodes+(index[i]-1+(j*nodem)));
      }
    }
    /*mexPrintf("%d %d %d %d\n", index[0], index[1], index[2], index[3]);*/
    /*mexPrintf("%f %f %f\n",tri_vtx[0][0], tri_vtx[0][1], tri_vtx[0][2]);*/
    /*mexPrintf("%f %f %f\n",tri_vtx[1][0], tri_vtx[1][1], tri_vtx[1][2]);*/
    /*mexPrintf("%f %f %f\n",tri_vtx[2][0], tri_vtx[2][1], tri_vtx[2][2]);*/
    /*mexPrintf("%f %f %f\n",tri_vtx[3][0], tri_vtx[3][1], tri_vtx[3][2]);*/
    for (i=0; i<4; ++i){
      for (j=0; j<4; ++j){
	val = Intdd(i,j,j,tri_vtx[0][0],tri_vtx[0][1],tri_vtx[0][2],\
		          tri_vtx[1][0],tri_vtx[1][1],tri_vtx[1][2],\
		          tri_vtx[2][0],tri_vtx[2][1],tri_vtx[2][2],\
		          tri_vtx[3][0],tri_vtx[3][1],tri_vtx[3][2]);
	Jr[index[i]-1] += ((*(dphir+index[j]-1) * *(aphir+index[j]-1)) - \
			   (*(dphii+index[j]-1) * *(aphii+index[j]-1)))*val;
	Ji[index[i]-1] += ((*(dphir+index[j]-1) * *(aphii+index[j]-1)) + \
			   (*(dphii+index[j]-1) * *(aphir+index[j]-1)))*val;
	for (k=0; k<=(j-1); ++k){
	  val = Intdd(i,j,k,tri_vtx[0][0],tri_vtx[0][1],tri_vtx[0][2],\
		            tri_vtx[1][0],tri_vtx[1][1],tri_vtx[1][2],\
		            tri_vtx[2][0],tri_vtx[2][1],tri_vtx[2][2],\
		            tri_vtx[3][0],tri_vtx[3][1],tri_vtx[3][2]);
	  Jr[index[i]-1] += (((*(dphir+index[j]-1) * *(aphir+index[k]-1)) - \
			      (*(dphii+index[j]-1) * *(aphii+index[k]-1))) + \
			     ((*(dphir+index[k]-1) * *(aphir+index[j]-1)) - \
			      (*(dphii+index[k]-1) * *(aphii+index[j]-1))))*val;
	  Ji[index[i]-1] += (((*(dphir+index[j]-1) * *(aphii+index[k]-1)) + \
			      (*(dphii+index[j]-1) * *(aphir+index[k]-1))) + \
			     ((*(dphir+index[k]-1) * *(aphii+index[j]-1)) + \
			      (*(dphii+index[k]-1) * *(aphir+index[j]-1))))*val;
	}
      }
    }
  }
  return;
}

double Intdd(int i, int j, int k, \
	     double x0, double y0, double z0, \
	     double x1, double y1, double z1, \
	     double x2, double y2, double z2, \
	     double x3, double y3, double z3)
{
/*  This part hard coded in for efficiency
  a0 = x1*(y2*z3-y3*z2) - x2*(y1*z3-y3*z1) + x3*(y1*z2-y2*z1)
  a1 = x0*(y3*z2-y2*z3) - x2*(y3*z0-y0*z3) + x3*(y2*z0-y0*z2)
  a2 = x0*(y1*z3-y3*z1) - x1*(y0*z3-y3*z0) + x3*(y0*z1-y1*z0)
  a3 = x0*(y2*z1-y1*z2) - x1*(y2*z0-y0*z2) + x2*(y1*z0-y0*z1)
  b0 = y1*(z3-z2) + y2*(z1-z3) + y3*(z2-z1)
  b1 = y0*(z2-z3) + y2*(z3-z0) + y3*(z0-z2)
  b2 = y0*(z3-z1) + y1*(z0-z3) + y3*(z1-z0)
  b3 = y0*(z1-z2) + y1*(z2-z0) + y2*(z0-z1)
  c0 = x1*(z2-z3) + x2*(z3-z1) + x3*(z1-z2)
  c1 = x0*(z3-z2) + x2*(z0-z3) + x3*(z2-z0)
  c2 = x0*(z1-z3) + x1*(z3-z0) + x3*(z0-z1)
  c3 = x0*(z2-z1) + x1*(z0-z2) + x2*(z1-z0)
  d0 = x1*(y3-y2) + x2*(y1-y3) + x3*(y2-y1)
  d1 = x0*(y2-y3) + x2*(y3-y0) + x3*(y0-y2)
  d2 = x0*(y3-y1) + x1*(y0-y3) + x3*(y1-y0)
  d3 = x0*(y1-y2) + x1*(y2-y0) + x2*(y0-y1)

  size = (1.0/6.0) * (a0+a1+a2+a3)
  scale = 1.0/(144.0*size)
  scale = (1.0/(24.0 * (x1*(y2*z3-y3*z2) - x2*(y1*z3-y3*z1) + x3*(y1*z2-y2*z1)+x0*(y3*z2-y2*z3) - x2*(y3*z0-y0*z3) + x3*(y2*z0-y0*z2)+x0*(y1*z3-y3*z1) - x1*(y0*z3-y3*z0) + x3*(y0*z1-y1*z0)+x0*(y2*z1-y1*z2) - x1*(y2*z0-y0*z2) + x2*(y1*z0-y0*z1))))
  */
  
  /* Note the result is independent of i (the index for 'F')*/
  if (j > k) {int tmp=j; j=k; k=tmp;}   /*symmetry*/
  switch (j) {
  case 0:
    switch (k) {
    case 0: return ((y1*(z3-z2) + y2*(z1-z3) + y3*(z2-z1))*(y1*(z3-z2) + y2*(z1-z3) + y3*(z2-z1))+(x1*(z2-z3) + x2*(z3-z1) + x3*(z1-z2))*(x1*(z2-z3) + x2*(z3-z1) + x3*(z1-z2))+(x1*(y3-y2) + x2*(y1-y3) + x3*(y2-y1))*(x1*(y3-y2) + x2*(y1-y3) + x3*(y2-y1))) * (1.0/(24.0 * (x1*(y2*z3-y3*z2) - x2*(y1*z3-y3*z1) + x3*(y1*z2-y2*z1)+x0*(y3*z2-y2*z3) - x2*(y3*z0-y0*z3) + x3*(y2*z0-y0*z2)+x0*(y1*z3-y3*z1) - x1*(y0*z3-y3*z0) + x3*(y0*z1-y1*z0)+x0*(y2*z1-y1*z2) - x1*(y2*z0-y0*z2) + x2*(y1*z0-y0*z1)))); /* (b0*b0+c0*c0+d0*d0) * scale */
    case 1: return ((y1*(z3-z2) + y2*(z1-z3) + y3*(z2-z1))*(y0*(z2-z3) + y2*(z3-z0) + y3*(z0-z2))+(x1*(z2-z3) + x2*(z3-z1) + x3*(z1-z2))*(x0*(z3-z2) + x2*(z0-z3) + x3*(z2-z0))+(x1*(y3-y2) + x2*(y1-y3) + x3*(y2-y1))*(x0*(y2-y3) + x2*(y3-y0) + x3*(y0-y2))) * (1.0/(24.0 * (x1*(y2*z3-y3*z2) - x2*(y1*z3-y3*z1) + x3*(y1*z2-y2*z1)+x0*(y3*z2-y2*z3) - x2*(y3*z0-y0*z3) + x3*(y2*z0-y0*z2)+x0*(y1*z3-y3*z1) - x1*(y0*z3-y3*z0) + x3*(y0*z1-y1*z0)+x0*(y2*z1-y1*z2) - x1*(y2*z0-y0*z2) + x2*(y1*z0-y0*z1)))); /* (b0*b1+c0*c1+d0*d1) * scale */
    case 2: return ((y1*(z3-z2) + y2*(z1-z3) + y3*(z2-z1))*(y0*(z3-z1) + y1*(z0-z3) + y3*(z1-z0))+(x1*(z2-z3) + x2*(z3-z1) + x3*(z1-z2))*(x0*(z1-z3) + x1*(z3-z0) + x3*(z0-z1))+(x1*(y3-y2) + x2*(y1-y3) + x3*(y2-y1))*(x0*(y3-y1) + x1*(y0-y3) + x3*(y1-y0))) * (1.0/(24.0 * (x1*(y2*z3-y3*z2) - x2*(y1*z3-y3*z1) + x3*(y1*z2-y2*z1)+x0*(y3*z2-y2*z3) - x2*(y3*z0-y0*z3) + x3*(y2*z0-y0*z2)+x0*(y1*z3-y3*z1) - x1*(y0*z3-y3*z0) + x3*(y0*z1-y1*z0)+x0*(y2*z1-y1*z2) - x1*(y2*z0-y0*z2) + x2*(y1*z0-y0*z1)))); /* (b0*b2+c0*c2+d0*d2) * scale */
    case 3: return ((y1*(z3-z2) + y2*(z1-z3) + y3*(z2-z1))*(y0*(z1-z2) + y1*(z2-z0) + y2*(z0-z1))+(x1*(z2-z3) + x2*(z3-z1) + x3*(z1-z2))*(x0*(z2-z1) + x1*(z0-z2) + x2*(z1-z0))+(x1*(y3-y2) + x2*(y1-y3) + x3*(y2-y1))*(x0*(y1-y2) + x1*(y2-y0) + x2*(y0-y1))) * (1.0/(24.0 * (x1*(y2*z3-y3*z2) - x2*(y1*z3-y3*z1) + x3*(y1*z2-y2*z1)+x0*(y3*z2-y2*z3) - x2*(y3*z0-y0*z3) + x3*(y2*z0-y0*z2)+x0*(y1*z3-y3*z1) - x1*(y0*z3-y3*z0) + x3*(y0*z1-y1*z0)+x0*(y2*z1-y1*z2) - x1*(y2*z0-y0*z2) + x2*(y1*z0-y0*z1)))); /* (b0*b3+c0*c3+d0*d3) * scale */
    }
  case 1:
    switch (k) {
    case 1: return ((y0*(z2-z3) + y2*(z3-z0) + y3*(z0-z2))*(y0*(z2-z3) + y2*(z3-z0) + y3*(z0-z2))+(x0*(z3-z2) + x2*(z0-z3) + x3*(z2-z0))*(x0*(z3-z2) + x2*(z0-z3) + x3*(z2-z0))+(x0*(y2-y3) + x2*(y3-y0) + x3*(y0-y2))*(x0*(y2-y3) + x2*(y3-y0) + x3*(y0-y2))) * (1.0/(24.0 * (x1*(y2*z3-y3*z2) - x2*(y1*z3-y3*z1) + x3*(y1*z2-y2*z1)+x0*(y3*z2-y2*z3) - x2*(y3*z0-y0*z3) + x3*(y2*z0-y0*z2)+x0*(y1*z3-y3*z1) - x1*(y0*z3-y3*z0) + x3*(y0*z1-y1*z0)+x0*(y2*z1-y1*z2) - x1*(y2*z0-y0*z2) + x2*(y1*z0-y0*z1)))); /* (b1*b1+c1*c1+d1*d1) * scale */
    case 2: return ((y0*(z2-z3) + y2*(z3-z0) + y3*(z0-z2))*(y0*(z3-z1) + y1*(z0-z3) + y3*(z1-z0))+(x0*(z3-z2) + x2*(z0-z3) + x3*(z2-z0))*(x0*(z1-z3) + x1*(z3-z0) + x3*(z0-z1))+(x0*(y2-y3) + x2*(y3-y0) + x3*(y0-y2))*(x0*(y3-y1) + x1*(y0-y3) + x3*(y1-y0))) * (1.0/(24.0 * (x1*(y2*z3-y3*z2) - x2*(y1*z3-y3*z1) + x3*(y1*z2-y2*z1)+x0*(y3*z2-y2*z3) - x2*(y3*z0-y0*z3) + x3*(y2*z0-y0*z2)+x0*(y1*z3-y3*z1) - x1*(y0*z3-y3*z0) + x3*(y0*z1-y1*z0)+x0*(y2*z1-y1*z2) - x1*(y2*z0-y0*z2) + x2*(y1*z0-y0*z1)))); /* (b1*b2+c1*c2+d1*d2) * scale */
    case 3: return ((y0*(z2-z3) + y2*(z3-z0) + y3*(z0-z2))*(y0*(z1-z2) + y1*(z2-z0) + y2*(z0-z1))+(x0*(z3-z2) + x2*(z0-z3) + x3*(z2-z0))*(x0*(z2-z1) + x1*(z0-z2) + x2*(z1-z0))+(x0*(y2-y3) + x2*(y3-y0) + x3*(y0-y2))*(x0*(y1-y2) + x1*(y2-y0) + x2*(y0-y1))) * (1.0/(24.0 * (x1*(y2*z3-y3*z2) - x2*(y1*z3-y3*z1) + x3*(y1*z2-y2*z1)+x0*(y3*z2-y2*z3) - x2*(y3*z0-y0*z3) + x3*(y2*z0-y0*z2)+x0*(y1*z3-y3*z1) - x1*(y0*z3-y3*z0) + x3*(y0*z1-y1*z0)+x0*(y2*z1-y1*z2) - x1*(y2*z0-y0*z2) + x2*(y1*z0-y0*z1)))); /* (b1*b3+c1*c3+d1*d3) * scale */
    }
  case 2:
    switch (k) {
    case 2: return ((y0*(z3-z1) + y1*(z0-z3) + y3*(z1-z0))*(y0*(z3-z1) + y1*(z0-z3) + y3*(z1-z0))+(x0*(z1-z3) + x1*(z3-z0) + x3*(z0-z1))*(x0*(z1-z3) + x1*(z3-z0) + x3*(z0-z1))+(x0*(y3-y1) + x1*(y0-y3) + x3*(y1-y0))*(x0*(y3-y1) + x1*(y0-y3) + x3*(y1-y0))) * (1.0/(24.0 * (x1*(y2*z3-y3*z2) - x2*(y1*z3-y3*z1) + x3*(y1*z2-y2*z1)+x0*(y3*z2-y2*z3) - x2*(y3*z0-y0*z3) + x3*(y2*z0-y0*z2)+x0*(y1*z3-y3*z1) - x1*(y0*z3-y3*z0) + x3*(y0*z1-y1*z0)+x0*(y2*z1-y1*z2) - x1*(y2*z0-y0*z2) + x2*(y1*z0-y0*z1)))); /* (b2*b2+c2*c2+d2*d2) * scale */
    case 3: return ((y0*(z3-z1) + y1*(z0-z3) + y3*(z1-z0))*(y0*(z1-z2) + y1*(z2-z0) + y2*(z0-z1))+(x0*(z1-z3) + x1*(z3-z0) + x3*(z0-z1))*(x0*(z2-z1) + x1*(z0-z2) + x2*(z1-z0))+(x0*(y3-y1) + x1*(y0-y3) + x3*(y1-y0))*(x0*(y1-y2) + x1*(y2-y0) + x2*(y0-y1))) * (1.0/(24.0 * (x1*(y2*z3-y3*z2) - x2*(y1*z3-y3*z1) + x3*(y1*z2-y2*z1)+x0*(y3*z2-y2*z3) - x2*(y3*z0-y0*z3) + x3*(y2*z0-y0*z2)+x0*(y1*z3-y3*z1) - x1*(y0*z3-y3*z0) + x3*(y0*z1-y1*z0)+x0*(y2*z1-y1*z2) - x1*(y2*z0-y0*z2) + x2*(y1*z0-y0*z1)))); /* (b2*b3+c2*c3+d2*d3) * scale */
	}
  case 3:
    switch (k) {
    case 3: return ((y0*(z1-z2) + y1*(z2-z0) + y2*(z0-z1))*(y0*(z1-z2) + y1*(z2-z0) + y2*(z0-z1))+(x0*(z2-z1) + x1*(z0-z2) + x2*(z1-z0))*(x0*(z2-z1) + x1*(z0-z2) + x2*(z1-z0))+(x0*(y1-y2) + x1*(y2-y0) + x2*(y0-y1))*(x0*(y1-y2) + x1*(y2-y0) + x2*(y0-y1))) * (1.0/(24.0 * (x1*(y2*z3-y3*z2) - x2*(y1*z3-y3*z1) + x3*(y1*z2-y2*z1)+x0*(y3*z2-y2*z3) - x2*(y3*z0-y0*z3) + x3*(y2*z0-y0*z2)+x0*(y1*z3-y3*z1) - x1*(y0*z3-y3*z0) + x3*(y0*z1-y1*z0)+x0*(y2*z1-y1*z2) - x1*(y2*z0-y0*z2) + x2*(y1*z0-y0*z1)))); /* (b3*b3+c3*c3+d3*d3) * scale */
    }
  }
  return;
}

/* -------- Gate-way to matlab  ------------ */

void mexFunction(int nlhs,
mxArray *plhs[],
int nrhs,
const mxArray *prhs[])

{
double *nodes,*elements,*element_area,*dphir,*dphii,*aphir,*aphii;
int nodem,noden,elemm,elemn;
double *Jr, *Ji;

/* Error checking  */

if (nrhs < 5 )
    mexErrMsgTxt(" There is not enough input arguments");

if(nlhs!=1)
   mexErrMsgTxt("This routine requires one ouput arguments");

nodes=mxGetPr(prhs[0]);          /*  nodes of mesh */
elements=mxGetPr(prhs[1]);       /*  elements of mesh */
element_area=mxGetPr(prhs[2]);   /*  area of elements */
dphir=mxGetPr(prhs[3]);           /*  direct solution */
dphii=mxGetPi(prhs[3]);           /*  direct solution */
aphir=mxGetPr(prhs[4]);           /*  adjoint solution */
aphii=mxGetPi(prhs[4]);           /*  adjoint solution */

nodem=mxGetM(prhs[0]);          /*  Number of rows of nodes */
noden=mxGetN(prhs[0]);          /*  Number of cols of nodes */
elemm=mxGetM(prhs[1]);           /*  Number of rows of elements */
elemn=mxGetN(prhs[1]);           /*  Number of cols of elements */


plhs[0]=mxCreateDoubleMatrix(nodem,1,mxCOMPLEX); /* vector to return to Matlab */

Jr=mxGetPr(plhs[0]);
Ji=mxGetPi(plhs[0]);
      
mainloop(nodes,elements,element_area,dphir,dphii,aphir,aphii,Jr,Ji,nodem,noden,elemm,elemn);

return;
}
