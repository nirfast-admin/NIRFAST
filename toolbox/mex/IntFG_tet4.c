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
  int ele, i, j, k, index[4]; 
  double indextmp, val;

  for (ele=0; ele<elemm; ++ele){
    for (i=0; i<elemn; ++i){
      indextmp = *(elements+(ele+(i*elemm)));
      index[i] = indextmp;
    }

    for (i=0; i<4; ++i){
      for (j=0; j<4; ++j){
	for (k=0; k<4; ++k){
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
  /* this code rewritten for efficiency:
  double intfff;
  static double full_intf0ff[4][4] = {{6/120., 2/120., 2/120., 2/120.}, \
				      {2/120., 2/120., 1/120., 1/120.}, \
				      {2/120., 1/120., 2/120., 1/120.}, \
				      {2/120., 1/120., 1/120., 2/120.}};
  static double full_intf1ff[4][4] = {{2/120., 2/120., 1/120., 1/120.}, \
				      {2/120., 6/120., 2/120., 2/120.}, \
				      {1/120., 2/120., 2/120., 1/120.}, \
				      {1/120., 2/120., 1/120., 2/120.}};
  static double full_intf2ff[4][4] = {{2/120., 1/120., 2/120., 1/120.}, \
				      {1/120., 2/120., 2/120., 1/120.}, \
				      {2/120., 2/120., 6/120., 2/120.}, \
				      {1/120., 1/120., 2/120., 2/120.}};
  static double full_intf3ff[4][4] = {{2/120., 1/120., 1/120., 2/120.}, \
				      {1/120., 2/120., 1/120., 2/120.}, \
				      {1/120., 1/120., 2/120., 2/120.}, \
				      {2/120., 2/120., 2/120., 6/120.}};
  if (i == 0)
    intfff = full_intf0ff[j][k];
  else if (i == 1)
    intfff = full_intf1ff[j][k];
  else if (i == 2)
    intfff = full_intf2ff[j][k];
  else
    intfff = full_intf3ff[j][k];
  return intfff;*/
  
	if (i == j && j == k) return 0.05;
	else
	{
		if (j == k || j == i || k == i) return 0.01666666667;
		else return 0.00833333333;
	}	
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
