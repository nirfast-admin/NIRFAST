/**
* main_build_matrix.c
* FUNCTIONS: 
*	main_build_matrix 	-Entry point of console application
*
* Serves as entry point for application
* 
* Written By: 
*	Senate Taka from a translation of a fortran-90 program
* 	that does the same thing. Original fortran code by Subha
*
* For:
*	NIR Dartmouth College 2008
*
* Created: 05 Sept 2008
* Modified: Hamid Ghadyani, March 2009
*           Most of the input arguments are not duplicated within mex file anymore.
*           Fixed seg. fault crashes under Windows
*/
#include "bem.h"
//#include "CStopWatch.h"
char first_time = 1;

#define nodes(i,j)    nodes[(i)+ nnod*(j)]
#define nod_list(i,j) nod_list[(i)+ num_nodes*(j)]
#define elements(i,j) elements[(i)+nelem*(j)]
#define elem_list(i,j) elem_list[(i)+num_elem*(j)]
#define nodes_reg(i,j) nodes_reg[(i)+nnod_reg*(j)]

/***************************************************************************
* this function is called by the mexFunction below.
* It is based on the fortran90 function of the same name.
* parameter types are declared based on that code, and according to 
* the fortran90-C conversion template provided at 
*	http://docs.hp.com/en/B3909-90002/ch08s01.html
*
* Complex numbers are however represented with the mxArray matlab data
* type, and matlab functions are used to manipulate it
*
* @param nodes: (real*8 array)
* @param elements: (integer array)
* @param nodes_reg: (real*8 2D array)
* @param inreg: (integer array)
* @param nnod: (integer)
* @param nnod_reg: (integer)
* @param nelem: (integer)
* @param omega: (complex*16)
* @param D: (real*8)
* @param source: (real*8 array)
* @param reg: (integer)
* @param int_angle: (complex*18 array)
* @param A: (complex*16 2D array)
* @param B: (complex*16 2D array)
*
******************************************************************************/
void main_build_matrix(double *nodes, double *elements, double *nodes_reg,
          double *inreg, long nnod, long nnod_reg, long nelem, mxArray *omega, 
	            double D, double *source, long reg, mxArray *int_angle,
	  mxArray *A, mxArray *B) {

	/* local variables */
	const int ngp = 4;
	double xi, yi, zi, xel[3], yel[3], zel[3];
	mxArray *source_strength, *integral_value;
	/*double delG[nelem], normal_x[nelem];
	double normal_y[nelem], normal_z[nelem];
	double eta1[ngp], eta2[ngp], w[ngp];*/
	long inod, j, i, el, jel[3], nn;
	double *b_real, *b_img, *a_real, *a_img;
	double *b_real_temp, *a_real_temp, *a_img_temp, *b_img_temp;
	double *iangle_real, *iangle_img, *int_val_real, *int_val_img;
	
	double *delG = new double[nelem];
    double * normal_x = new double[nelem];
    double *normal_y = new double[nelem];
    double *normal_z = new double[nelem];
    double *eta1 = new double[ngp];
    double *eta2 = new double[ngp];
    double *w = new double[ngp];
	
	/* allocate mem for source_strength, initialize */
	source_strength = mxCreateDoubleMatrix(1, 1, mxCOMPLEX);
	mxAssert(source_strength != NULL, "failed to allocate memory for source_strength\n");
	
	*(mxGetPr(source_strength)) = 12.4253;
	*(mxGetPi(source_strength)) = 1.8779;
	
	
	/* initializing gauss points TODO: Is setting eta1 etc to 0 zeroing them? (they 
	   are doubles!!) */
	/*memset((void *)eta1, 0, ngp*sizeof(double));
	memset((void *)eta2, 0, ngp*sizeof(double));
	memset((void *)w, 0, ngp*sizeof(double));*/
	for(i=0; i<ngp; ++i)
		*(eta1+i) = *(eta2+i) = *(w+i) = 0.0;
	
	/* getting gauss points for linear triangular element */
	
	/* mexPrintf("Getting gausspoints\n"); */
	get_gausspts_3d(eta1, eta2, w, ngp);

	/* initialize A, B complex matrices. mxCreateDoubleMatrix sets all elements of
	  of the returned matrices to 0.0 (for both real and img parts) */
	
	integral_value =  mxCreateDoubleMatrix(3, 1, mxCOMPLEX);
	assert(A != NULL && B != NULL && integral_value != NULL);
	
	/* initializing area and normals of element. TODO: again, does memset work here??? */
	/*memset((void *)delG, 0, nelem*sizeof(double));
	memset((void *)normal_x, 0, nelem*sizeof(double));
	memset((void *)normal_y, 0, nelem*sizeof(double));
	memset((void *)normal_z, 0, nelem*sizeof(double));*/
	/* for(i=0; i<nelem; ++i)
		*(delG+i) = *(normal_x+i) = *(normal_y+i) = *(normal_z+i) = 0.0; */

	/* getting area and normals */
	/* mexPrintf("Getting Area and Normals\n"); */
	get_area_normals(elements, nodes, nelem, nnod, delG, normal_x, normal_y, normal_z);

	/* process the results from get_area_normals. */
	int_val_real = 	mxGetPr(integral_value);
	int_val_img = 	mxGetPi(integral_value);
	iangle_real = 	mxGetPr(int_angle);
	iangle_img = 	mxGetPi(int_angle);
	a_real = (double*) mxGetPr(A);
	b_real = (double*) mxGetPr(B);
	a_img =  (double*) mxGetPi(A);
	b_img =  (double*) mxGetPi(B);
	int count = 0;	
 	/* mexPrintf(" nnod_reg is %ld\n", nnod_reg); */
/*
	CStopWatch looptimer;
			looptimer.startTimer();*/
	for(nn = 0; nn < nnod_reg; ++nn) {
		
		for(el = 0; el < nelem; ++el) {
			jel[0] = (long) elements(el,1);	
			jel[1] = (long) elements(el,2);
			jel[2] = (long) elements(el,3);
			xel[0] = nodes(jel[0]-1,0);
			xel[1] = nodes(jel[1]-1,0);
			xel[2] = nodes(jel[2]-1,0);
			yel[0] = nodes(jel[0]-1,1);
			yel[1] = nodes(jel[1]-1,1);
			yel[2] = nodes(jel[2]-1,1);
			zel[0] = nodes(jel[0]-1,2);
			zel[1] = nodes(jel[1]-1,2);
			zel[2] = nodes(jel[2]-1,2);
			inod = (long) inreg[nn];
 
			
			 if(inod == jel[0]){
				for(j=0; j<3; *(int_val_real+j)=0.0, *(int_val_img+j)=0.0, ++j)
						; /* empty body */
				singular_integrand_polar(integral_value, omega, D, delG[el],
							eta1, eta2, w, ngp); 
				
				/*NOTE C arrays are zero indexed, and so instead of writing 
				 B[inod, jel[1]], (as f90 code orig. had), we write 
				 B[inod-1][jel[0]-1]. */
				
				/* B[inod-1][jel[0]-1] += integral_value[0] */
				b_real_temp = get_2DPtr(inod-1, (jel[0]-1), nnod, b_real);
				b_img_temp = get_2DPtr(inod-1, (jel[0]-1), nnod, b_img);
				*b_real_temp += *(int_val_real+0); *b_img_temp += *(int_val_img+0);
				
				/* B[inod-1][jel[1]-1] += integral_value[1] */
				b_real_temp = get_2DPtr(inod-1, (jel[1]-1), nnod, b_real);
				b_img_temp = get_2DPtr(inod-1, (jel[1]-1), nnod, b_img);
			 	*b_real_temp += *(int_val_real+1); *b_img_temp += *(int_val_img+1);

				/* B[inod-1][jel[2]-1] += integral_value[2]*/
				b_real_temp = get_2DPtr(inod-1, (jel[2]-1), nnod, b_real);
				b_img_temp = get_2DPtr(inod-1, (jel[2]-1), nnod, b_img);
			 	*b_real_temp += *(int_val_real+2); *b_img_temp += *(int_val_img+2);
				
			/**/ } /* endif == 1 */
				
		      	else if(inod == jel[1]) {
				for(j=0; j<3; *(int_val_real+j)=0.0, *(int_val_img+j)=0.0, ++j)
						; /* empty body */
				singular_integrand_polar(integral_value, omega, D, delG[el],
							eta1, eta2, w, ngp);

				/* B[inod-1][jel[0]-1] += integral_value[2] */
				b_real_temp = get_2DPtr(inod-1, (jel[0]-1), nnod, b_real);
				b_img_temp = get_2DPtr(inod-1, (jel[0]-1), nnod, b_img);
				*b_real_temp += *(int_val_real+2); *b_img_temp += *(int_val_img+2);
				
				/* B[inod-1][jel[1]-1] += integral_value[0] */
			        b_real_temp = get_2DPtr(inod-1, (jel[1]-1), nnod, b_real);
				b_img_temp = get_2DPtr(inod-1, (jel[1]-1), nnod, b_img);
			 	*b_real_temp += *(int_val_real+0); *b_img_temp += *(int_val_img+0);

				/* B[inod-1][jel[2]-1] += integral_value[1] */
				b_real_temp = get_2DPtr(inod-1, (jel[2]-1), nnod, b_real);
				b_img_temp = get_2DPtr(inod-1, (jel[2]-1), nnod, b_img);
			 	*b_real_temp += *(int_val_real+1); *b_img_temp += *(int_val_img+1);
			/* */  } /*endif jel[1] == 2 */
			
			else if(inod == jel[2]) {
				for(j=0; j<3; *(int_val_real+j)=0.0, *(int_val_img+j)=0.0, ++j)
						; /* empty body */
				singular_integrand_polar(integral_value, omega, D, delG[el],
							eta1, eta2, w, ngp);

				/* bptr[inod-1][jel[0]-1] += integral_value[1] */
				b_real_temp = get_2DPtr(inod-1, jel[0]-1, nnod, b_real);
				b_img_temp = get_2DPtr(inod-1, jel[0]-1, nnod, b_img);
				*b_real_temp += *(int_val_real+1); *b_img_temp += *(int_val_img+1);

				/* bptr[inod-1][jel[0]-1] += integral_value[2] */
				b_real_temp = get_2DPtr(inod-1, (jel[1]-1), nnod, b_real);
				b_img_temp = get_2DPtr(inod-1, (jel[1]-1), nnod, b_img);
			 	*b_real_temp += *(int_val_real+2); *b_img_temp += *(int_val_img+2);

				/* bptr[inod-1][jel[0]-1] += integral_value[0] */
				b_real_temp = get_2DPtr(inod-1, (jel[2]-1), nnod, b_real);
				b_img_temp = get_2DPtr(inod-1, (jel[2]-1), nnod, b_img);
			 	*b_real_temp += *(int_val_real+0); *b_img_temp += *(int_val_img+0);
			 }
			
			 else{
				xi = nodes_reg(nn,0);
				yi = nodes_reg(nn,1);
				zi = nodes_reg(nn,2); 
				
				compute_integral_gausspts(A, B, nnod, ngp, eta1, eta2, w, inod, jel,
					xel, yel, zel, xi, yi, zi, delG[el], normal_x[el], 
					normal_y[el], normal_z[el], omega, D); 
				
			
		/* */	} 
		
		} /* end inner for loop */
		/* A[inod-1][inod-1] += int_angle[inod-1] */
		a_real_temp = get_2DPtr(inod-1, inod-1, nnod, a_real);
		a_img_temp = get_2DPtr(inod-1, inod-1, nnod, a_img);
		*a_real_temp += *(iangle_real+(inod-1)); *a_img_temp += *(iangle_img+(inod-1)); 

	
	/**/} /* end outer for loop */

		/*looptimer.stopTimer();
		mexPrintf("loop timer %.8lf\n",looptimer.getElapsedTime());*/
	/* free temporarily used local variables */
	mxDestroyArray(source_strength);
	mxDestroyArray(integral_value); 
	
	delete [] delG;
	delete [] normal_x;
	delete [] normal_y;
	delete [] normal_z;
	delete [] eta1;
	delete [] eta2;
	delete [] w;
}

