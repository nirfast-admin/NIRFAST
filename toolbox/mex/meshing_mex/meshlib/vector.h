#ifndef __vector_header
#define __vector_header

#include "init.h"

#ifndef RAD_TO_DEG
#define RAD_TO_DEG (180./PI)
#endif

void v_make(double *pnt1, double *pnt2, int n, double *vec) ; //      subroutine v_make(pnt1, pnt2, n, vec)
int v_norm(double *vec, int n) ; //      subroutine v_norm(vec, n)
void v_cros(double *vec1, double *vec2, int n, double *prod) ; //      subroutine v_cros( vec1, vec2, n, prod )
double v_magn(double *vec, int n) ; //      real function v_magn(vec, n)
double v_dot(double *vec1, double *vec2, int n) ;  //    real function v_dot(vec1,vec2, n)
double v_rang(double *vec0, double *vec1, int n) ;  //      real function v_rang( vec0, vec1, n )
double *v_add(double *v1, double *v2, int n);
double v_dist( double x[], double y[], int n ); /* Caclculates the distance between x and y in n-dimension */
double v_angle (double vec1[], double vec2[], int degf, int dim, double ZeroTol = FloatTol);
double v_angle3(double vec1[], double vec2[], int degf, int dim, double ZeroTol = FloatTol);
double angle_rad_2d(double p1[], double p2[], double p3[], int degf, double zeroTol); // Returns the angle swept between rays measured from p1-p2 to p3-p2 ccw
#endif
