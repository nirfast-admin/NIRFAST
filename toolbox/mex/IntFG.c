#include <stdio.h>
#include <math.h>
#include <mex.h>
double IntFFF(int i, int j, int k);
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
  int ele, i, j, k, indextmp2[3], index[3];
  double indextmp, val;

  for (ele=0; ele<elemm; ++ele){
    for (i=0; i<elemn; ++i){
      indextmp = *(elements+(ele+(i*elemm)));
      index[i] = indextmp;
    }

    for (i=0; i<3; ++i){
      for (j=0; j<3; ++j){
	for (k=0; k<3; ++k){
	  val = IntFFF(i,j,k)* *(element_area+ele);
	  Jr[index[i]-1] +=  ((*(dphir+index[k]-1) * *(aphir+index[j]-1)) - \
			      (*(dphii+index[k]-1) * *(aphii+index[j]-1)))*val;
	  Ji[index[i]-1] +=  ((*(dphir+index[k]-1) * *(aphii+index[j]-1)) + \
			      (*(dphii+index[k]-1) * *(aphir+index[j]-1)))*val;
	}
      }
    }
  }
  return;
}

double IntFFF(int i, int j, int k)
{
  double intfff;
  if (i==j && i==k)
    intfff = 1/10.0;
  else if (i==j || i==k || j==k)
    intfff = 1/30.0;
  else 
    intfff = 1/60.0;
  return intfff;
}

/* -------- Gate-way to matlab  ------------ */

void mexFunction(int nlhs,
mxArray *plhs[],
int nrhs,
const mxArray *prhs[])

{
double *nodes,*elements,*element_area,*dphir,*dphii,*aphir,*aphii;
int nodem,noden,elemm,elemn,i;
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

if (mxIsComplex(prhs[3]))
	dphii=mxGetPi(prhs[3]);          
  else							/*  if there is no complex part, make a new array with zeros */
  {
	dphii=(double*) mxMalloc( mxGetM(prhs[3])*sizeof(double) );
	for (i=0;i<mxGetM(prhs[3]);i=i+1)
		dphii[i] = 0;
  }

aphir=mxGetPr(prhs[4]);           /*  adjoint solution */

if (mxIsComplex(prhs[4]))
	aphii=mxGetPi(prhs[4]);          
  else							/*  if there is no complex part, make a new array with zeros */
  {
	aphii=(double*) mxMalloc( mxGetM(prhs[4])*sizeof(double) );
	for (i=0;i<mxGetM(prhs[4]);i=i+1)
		aphii[i] = 0;
  }


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