/******************************************************************************
 *get_gausspts_3d()
 * sets the gauss point values of the 3D triangular element by modifying the 
 * formal parameter values passed in as pointers
 * derived from the f90 function of the same name
 *
 * @param eta1: (real*8 array)
 * @param eta2: (real*8 array)
 * @param w: (real*8 array)
 * @param ngp: (integer)
 *
 *****************************************************************************/
void get_gausspts_3d(double *eta1, double *eta2, double *w, int ngp) {
	/* getting gass points for 3D triangular element */
	if(3 == ngp) {
		eta1[0] = 1.0/2.0;
		eta1[1] = 0.0;
		eta1[2] = 1.0/2.0;
		eta2[0] = 1.0/2.0;
		eta2[1] = 1.0/2.0;
		eta2[2] = 0.0;
		
		w[0] = 1.0/3.0;
		w[1] = 1.0/3.0;
		w[2] = 1.0/3.0;

	}else if(4 == ngp) {
		eta1[0] = 1.0/3.0;
		eta1[1] = 3.0/5.0;
		eta1[2] = 1.0/5.0;
		eta1[3] = 1.0/5.0;
		eta2[0] = 1.0/3.0;
		eta2[1] = 1.0/5.0;
		eta2[2] = 3.0/5.0;
		eta2[3] = 1.0/5.0;
    
		w[0] = -27.0/48.0;
		w[1] = 25.0/48.0;
		w[2] = 25.0/48.0;
		w[3] = 25.0/48.0;
	}
}

