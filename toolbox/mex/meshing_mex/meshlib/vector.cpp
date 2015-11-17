#include "vector.h"

//cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
void v_make(double *pnt1, double *pnt2, int n, double *vec) { //      subroutine v_make(pnt1, pnt2, n, vec)
/*c
c    routine to construct a vector from point 1 to point 2
c
c    written by:  Bruce Johnston, May 1991
c
c    parameters:   
c         pnt1,2 - input point coordinates
c         n - number of coordinates
c         vec - returned vector components
c*/
    // double *ret = new double[n];
    for (register int k=0; k<n; vec[k] = pnt2[k] - pnt1[k], ++k);

}
//cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
int v_norm(double *vec, int n) { //      subroutine v_norm(vec, n)
/*c
c    routine to normalize a vector
c
c    written by:  Bruce Johnston, May 1991
c
c    parameters:   
c         vec = vector to be normalized (input)
c               normalized vector (output)
c         n = number of vector components
c */   
      
    int ret=OK;
    double magvec = v_magn(vec, n);
      
    if ( fabs(magvec-0.0) < FloatTol ) {
        magvec = FloatTol;
        ret = BAD;
    }
    for (register int k=0; k<n; vec[k] /= magvec, ++k);
    return ret;
}
// cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
void v_cros(double *vec1, double *vec2, int n, double *prod) { //      subroutine v_cros( vec1, vec2, n, prod )
/*c
c    calculates the cross product of two vectors of  
c    dimension n (n>=3).  vec1 x vec2 = prod
c
c    written by:  Bruce Johnston, May 1991
c
c    parameters:
c         vec1 - first vector
c         vec2 - second vector
c            n - dimension of the vectors
c         prod - resultant vector
c*/
      //real vec1(1), vec2(1), prod(1)
      //integer n


      prod[0] = vec1[1]*vec2[2] - vec1[2]*vec2[1];
      prod[1] = vec1[2]*vec2[0] - vec1[0]*vec2[2];
      prod[2] = vec1[0]*vec2[1] - vec1[1]*vec2[0];
      if (n==4)  
        prod[3] = 1.0;
}
//ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
double v_magn(double *vec, int n) { //      real function v_magn(vec, n)
/*c
c    calculates the magnitude of a vector of dimension n
c    parameters:
c         vec - the vector
c         n   - dimension of the vector
c*/    
    double sum = 0.;
    int nn = (n>3) ? 3 : n;
    for (register int k=0; k<nn; sum += vec[k]*vec[k], ++k);
    return sqrt(sum);
}

//cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
double v_dot(double *vec1, double *vec2, int n) {  //    real function v_dot(vec1,vec2, n)
/*c
c    calculates the dot product of two vectors of dimension n
c
c    written by:  Bruce Johnston, May 1991
c
c    parameters
c         vec1,2 - the two vectors
c              n - their dimension
c*/
      //real vec1(1), vec2(1), 
    double val=0.0;
    register int k; 

      for (k=0;k<n;++k) {  // do 10 k=1,n
         val += vec1[k]*vec2[k];
    }  // 10   continue
      
    return val; //v_dot = val
}

//cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
double *v_add(double *v1, double *v2, int n) {
/*
    adds v1 and v2 and returns the result;
    written by: Hamid Ghadyani
    parameters
        v1, v2 : two input vectors
        return value: a n-dimension vector containing the addition of v1 and v2
        n : dimension
*/
    double *ret = new double[n];
    for (register int i=0; i<n; ret[i] = v1[i] + v2[i], i++)
        ;
    return ret;
}

//cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
/*
  Purpose:
    v_dist computes the Euclidean norm of a (X-Y) in N space.
    Input, int N, the dimension of the space.
    Input, double X(N), Y(N), the coordinates of the vectors.
    Output, double ENORM0_ND, the Euclidean norm of the vector.
*/
double v_dist( double x[], double y[], int n )
{
  int i;
  double value;

  value = 0.0;

  for ( i = 0; i < n; i++ ) {
    value = value + ( x[i] - y[i] ) * ( x[i] - y[i] );
  }

  value = sqrt ( value );
 
  return value;
}

//cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
double v_rang(double *vec0, double *vec1, int n) {  //      real function v_rang( vec0, vec1, n )
/*c
c     author:  phillip getto
c
c     date:    july 19, 1982
c
c     purpose: to compute the distance between two x, y, z points.
c*/
   //   real    vec0(1), vec1(1)
     // integer n, 
    int i;
      double work;
      work = 0.0;
/*c
c     sum up the squared differences.
c*/
      for (i=0; i<n; i++) {  //do 100 i = 1, n
         work = work + (vec0[ i ] - vec1[ i ])*(vec0[ i ] - vec1[ i ]);
    }  // 100  continue
/*c
c     take the square root and return the answer.
c*/
      return sqrt( work );
}

// Calculates the scalar angle between vec1 and vec2
/*
double  vec1, vec2;      // the two vectors
int     degf;            // degreee/radian flag( 0=rad, 1= deg )
int     dim;               // vector dimension
*/
double v_angle(double vec1[], double vec2[], int degf, int dim, double zeroTol) {
    // Cleaned up by Hamid 11/2006
    double   mag1, mag2, dprod, cosang, angle;
    
    mag1 = v_magn(vec1, dim);
    mag2 = v_magn(vec2, dim);
    if (fabs(mag1-0.)<zeroTol || fabs(mag2-0.)<zeroTol) {
        angle =0.;
    }
    else {
        dprod = v_dot(vec1, vec2, dim);
        cosang = dprod / (mag1 * mag2);
        cosang = cosang < -1. ? -1. : cosang;
        cosang = cosang > +1. ? +1. : cosang;
        angle = acos(cosang);
        if (degf == 1)
            angle *= RAD_TO_DEG;
    }
    return angle;
}

/* Function to calculate the oriented 2D angle between two
   vectors ( ccw=positive, cw=negative )  
   Ziji, 10/29/01 */
double v_angle3(double vec1[], double vec2[], int degf, int dim, double zeroTol) {
/*double vec1[], vec2[];  // the input vectors
int    ideg;            // flag indicating result desired in degrees
                        // ( 0=radians, 1=degrees )*/
    double angle;
    angle =v_angle(vec1, vec2, degf, dim, zeroTol);
    if ( (vec1[0]*vec2[1] - vec1[1]*vec2[0]) < 0. )
        angle = -angle;
/*  if (degf == 1)
        angle *= RAD_TO_DEG;*/
    return angle;
}

double angle_rad_2d (double p1[], double p2[], double p3[], int degf, double zeroTol) 
/*
  Purpose:
    ANGLE_RAD_2D returns the angle in radians swept out between two rays in 2D.
  Discussion:
    Except for the zero angle case, it should be true that
    ANGLE_RAD_2D(X1,Y1,X2,Y2,X3,Y3)
    + ANGLE_RAD_2D(X3,Y3,X2,Y2,X1,Y1) = 2 * PI

    Input, double p1,p2,p3, define the rays
    p2->p1 (p1-p2) and p2->p3 (p3-p2) which in turn define the
    angle, counterclockwise from p2->p1
    degf, 0 = rad 1 = deg

    Output, double ANGLE_RAD_2D, the angle swept out by the rays, measured
    in radians.  0 <= ANGLE_DEG_2D < 2 PI.  If either ray has zero length,
    then ANGLE_RAD_2D is set to 0.
*/
{
  double value;
  double x, x1, x2, x3;
  double y, y1, y2, y3;
  x1 = p1[0]; y1 = p1[1];
  x2 = p2[0]; y2 = p2[1];
  x3 = p3[0]; y3 = p3[1];

  x = ( x1 - x2 ) * ( x3 - x2 ) + ( y1 - y2 ) * ( y3 - y2 );
  y = ( x1 - x2 ) * ( y3 - y2 ) - ( y1 - y2 ) * ( x3 - x2 );

  if ( fabs(x-0.)<zeroTol && fabs(y-0.)<zeroTol ) {
      value = 0.0;
  }
  else {
      value = atan2 ( y, x );
      if ( value < 0.0 ) {
          value = value + 2.0 * PI;
    
      }
  }
  if (degf == 1)
      value *= RAD_TO_DEG;
  // If value is too close to boundary angles, make sure it is exactly that
  value = fabs(value-90. )<zeroTol ? 90.  : value;
  value = fabs(value-180.)<zeroTol ? 180. : value;
  value = fabs(value-270.)<zeroTol ? 270. : value;
  value = fabs(value-360.)<zeroTol ? 360. : value;
  return value;
}

