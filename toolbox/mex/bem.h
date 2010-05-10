/* BEM.h is a compilation of all the functions and macros used
 * by the BEM (boundary element method) code located in the C files
 * main_build_matrix.c and build_source.c.
 * 
 * BY: Senate Taka
 * 
 * Created: Sept-08-2008
 */

#ifndef BEM_H
#define BEM_H

#include "mex.h"
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <assert.h>
#include <math.h> /* for sqrt, pow...link with -lm */
#include <time.h> /* for srand(time(NULL)) for testing... */

#define PI 3.141592653589793115997963

/*TODO: macros tested...at least for correctness. Device a test suite to test
    them regirously */

/* macro for allocation memory for pointer to pointers to simulate a 2D
 * array.
 */
#define allocate_2DArray(rows, cols, array, type) \
do{	(array) = (type **) mxCalloc((rows), sizeof(type *)); \
	mxAssert(((array) != NULL), "unable to allocate enough mem for array\n"); \
	long i;	\
	for(i=0; i<(rows); ++i) { \
		(array)[i] = (type *) mxCalloc((cols), sizeof(type)); \
		mxAssert( ((array)+i) != NULL, "out of mem while allocating cols\n"); \
	}\
}\
while(0)
	
	

/* macro used to return pointer from 2D elements of an array of doubles from matlab.
 * Since matlab stores these in row major order, a 2D array of such values is
 * just one long array indexed by array[i][j] = i+collen*j */
#define get_2DPtr(i, j, rows, array) (array+( (i)+((rows)*(j)) ))

/* macro used to copy real & img parts of complex number from one
 * variable to another, then deallocates the first (defualt) variable 
*/
#define copy_real_part(x) memcpy( mxGetPr(x), mxGetPr(plhs[0]), 1*sizeof(double))
#define copy_img_part(x) memcpy( mxGetPi(x), mxGetPi(plhs[0]), 1*sizeof(double))
#define deallocate_plhs mxDestroyArray(plhs[0])

/* macro used to copy elements from objects of type double (*a)[] to those of
 * double **b. do statement helps with scoping issues...i.e the variables i & j
 * won't be clobbered if they exist elsewhere.
 * for lack of better method, ar2 is declared as double b/c if though we may need
 * to store long values, src will always have (at least) double precision values
 */
#define copy_2DArray(rows, cols, dest, src, type) \
do {	long i, j; \
	for(i=0; i<(rows); ++i) \
		for(j=0; j<(cols); ++j) \
			*(*(dest+i)+j) = (type) *(src+(i+(rows)*j)); \
}\
while(0)

/* macros used for multiplying and dividing complex numbers.
 *  form complex numbers z = a+bi and w = c+di,
 *  multiplication: z*w = (a*c - b*d) + (a*d + b*c)*i
 *  division: z/w = ((a*c + b*d)/(c*c + d*d)) + ((b*c - a*d)/(c*c + d*d))*i
 *  stores the real and img parts in real & img.
 *  we use a do while loop with condition of 0 so that semicolons can be
 *  neatly hidden in the do part of the statement. NOTE, use macro by calling
 * mult_complex(...); (note semicolon at the end of macro call).
 */
#define mult_complex(a, b, c, d, real, img) \
do{ 	(real) = ( ((a)*(c))-((b)*(d)) ); \
	(img) = ( ((a)*(d)) + ((b)*(c)) ); \
}\
while(0)

#define div_complex(a, b, c, d, real, img) \
do{	(real) = (((a)*(c))+((b)*(d)))/( ((c)*(c))+((d)*(d)) ); \
	(img) =  (((b)*(c))-((a)*(d)))/( ((c)*(c))+((d)*(d)) ); \
}\
while(0)

/* macro for cis(x), where x is a complex number a+bi
 * cis(yi) for real y = cos(y)+isin(y) (in other words, euler's formula)
 * _a_ is a pseudo gensym() variable name (the gensym in lisp).
 */
#define cis(a, b, real, img) \
do {	double _a_ = exp((a)); \
	(real) = _a_ * (cos((b))); \
	(img) = _a_ * (sin((b))); \
}\
while(0)


/* functions called by mexFunction */
void get_gausspts_3d(double *eta1, double *eta2, double *w, int ngp);
void get_area_normals(double *elem_list, double *nod_list, long num_elem,
			long num_nodes, double *area_elem_list, double *normal_x_list,
			double *normal_y_list, double *normal_z_list);
void singular_integrand_polar(mxArray *int_value, mxArray *param, double diff_coeff,
				double area, double *gp1, double *gp2, double *wgt,
				long ngpts);
static void compute_integral_gausspts(mxArray *AA, mxArray *BB, long size, long ngpts, 
				double *eta1, double *eta2, double *w ,long ith_nod,
				long *jelem, double *xelem, double *yelem, double *zelem,
				double xx, double yy, double zz, double area, double norm_x, 
				double norm_y, double norm_z, mxArray *param, double diff_coeff);

#endif /* bem_h */