/*************************************************************************************
 * get_area_normals()
 * based on the f90 subroutine of the same name
 *
 * @param elem_list: (integer 2D array)
 * @param nod_list: (real*8 2D array)
 * @param num_elem: (integer)
 * @param num_nodes: (integer)
 * @param area_elem_list: (real*8 2D array)
 * @param normal_x_list: (real*8 array)
 * @param normal_y_list: (real*8 array)
 * @param normal_z_list: (real*8 array)
 *
 ************************************************************************************/
void get_area_normals(double *elem_list, double *nod_list, long num_elem,
			long num_nodes, double *area_elem_list, double *normal_x_list,
			double *normal_y_list, double *normal_z_list) {

	double x1, x2, x3, y1, y2, y3, z1, z2, z3;
	double dx_deta1, dx_deta2, dy_deta1, dy_deta2, dz_deta1, dz_deta2;
	long jelem[3], ee;


	/* TODO: might make computation more efficient by doing some loop unrolling */
	for(ee = 0; ee < num_elem; ++ee) {
		jelem[0] = (long) elem_list(ee,1);
		jelem[1] = (long) elem_list(ee,2);
		jelem[2] = (long) elem_list(ee,3);

		x1 = nod_list(jelem[0]-1,0);
		x2 = nod_list(jelem[1]-1,0);
		x3 = nod_list(jelem[2]-1,0);

		y1 = nod_list(jelem[0]-1,1);
		y2 = nod_list(jelem[1]-1,1);
		y3 = nod_list(jelem[2]-1,1);

		z1 = nod_list(jelem[0]-1,2);
		z2 = nod_list(jelem[1]-1,2);
		z3 = nod_list(jelem[2]-1,2);

		dx_deta1 = x1 - x3;
		dx_deta2 = x2 - x3;
		dy_deta1 = y1 - y3;
		dy_deta2 = y2 - y3;
		dz_deta1 = z1 - z3;
		dz_deta2 = z2 - z3; 

		normal_x_list[ee] = dy_deta1*dz_deta2 - dy_deta2*dz_deta1;
		normal_y_list[ee] = dz_deta1*dx_deta2 - dx_deta1*dz_deta2;
		normal_z_list[ee] = dx_deta1*dy_deta2 - dy_deta1*dx_deta2; 
		area_elem_list[ee] = sqrt(pow(normal_x_list[ee],2) +
								pow(normal_y_list[ee],2) + pow(normal_z_list[ee],2));

	}
}
/***************************************************************************************
 * singular_integrand_polar()
 * based on the f90 subroutine of the same name
 *
 * @param int_value (complex*16 array)
 * @param param (complex*16 array)
 * @param diff_coeff (real*8)
 * @param area (real*8)
 * @param gp1 (real*8 array)
 * @param gp2 (real*8 array)
 * @param wgt (real*8 array)
 * @param ngpts (integer)
 * 
 ***************************************************************************************/
void singular_integrand_polar(mxArray *int_value, mxArray *param, double diff_coeff,
				double area, double *gp1, double *gp2, double *wgt,
				long ngpts) {

   
        double basis[3], tau1, tau2;
        long k, j;
	double *real_part, *img_part, *int_val_real, *int_val_img;
	mxArray *prhs[1];
	
	/* a bit of juggling is required to deal with complex numbers.
         * since we are avoiding C's complex datatype, for addition & subtraction
   	 * we directly manipulate the real & img part of the mxArray complex numbers. 
	 * For more involved computations (sqrt and exp), we use matlab functions
	 */
	prhs[0] = mxCreateDoubleMatrix(1, 1, mxCOMPLEX);
	real_part = mxGetPr(prhs[0]);
	img_part = mxGetPi(prhs[0]);
	*real_part = *(mxGetPr(param)); /*do not clobber param, so store its value in mxArray... */
	*img_part = *(mxGetPi(param));  /*...complex number array & do computation with that*/
	int_val_real = mxGetPr(int_value);
	int_val_img = mxGetPi(int_value);
	int m = mxGetM(int_value);
	int n = mxGetN(int_value);	
	

         for(k=0; k<ngpts; ++k) {
                tau1 = sqrt(2.0)*gp1[k]*cos(PI*gp2[k]/4.);
                tau2 = sqrt(2.0)*gp1[k]*sin(PI*gp2[k]/4.);
                basis[0] = tau1;
                basis[1] = tau2;
                basis[2] = 1 - tau1 - tau2;

	 	/* do int_value[j] = int_value[j] + 
				exp(-param*gp1[k]*sqrt(2.0))*basis[j]*area*wgt[k]; */
		/* in two states, do the above statements. First do the exponentiation */
         	*real_part = *(mxGetPr(param)); 
          	*img_part = *(mxGetPi(param));
		*real_part = (*real_part)*-1*gp1[k]*sqrt(2.0);
		*img_part = (*img_part)*-1*gp1[k]*sqrt(2.0);

			/*exp(-param*pg1[k]*sqrt(2.0))*/
		cis(*real_part, *img_part, *real_part, *img_part);	
		 
                for(j=0; j<3; ++j) {
			/* then do multiplication and addition */
			(*(int_val_real+j)) += *(real_part)*basis[j]*area*wgt[k];
			(*(int_val_img+j)) += *(img_part)*basis[j]*area*wgt[k];
                }
         }
		
          for(j=0; j<3; ++j) {
               /*do int_value[j] = int_value[j]*sqrt(2.0)/(16*diff_coeff) */
		 (*(int_val_real+j)) *=sqrt(2.0)/(16*diff_coeff);
		 (*(int_val_img+j))  *= sqrt(2.0)/(16*diff_coeff);
	}
	
	mxDestroyArray(prhs[0]);
}
/******************************************************************************************
* compute_integral_gausspts()
* based on f90 subroutine of the same name
*
* @param AA: (complex*16 double array)
* @param BB: (complex*16 double array)
* @param size: (integer)
* @param ngpts: (integer)
* @param eta1: (real*8 array)
* @param eta2: (real*8 array)
* @param w: (real*8 array)
* @param ith_nod: (integer)
* @param jelem: (integer array)
* @param xelem: (real*8 array)
* @param yelem: (real*8 array)
* @param zelem: (real*8 array)
* @param xx: (real*8)
* @param yy: (real*8)
* @param zz: (real*8)
* @param area (real*8)
* @param norm_x (real*8)
* @param norm_y (real*8)
* @param norm_z (real*8)
* @param param (complex*16)
* @param diff_coeff (real*8)
*
******************************************************************************************/
static void compute_integral_gausspts(mxArray *AA, mxArray *BB, long size, long ngpts, 
				double *eta1, double *eta2, double *w, long ith_nod,
				long *jelem, double *xelem, double *yelem, double *zelem,
				double xx, double yy, double zz, double area, double norm_x, 
				double norm_y, double norm_z, mxArray *param, double diff_coeff) {	

	double phi[4], xs, ys, zs, ri, drdn;
	long j, k, t_result;
	double z_real, z_img, gi_real, gi_img, dgdr_real, dgdr_img, dgdn_real, dgdn_img;
	double *param_real, *param_img, *aa_real, *aa_img, *bb_real, *bb_img;
	double temp_result, xss, yss, zss, four_PI_diff;

	param_real = mxGetPr(param);
	param_img = mxGetPi(param);
	aa_real = mxGetPr(AA)+((ith_nod-1)-size);
	aa_img = mxGetPi(AA)+((ith_nod-1)-size);
	bb_real = mxGetPr(BB)+((ith_nod-1)-size);
	bb_img = mxGetPi(BB)+((ith_nod-1)-size);
	four_PI_diff = 4*PI*diff_coeff;

	for(k = ngpts -1; k>=0; --k) {
		phi[0] = eta1[k];
		phi[1] = eta2[k];
		phi[2] = 1 - eta1[k] - eta2[k];
		
		xs = xelem[0]*phi[0] + xelem[1]*phi[1] + xelem[2]*phi[2];
		ys = yelem[0]*phi[0] + yelem[1]*phi[1] + yelem[2]*phi[2];
		zs = zelem[0]*phi[0] + zelem[1]*phi[1] + zelem[2]*phi[2];

		xss = xs-xx;
		yss = ys-yy;
		zss = zs-zz;

		ri = sqrt(xss*xss + yss*yss + zss*zss);
		drdn = (norm_x*xss + norm_y*yss + norm_z*zss)/(area*ri);

		/* z = param*ri */
		z_real = (*param_real)*ri;
		z_img = (*param_img)*ri;


		/* gi = exp(-z)/(4*PI*ri*diff_coeff) */
		cis((-1.0*(z_real)), (-1.0*(z_img)), gi_real, gi_img);
		(gi_real) /= four_PI_diff*ri;
		(gi_img) /= four_PI_diff*ri;

		/* dgdr = gi*((-1.0/ri) - param) */
		mult_complex(gi_real, gi_img, ((-1.0/ri)-(*param_real)), 
				(-1.0*(*param_img)), dgdr_real, dgdr_img);

		/* dgdn = dgdr*drdn */
		dgdn_real = (dgdr_real)*drdn;
		dgdn_img = (dgdr_img)*drdn;

		/*make use of dgdn and gi so we only have to multiply by phi[j] in
		 the inner loop...effectively hoisting the multiplications into this loop */
		temp_result = area*w[k]*diff_coeff;
		dgdn_real *= temp_result;
		dgdn_img *= temp_result;
		gi_real *= area*w[k];
		gi_img *= area*w[k];

		for(j=2; j>=0; --j) {
			t_result = jelem[j]*size;
			
			/* AA[ith_nod-1][jelem[j]-1] += phi[j]*dgdn*area*w[k]*diff_coeff */
			(*(aa_real + t_result)) +=  phi[j]*dgdn_real;
			(*(aa_img + t_result)) += phi[j]*dgdn_img;

			/* BB[ith_node-1][jelem[j]-1] += phi[j]*gi*area*w[k] */
			(*(bb_real + t_result)) += phi[j]*(gi_real);
			(*(bb_img + t_result)) += phi[j]*(gi_img);
			
		}
		 
	}
	
}


/***************************************************************************************
* mexFunction()
* gateway from matlab workspace.
* based on the f90 mexFunction for main_build_matrix.f90
*
* @param nlhs: number of left hand side return value (returned by reference)
* @param plhs: array of pointers to l.h.s formal parameters
* @param nrhs: number of right hand side parameters
* @param prhs: array of pointers to r.h.s formal parameter
*
****************************************************************************************/
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
	
	/* variables used in matrix building a computations */
	long nnod, nelem, nnod_reg, reg, m, n;
	double *elements;
	double *inreg;
	double *nodes, *nodes_reg; /* simulate 2D array */
	double D, *source;
	mxArray *omega, *AA, *BB, *int_angle;
	
	//CStopWatch mytimer;
	
	/* parameter checking. ensure 9 inputs and 2 outputs vars */
	if(9 != nrhs) 
		mexErrMsgTxt("9 inputs required\n");
	/*if(2 != nlhs)
		mexErrMsgTxt("2 outputs required\n");*/
	
	
	/* access input parameters, and allocate memory as required.
	 * e.g. if a matrix has m*n dimensions, allocate this much mem
	 */

	/* nodes matrix */
	m = mxGetM(prhs[0]);
	n = mxGetN(prhs[0]);
	nnod = m;
	
	nodes = mxGetPr(prhs[0]);
	/*allocate_2DArray(m, n, nodes, double);
	temp2D_ptr = mxGetPr(prhs[0]);
	copy_2DArray(m, n, nodes, temp2D_ptr, double);*/
	/* mexPrintf("Node pointer [matrix] created with size %d * %d\n", m , n); */
	
	
	/* element matrix */
	nelem = mxGetM(prhs[1]);
	n = mxGetN(prhs[1]);
	
	elements = mxGetPr(prhs[1]);
	/*allocate_2DArray(m, n, elements, long);
	temp2D_ptr = mxGetPr(prhs[1]);
	copy_2DArray(m, n, elements, temp2D_ptr, long);*/ /*store values from prhs[1] as long*/
	/* mexPrintf("Element pointer [matrix] created with size %d * %d\n", m , n); */

	/* nodereg matrix */
	m = mxGetM(prhs[2]);
	n = mxGetN(prhs[2]);
	nnod_reg = m;
	nodes_reg = mxGetPr(prhs[2]);
	/*allocate_2DArray(m, n, nodes_reg, double);
	temp2D_ptr = mxGetPr(prhs[2]);
	copy_2DArray(m, n, nodes_reg, temp2D_ptr, double);*/

	

	/* inreg array */
	m = mxGetM(prhs[3]);
	n = mxGetN(prhs[3]);
	inreg = (double *) mxGetData(prhs[3]);
	
	/*temp = mxGetPr(prhs[3]);
	if(n != 1) mexErrMsgTxt("Need row vector for inreg\n")
	inreg = (long *) mxCalloc(m, sizeof(long));
	for(i=0; i<m; *(inreg+i) = (long) *(temp+i++))
			;*/ /*empty body...all copying done in for loop */
	/* mexPrintf("Inreg pointer [matrix] created with size %ld * %ld\n", m , n); */

	/* copy omega */
	omega = mxCreateDoubleMatrix(1, 1, mxCOMPLEX);
	mxAssert(omega!= NULL, "failed to allocate mem for omega\n");
	(*(mxGetPr(omega))) = *(mxGetPr(prhs[4]));
	if (mxIsComplex(prhs[4])) {
		(*(mxGetPi(omega))) = *(mxGetPi(prhs[4]));
	}
	else {
		(*(mxGetPi(omega))) = 0.;
	}
	/* mexPrintf("Omega pointer created \n"); */
	
	
	/* D */
	D = *(mxGetPr(prhs[5]));

	/* source */
	/*memcpy((void *)source, (void *)mxGetPr(prhs[6]), 3*sizeof(double));*/
	source = mxGetPr(prhs[6]);
	
	/* region array */
	reg = (long) *(mxGetPr(prhs[7]));
	/* mexPrintf("region pointer created\n"); */

	/* copy row vector for interior angle */
	m = mxGetM(prhs[8]);
	n = mxGetN(prhs[8]);

	if(n != 1) mexErrMsgTxt("Need row vector for interior angle\n");
	int_angle = mxCreateDoubleMatrix(m, 1, mxCOMPLEX);
	mxAssert(int_angle!= NULL, "failed to allocate mem for interior angle\n");
	memcpy((void *)mxGetPr(int_angle), (void *)mxGetPr(prhs[8]), m*sizeof(double));
	/*mxAssert(mxGetPi(prhs[8])!=NULL, "int_angle must be array of complex numbers\n");
	*/
	if(mxIsComplex(prhs[8]))
		memcpy((void *)mxGetPi(int_angle), (void *)mxGetPi(prhs[8]), m*sizeof(double));
	
	/* mexPrintf("Interior angle created\n"); */

	/* allocate mem for AA and BB complex arrays */	
	//mytimer.startTimer();
	AA = mxCreateDoubleMatrix(nnod, nnod, mxCOMPLEX);
	BB = mxCreateDoubleMatrix(nnod, nnod, mxCOMPLEX);
	/*mytimer.stopTimer();
	mexPrintf("Time elapsed in allocating memory for AA & BB: %.8lf\n",mytimer.getElapsedTime());*/
	
	/* verify that mem was successfully allocated */
	mxAssert(AA != NULL && BB != NULL,
		"failed to allocate memory for matrices AA or BB\n");

	/* call the computational routines */
	// mexPrintf("Calling computational function to build matrices\n");
	main_build_matrix(nodes, elements, nodes_reg, inreg, nnod, nnod_reg, nelem, omega,
				D, source, reg, int_angle, AA, BB);

	/*temp = mxGetPr(AA);
	temp2D_ptr = mxGetPi(AA);
	for(i=0; i<nnod; ++i)
		mexPrintf("%.9f + %.9fi\n", *(temp+i), *(temp2D_ptr+i));*/
	
	/* set return values */
	plhs[0] = AA;
	plhs[1] = BB;

	/* free all the array structures used for subroutine call. all
	   mem allocated through mxCalloc(...) will get free when this function
	   returns*/
 	
	mxDestroyArray(int_angle);
	mxDestroyArray(omega);

	return;

}
