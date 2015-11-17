/*
    Filename:   dlmathlib.cpp
    Language:   C++
    Date:       04/15/99
    Author:     Ziji Wu   
    Version:    Version: 1.0
    Description:Define math / geometric functions
*/

#include "geomath.h"

int ddcrsline( double x1, double y1, double x3, double y3, double x4, double y4, double tiny )
{
    double m, xi, b;

    if ((x3<=x1)&&(x4<=x1)) return 0;
    m = (y3-y1)*(y4-y1);
    if (m>0) return 0;
    if (m == 0) { if ((y1<=y3)&&(y1<=y4)) return 0;}

    if (fabs(x4-x3)<tiny) 
        xi = x3;
    else
    {
        if (fabs(y4-y3)<tiny) return 0;
        else
        {
            m = (y4-y3)/(x4-x3);
            b = y3-m*x3;
            xi = (y1-b)/m;
        }
    }
    if (xi>x1) return 1;
    else return 0;
}



/* Determine intersection point of two straight lines
by: Ziji Wu, JMS
Modified by : Praveen Kulkarni (For Rat_Brain)
              Hamid R Ghadyani (July/12/02) (For Rat Brain with pointer-linked data structure)
              Hamid R Ghadyani (Feb /12/05) (Fixing round-off bug and adding new arguments to lnln() function
                                             distinguishing 2D/3D cases)
Parameters:
/ Modified by Hamid Ghadyani /
 a1, b1 : points defining first  line, AB (absolute coordinates) 
 c1, d1 : points defining second line, CD (absolute coordinates)
 p      : coordinates of intersection point (if exists)
 tiny   : a small number used as a 'zero' value to fix roundoff errors. Any value smaller
          than 'tiny' is considered as zero. It should be a small positive value.
          if tiny==-1 is passed, then the routine defines 'tiny' as:
          tiny=min(AB lenght, CD length)/1E+06
 twoDflag : specifying if both AB and CD have 0 as their z coordinate
 
Return
0 : No interaction
1 :interaction with point given in P
2 :Colimear with u given in p(1-2) which requires b relative to a in calculation.

Routine assumes
s = a+ u*b and t = c+w*d where b and d are relative to a and c respectively.
The range of u &/or w is [0,1]
at intersection point s = t therefore

u= -(c x d) dot(a) / [(c x d) dot(b)]   equivalently
w= -(a x b) dot(c) / [(a x b) dot(d)]

If u or w = 0/0 then colinear or everything in z=0 axis
*/
int lnln(double a1[3], double b1[3], double c1[3], double d1[3], double p[3], double tiny, bool twoDflag)
{
    double a[3], b[3], c[3], d[3], cxd[3], axb[3];
    double u, w, utop, ubot, wtop, wbot, u1, u2;
    double uVirtual, wVirtual, u1Virtual, u2Virtual;
    int flag2d, i;
    
    /////////////////////////////////////////////////////////////
    /*if (twoDflag ==  true) {
        a1[2] = b1[2] = c1[2] = d1[2] = 0.0;
    } */
    if (twoDflag ==  true) {
        a[2] = b[2] = c[2] = d[2] = 0.0;
    }
    /* make sure b and d are relative to a and c*/
    for (i=0; i < (twoDflag ? 2 : 3); i++) {
        a[i] = a1[i];
        c[i] = c1[i];
        b[i] = b1[i] - a[i];
        d[i] = d1[i] - c[i];
    }
    /////////////////////////////////////////////////////////////       
    // modify if 2-d lines in z=0 plane 
    if (twoDflag != true && twoDflag != false) {
        printf( "Error Calling lnln() function... Call it with all arguments initialized.\n\n");
        exit(1);
    }
    if (twoDflag == true)
    {
        a[2] = 1.0;
        c[2] = 1.0;
        flag2d = 1;
    }
    else 
        flag2d = 0;
    /////////////////////////////////////////////////////////////   
    // if tiny is not specified, calculate it.
    if (tiny < 0) {
        double lab = 0., lcd = 0.;
        for (i=0; i< (twoDflag ? 2 : 3); i++) {
            lab += b[i]*b[i];
            lcd += d[i]*d[i];
        }
        lab = sqrt(lab);
        lcd = sqrt(lcd);
        tiny = std::min(lab, lcd) / (double)1e6;
        tiny = (tiny > 1.0 ? 0.5 : tiny);
    }   

    /////////////////////////////////////////////////////////////       
    /*  Determine cxd */
    cxd[0] = c[1] * d[2] - c[2] * d[1];
    cxd[1] = c[2] * d[0] - c[0] * d[2];
    cxd[2] = c[0] * d[1] - c[1] * d[0];
    /* Dot with a and b */
    utop = cxd[0]*a[0] + cxd[1]*a[1] + cxd[2]*a[2];
    ubot = cxd[0]*b[0] + cxd[1]*b[1] + cxd[2]*b[2];
    /*  Determine axb */
    axb[0] = a[1] * b[2] - a[2] * b[1];
    axb[1] = a[2] * b[0] - a[0] * b[2];
    axb[2] = a[0] * b[1] - a[1] * b[0];
    /* Dot with c and d */
    wtop = axb[0]*c[0] + axb[1]*c[1] + axb[2]*c[2];
    wbot = axb[0]*d[0] + axb[1]*d[1] + axb[2]*d[2];
    /* Determine if an intersection exist */
    if((!IsEqual(ubot,0.0,tiny)) && (!IsEqual(wbot,0.0,tiny)) )
    {
        u = -utop/ubot;
        w= -wtop/wbot;
/*      u = round(u, numPlaces);
        w = round(w, numPlaces);*/
        /* Check u and w for roundoff errors about 1.0 and 0.0 */
        uVirtual = IsEqual(u,1.0,tiny) ? 1.0 : u; // If u is almost 1.0 return 1.0 otherwise return u
        wVirtual = IsEqual(w,1.0,tiny) ? 1.0 : w;
        uVirtual = ( IsEqual(u,0.0,tiny) ) ? 0.0 : uVirtual;
        wVirtual = ( IsEqual(w,0.0,tiny) ) ? 0.0 : wVirtual;
        if ((uVirtual<0)||(uVirtual>1)||(wVirtual<0)||(wVirtual>1)) 
            return 0;
        else {
            for (i=0; i<3; i++) 
                p[i] = a[i] + uVirtual*b[i];
            if (flag2d == 1) 
                p[2] =0.;
            return 1;
        }
    }
    /* parallel lines but no connections or overlap */
    if ( (!IsEqual(utop,0.0,tiny)) || (!IsEqual(wtop,0.0,tiny)) ) 
        return 0;
    /* Colinear lines determine range of overlap (if any)*/
    i=0;
    while (i<3)
    {
        if (IsEqual(b[i],0.0,tiny)) 
            i++;    
        else 
            i += 3;
    }
     if (i>3) 
         return 0;
     else { 
        u1 = (c[i-3] - a[i-3]) / b[i-3];
        u2 = (c[i-3] + d[i-3] - a[i-3]) / b[i-3] ;
        
        u1Virtual = IsEqual(u1,1.0,tiny) ? 1.0 : u1;
        u2Virtual = IsEqual(u2,1.0,tiny) ? 1.0 : u2;
        u1Virtual = ( IsEqual(u1,0.0,tiny) ) ? 0.0 : u1Virtual;
        u2Virtual = ( IsEqual(u2,0.0,tiny) ) ? 0.0 : u2Virtual;

         /* if both above or below are in valid range then no verlap*/
         if ( ((u1Virtual<0)&& (u2Virtual<0)) || ((u1Virtual>1)&&(u2Virtual>1)) ) 
             return 0;
         else {
             p[0] = u1Virtual;
             p[1] = u2Virtual;
             return 2;
         }
     }
}

// Compares a and b and return 'true' if they are equal with tolerance of 'tiny'
bool IsEqual(double const &a, double const &b, double const &tiny) {
    if (fabs(a-b) < tiny)
        return true;
    else if (fabs(a-b) >= tiny)
        return false;
    return false;
}

/*
  Calculate the distance between two points

  written by:  Ziji Wu, 1998/05/23

  parameters:
   p1 = point 1
   p2 = point 2

  return   distance
*/
double dist_pp(double *p1, double *p2)
{
    double dist = (p2[0]-p1[0])*(p2[0]-p1[0]) + (p2[1]-p1[1])*(p2[1]-p1[1]) + (p2[2]-p1[2])*(p2[2]-p1[2]);
    return sqrt(dist);
}

/*
  Calculate the minimum distance between a point and a straight line
  Note: this is for 2D case

  written by:  Ziji Wu, 1998/05/25

  parameters:
   lp1 = point 1 of line
   lp2 = point 2 of line
   pt  = point
   ret = point on line which has the minimum distance to pt

  return   distance
*/
double dist_lp(double *lp1, double *lp2, double *pt, double *ret)
{
    double dist;
    double a, b, c, k;

    a = lp2[0] - lp1[0];
    b = lp2[1] - lp1[1];

    if (IsEqual(a,0.,FloatTol))
    {
        ret[0] = lp1[0];
        ret[1] = pt[1];
        dist = fabs(pt[0]-lp1[0]);
    }
    else if (IsEqual(b,0.,FloatTol))
    {
        ret[0] = pt[0];
        ret[1] = lp1[1];
        dist = fabs(pt[1]-lp1[1]);
    }
    else
    {
        k = b/a;
        c = k*k*lp1[0]-k*lp1[1]+k*pt[1]+pt[0];
        ret[0] = c/(k*k+1);
        ret[1] = k*(ret[0]-lp1[0])+lp1[1];
        dist = (ret[0]-lp1[0])*(ret[0]-lp1[0]) + (ret[1]-lp1[1])*(ret[1]-lp1[1]);
        dist = sqrt(dist);
    }

    return dist;
}

/*
   compute the distance between a Vertex pt and
   a 3D Line determined by pt1 and pt2.

   written by Ziji Wu, 5/20/99
   parameter:
      pt(3) --- the point(Vertex)
      pt1(3), pt2(3) --- the Line
      ndir --- direction sign.
          =-1, the perpendicular point is exterior, to the pt1 side.
          =0,  the perpendicular point superimposes pt1.
          =1,  the perpendicular point is between pt1 and pt2 (exclusive)
          =2,  the perpendicular point superimposes pt2.
          =3,  the perpendicular point is exterior, to the pt2 side.
      pnt(3) --- the perpendicular point
*/
double dist_VL(double *pt, double *pt1, double *pt2, int *ndir, double *pnt)
{
    double a[3], b[3];
    double dd, dlen, dlen0, dst, rt_val=0.;
    int i;

    /* initialize */
    dd = 0.;
    for (i=0; i<3; i++) {
        a[i] = pt2[i] - pt1[i];
        dd   = dd + a[i]*a[i];
        b[i] = pt[i] - pt1[i];
    }

    /* normalize the vector a */
    dd = sqrt(dd);
    for (i=0; i<3; i++) a[i] = a[i] / dd;

    /* calculate distance */
    dlen = 0.;
    for (i=0; i<3; i++) dlen += (pt[i]-pt1[i])*(pt[i]-pt1[i]);
    dlen = sqrt(dlen);
    dlen0 = 0.;
    for (i=0; i<3; i++) dlen0 += (pt2[i]-pt1[i])*(pt2[i]-pt1[i]);
    dlen0 = sqrt(dlen0);
    dst = v_dot(a, b, 3);
    rt_val = sqrt(dlen*dlen - dst*dst);
    for (i=0; i<3; i++) pnt[i] = pt1[i] + a[i]*dst;

    /* distinguish different situations */
    if (dst<0)           *ndir = -1;
    else if (dst==0)     *ndir = 0;
    else if (dst<dlen0)  *ndir = 1;
    else if (dst==dlen0) *ndir = 2;
    else *ndir = 3;

    return (rt_val);
}

/* calculate the area of a triangle */
double tri_area(double *nd1, double *nd2, double *nd3)
{
    double area;

    area = (nd1[0]*(nd2[1]-nd3[1]) + nd2[0]*(nd3[1]-nd1[1]) + nd3[0]*(nd1[1]-nd2[1]))/2.;
    return (area);
}

/*c
c this function determines wether a point is on a line.
c
c written by Ziji Wu, 08/25/98
c
c Parameter
c   sx, sy --- coordinates of start point of line
c   ex, ey --- coordinates of end point of line
c   px, py --- coordinates of candidate point
c
c Return Value:
c   1 --- the point superimposes the start point of the line
c   2 --- the point superimposes the end point of the line
c   3 --- the point is on the line
c   0 --- the point is not on the line
*/
int ptOnLine(double sx, double sy, double ex, double ey, double px, double py)
{
    double v1[3], v2[3], d1, d2, d3, sum, ratio;
    double tol0 = 1.e-10;
    
    v1[1] = px - sx;
    v1[2] = py - sy;
    v2[1] = ex - sx;
    v2[2] = ey - sy;
    d1 = sqrt(v1[1]*v1[1] + v1[2]*v1[2]);
    d2 = sqrt(v2[1]*v2[1] + v2[2]*v2[2]);
    if (d1<=(tol0*d2)) // superimposes on start node
        return 1;

    d3 = v1[1]*v2[1] + v1[2]*v2[2];
    sum = fabs(d3/d2-d1);
    if (sum<=(tol0*d2)) {
        ratio = d1/d2;
        if (fabs(ratio-1.)<=tol0) return 2;
        else if (ratio<1.) return 3;
    }
    
    return 0;
}

double *line_exp_perp_2d ( double *p1, double *p2, double *p3, int DIM_NUM )

//********************************************************************
//
//  Purpose:
//
//    LINE_EXP_PERP_2D computes a line perpendicular to a line and through a point.
//
//    Input, double P1[2], P2[2], two points on the given line.
//    Input, double P3[2], a point not on the given line, through which the
//    perpendicular must pass.
//
//    Output, double LINE_EXP_PERP_2D[2], a point on the given line, such that the line
//    through P3 and P4 is perpendicular to the given line.
//
{
  double bot;
  double *p4;
  double t;

  p4 = new double[DIM_NUM];

  for (long i=0; i<DIM_NUM; i++) {
      p4[i] = 0.;
  }
  bot = pow ( p2[0] - p1[0], 2 ) + pow ( p2[1] - p1[1], 2 );

  if ( bot == 0.0 )
  {
    std::cout << "\n";
    std::cout << "LINE_EXP_PERP_2D - Fatal error!\n";
    std::cout << "  The points P1 and P2 are identical.\n";
    exit ( 1 );
  }
//
//  (P3-P1) dot (P2-P1) = Norm(P3-P1) * Norm(P2-P1) * Cos(Theta).
//
//  (P3-P1) dot (P2-P1) / Norm(P3-P1)**2 = normalized coordinate T
//  of the projection of (P3-P1) onto (P2-P1).
//
  t = ( ( p1[0] - p3[0] ) * ( p1[0] - p2[0] ) 
      + ( p1[1] - p3[1] ) * ( p1[1] - p2[1] ) ) / bot;

  p4[0] = p1[0] + t * ( p2[0] - p1[0] );
  p4[1] = p1[1] + t * ( p2[1] - p1[1] );

  return p4;
}

// Function to detect a point within or out of given triangular
int tri_inout(double x, double y, double xi, double yi, double xj, double yj, double xk, double yk)
/*
double x, y;          // checked point
double xi, yi;        //  node i
double xj, yj;        //  node j
double xk, yk;        //  node k
*/
{
    long  num_cross, status;
    
    num_cross = 0;
    // check if the point is on the triangle nodes
    if ( (IsEqual(x, xi, TinyZero) && IsEqual(y, yi, TinyZero)) ||
         (IsEqual(x, xj, TinyZero) && IsEqual(y, yj, TinyZero)) ||
         (IsEqual(x, xk, TinyZero) && IsEqual(y, yk, TinyZero)) )
         return 1;
    
    // if( (x==xi && y==yi) || (x==xj && y==yj) || (x==xk && y==yk)) return 1;
    
    // check if the point is on the triangle edges
    if (ptOnLine(xi, yi, xj, yj, x, y)!=0) return 1;
    if (ptOnLine(xj, yj, xk, yk, x, y)!=0) return 1;
    if (ptOnLine(xk, yk, xi, yi, x, y)!=0) return 1;

    status = CCrossLine( x, y, xi, yi, xj, yj );
    if( status == 1 ) num_cross++;
    
    status = CCrossLine( x, y, xj, yj, xk, yk );
    if( status == 1 ) num_cross++;
    
    status = CCrossLine( x, y, xk, yk, xi, yi );
    if( status == 1 ) num_cross++;
    
//  if( num_cross/2 ==  ((double)num_cross/2.) )
    if( (num_cross/2*2) ==  num_cross )
        return -1; // outbound
    else
        return 1;  // inbound
}

/* Thie routine sends a horizontal ray starting at (x1,y1) ending at infinite.
   It tests if the ray intersects the line segment (x3,y3)-(x4,y4) or not.
   Returns:      1 - if the ray crossies the line;
                 0 - if it dosn't cross the line.
*/
int CCrossLine(double x1, double y1, double x3, double y3, double x4, double y4 )
{
    double m, b, xi;
    
    if ( x3<=x1 && x4<=x1 ) return(0);
    
    m = (y3-y1)*(y4-y1);
    if ( m > 0 ) return(0);
    
    if ( m == 0 )
        if ( y1<=y3 && y1<=y4 ) return(0);
    
    if ( fabs(x4-x3) < TinyZero )
        xi = x3;
    else if ( fabs(y4-y3) < TinyZero )
        return(0);
    else {
        m = (y4-y3)/(x4-x3);
        b = y3 - m * x3;
        xi = (y1 - b)/m;
    }
    
    if ( xi > x1 ) return(1);
    else return(0);
}

// Function find area coordinate
void cal_area_coor( double x, double y, double xx[], double yy[], double a_coor[] )
/*
double  x, y;          // given point 
double  xx[], yy[];    // given triangular 
double  a_coor[];      // return area coordinates 
*/
{
    long   m;
    double det_x, det_y, d, area, area_tmp;
    
    for( m=0; m<3; m++ )
        a_coor[m] = 0.0;
    
    area = 0.0; 
    for( m=0; m<3; m++ ) {
        // area = area + xx[m] * (yy[imod(m+1,3)] - yy[imod(m+2,3)]);
        area += xx[m] * (yy[(m+1)%3] - yy[(m+2)%3]);
    }
    area *= 0.5;
    
    if( area < 0.0 ) {
        std::cout << std::endl << " Clockwise triangle: area = " << area << std::endl;
        area = -area; //Ziji, more efficient
    }
    
    for( m=0; m<3; m++ ) {
        // det_x = xx[imod(m+1,3)] - xx[imod(m+2,3)];
        // det_y = yy[imod(m+1,3)] - yy[imod(m+2,3)];
        // d = xx[imod(m+1,3)]*yy[imod(m+2,3)] - xx[imod(m+2,3)]*yy[imod(m+1,3)];
        det_x = xx[(m+1)%3] - xx[(m+2)%3];
        det_y = yy[(m+1)%3] - yy[(m+2)%3];
        d = xx[(m+1)%3] * yy[(m+2)%3] - xx[(m+2)%3] * yy[(m+1)%3];
        area_tmp = 0.5 * (d + x * det_y - y * det_x);
        if( area_tmp < 0.0 ) {
            area_tmp = -area_tmp; //Ziji, more efficient
        }
        a_coor[m] = area_tmp / area;
    }
}

// Finds the nearest point on a line to a point in 2D and returns it in pn[]
int line_exp_point_near_2d ( double p1[2], double p2[2], double p[2], double (&pn)[2], double &dist, double &t, double tinyzero) {
/*
!! LINE_EXP_POINT_NEAR_2D computes the point on an explicit line nearest a point in 2D.
!    Input
!    p1[] and p2[] are two points on the line.  p1[] must be different from p2[]
!    p[] the point whose nearest neighbor on the line is to be determined.
!
!    Output, pn[] the nearest point on the line to p[].
!    dist, the distance from the point to the line.
!
!    Output, real t, the relative position of the point
!    pn[] to the points p1[] and p2[]
!
!    pn[] = (1-t)*p1[] + t*p2[].
!
!    Less than 0, pn[] is furthest away from p2[]
!    Between 0 and 1, pn[] is between p1[] and p2[].
!    Greater than 1, pn[] is furthest away from p1[].
*/
    double bot, x1, x2, y1, y2, x, y;
    x1 = p1[0]; y1 = p1[1];
    x2 = p2[0]; y2 = p2[1];
    x  =  p[0];  y =  p[1];
    bot = pow(x2-x1,2) + pow(y2-y1,2);

    if ( IsEqual(bot, 0, tinyzero) ) {
        std::cout << std::endl << "LINE_POINT_NEAR_2D - Warning! Points defining the line are identical!" << std::endl;
        pn[0] = p1[0]; pn[1] = p1[1];
        t = 0;
    }
    else {
      t = ( ( x1 - x ) * ( x1 - x2 ) + ( y1 - y ) * ( y1 - y2 ) ) / bot;
      pn[0] = x1 + t * ( x2 - x1 );
      pn[1] = y1 + t * ( y2 - y1 );
    }
  dist = v_dist( pn, p, 2 );

  return OK;
}

// Converts an explicit plane to implicit form in 3D.
void plane_exp2imp_3d ( double x1, double y1, double z1, double x2, double y2, 
  double z2, double x3, double y3, double z3, double &a, double &b, double &c, 
  double &d )
 /*
  Purpose:
    PLANE_EXP2IMP_3D converts an explicit plane to implicit form in 3D.
  Definition:
    The explicit form of a plane in 3D is
      (X1,Y1,Z1), (X2,Y2,Z2), (X3,Y3,Z3).
    The implicit form of a plane in 3D is
      A * X + B * Y + C * Z + D = 0
  Parameters:
    Input, float X1, Y1, Z1, X2, Y2, X2, X3, Y3, Z3, are three points
    on the plane, which must be distinct, and not collinear.
    Output, float *A, *B, *C, *D, coefficients which describe the plane.
*/
{
  a = ( y2 - y1 ) * ( z3 - z1 ) - ( z2 - z1 ) * ( y3 - y1 );
  b = ( z2 - z1 ) * ( x3 - x1 ) - ( x2 - x1 ) * ( z3 - z1 );
  c = ( x2 - x1 ) * ( y3 - y1 ) - ( y2 - y1 ) * ( x3 - x1 );
  d = - x2 * a - y2 * b - z2 * c;

}

double signed_tetrahedron_vol(double a[3], double b[3], double c[3],  double d[3]) {
    double (*tet)[3] = new double[4][3];
    for (int i=0; i<3; ++i) {
        tet[0][i] = a[i];
        tet[1][i] = b[i];
        tet[2][i] = c[i];
        tet[3][i] = d[i];
    }
    return signed_tetrahedron_vol(tet);
}

double signed_tetrahedron_vol(double (*tetra)[3]) {
/* computes the signed volume of a tetrahedron whose points are given in tetra.
 * tetra is a 4x3 matrix containing coordinates of the vertices of the tetrahedron
 */
    double a[4][4];
    for (register int i=0; i<4; a[i][0]=tetra[i][0], a[i][1]=tetra[i][1], a[i][2]=tetra[i][2], a[i][3]=1.0, ++i);
    
    return rmat4_det(a) / 6.0;
}

double tetra_volume_3d ( double x1, double y1, double z1, double x2, 
  double y2, double z2, double x3, double y3, double z3, double x4, 
  double y4, double z4 )

/**********************************************************************/
/*
    TETRA_VOLUME_3D computes the volume of a tetrahedron in 3D.
    Input, float X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3, X4, Y4, Z4, the 
    coordinates of the corners of the tetrahedron.
    Output, float TETRA_VOLUME_3D, the volume of the tetrahedron.
*/
{
    double a[4][4] = { {x1,y1,z1,1.0}, {x2,y2,z2,1.0}, {x3,y3,z3,1.0}, {x4,y4,z4,1.0} };
  // double b[2][2] = { {x1,y1},{x2,y2} };

/*
  a[0][0] = x1;  a[1][0] = x2;  a[2][0] = x3;  a[3][0] = x4;

  a[0][1] = y1;  a[1][1] = y2;  a[2][1] = y3;  a[3][1] = y4;

  a[0][2] = z1;  a[1][2] = z2;  a[2][2] = z3;  a[3][2] = z4;

  a[0][3] = 1.0;  a[1][3] = 1.0;  a[2][3] = 1.0;  a[3][3] = 1.0;*/

    return fabs ( rmat4_det ( a ) ) / 6.0;
}


double rmat4_det ( double a[4][4] )
/*
    RMAT4_DET computes the determinant of a 4 by 4 matrix.
    Input, double A[4][4], the matrix whose determinant is desired.
    Output, double RMAT4_DET, the determinant of the matrix.
*/
{
  double det =
      a[0][0] * (
          a[1][1] * ( a[2][2] * a[3][3] - a[2][3] * a[3][2] )
        - a[1][2] * ( a[2][1] * a[3][3] - a[2][3] * a[3][1] )
        + a[1][3] * ( a[2][1] * a[3][2] - a[2][2] * a[3][1] ) )
    - a[0][1] * (
          a[1][0] * ( a[2][2] * a[3][3] - a[2][3] * a[3][2] )
        - a[1][2] * ( a[2][0] * a[3][3] - a[2][3] * a[3][0] )
        + a[1][3] * ( a[2][0] * a[3][2] - a[2][2] * a[3][0] ) )
    + a[0][2] * (
          a[1][0] * ( a[2][1] * a[3][3] - a[2][3] * a[3][1] )
        - a[1][1] * ( a[2][0] * a[3][3] - a[2][3] * a[3][0] )
        + a[1][3] * ( a[2][0] * a[3][1] - a[2][1] * a[3][0] ) )
    - a[0][3] * (
          a[1][0] * ( a[2][1] * a[3][2] - a[2][2] * a[3][1] )
        - a[1][1] * ( a[2][0] * a[3][2] - a[2][2] * a[3][0] )
        + a[1][2] * ( a[2][0] * a[3][1] - a[2][1] * a[3][0] ) );

  return det;
}

// Returns volume quality measure of a tetrahedron
double tetra_vol_quality(double (*tet)[3], double orig_vol) {
/* It returns the ratio of tet's volume to that of a regular tet whose edge
length is the maximum edge length of tet
*/
    double edgelen=0., maxlen=0.;
    double vol = orig_vol;

    // calculate the volume of the tetrahedron using its coordinates
    if (vol == 0.)
        vol = tetra_volume_3d(tet[0][0],tet[0][1],tet[0][2],
                    tet[1][0],tet[1][1],tet[1][2],
                    tet[2][0],tet[2][1],tet[2][2],
                    tet[3][0],tet[3][1],tet[3][2]);

    //Find the maximum edge length of the tet
    double p1[3], p2[3];
    for (int i=0; i<3; ++i) {
        for (int j=i+1; j<4; ++j) {
            for (int k=0;k<3;++k) {
                p1[k]=tet[i][k];
                p2[k]=tet[j][k];
            }
            edgelen = dist_pp(p1,p2);
            if (edgelen > maxlen)
                maxlen = edgelen;
        }
    }

    //Calculate the volume of a regular tet whose edge has a length of 'maxlen'
    // and return the ratio of volumes as a quality measure
    return vol/(sqrttwo/12.*maxlen*maxlen*maxlen);
}

// Returns volume quality measure of a tetrahedron
double tetra_quality3(double (*tet)[3], double orig_vol) {
    /* Taken from:
     http://www-math.mit.edu/~persson/mesh/
     */
    double vol = orig_vol;
    
    // calculate the volume of the tetrahedron using its coordinates
    if (vol == 0.)
        vol = tetra_volume_3d(tet[0][0],tet[0][1],tet[0][2],
                              tet[1][0],tet[1][1],tet[1][2],
                              tet[2][0],tet[2][1],tet[2][2],
                              tet[3][0],tet[3][1],tet[3][2]);
    
    //Find the edge lengths of the tet
    double edgel=0.;
    double p1[3], p2[3];
    for (int i=0; i<3; ++i) {
        for (int j=i+1; j<4; ++j) {
            for (int k=0;k<3;++k) {
                p1[k]=tet[i][k];
                p2[k]=tet[j][k];
            }
            edgel += (p2[0]-p1[0])*(p2[0]-p1[0]) + (p2[1]-p1[1])*(p2[1]-p1[1]) + (p2[2]-p1[2])*(p2[2]-p1[2]);
        }
    }
    
    //Calculate the volume of a regular tet whose edge has a length of 'maxlen'
    // and return the ratio of volumes as a quality measure
    return 216*vol/sqrtthree/pow(edgel,1.5);
}
// Checks if a ray intersects a 3D triangular patch
int intersect_RayTriangle(double *rp1, double *rp2, double *tp1, double *tp2, double *tp3, double *I, double global_tiny) {
    /*  Input:  a ray R, and a triangle T
     Output: *I = intersection point (when it exists)
     Return: 0 - no intersection point at all
     1 - valid intersection, intersection point is inside triangle but not on any of the edges
     10, 11, 12 - intersection point on edge #0, 1, 2
     20, 21, 22 - intersection point on node #0, 1, 2
     2 - are in the same plane and the ray (rp1-rp2) is NOT overlapping (fully/partially) with one of the edges
     Please note that this routine returns above values if a real/proper intersection happens. In case the ray is in
     the plane of triangle we might still have intersection of ray and triangle edges but we don't consider it
     a proper crossing of ray through triangle. In this case, the routine returns following values:
     100, 101, 102 - intersection point on edge #0, 1, 2
     200, 201, 202 - intersection point on node #0, 1, 2
     300, 301, 302 - intersection points on edge #0&1, 1&2, 2&0
     400, 401, 402 - intersection points are n0e1, n1e2, n2e0
     500, 501, 502 - ray coincides (fully/partially) with edge #0, 1, 2
     So basically if return value is greater than 100, we have a coplanar ray/triangle situation.
     */
    // get triangle edge vectors and plane normal;
    int intersect;
    bool sumisone = false;
    double u[3],v[3];
    /*double *vec = new double[3];
     double *n   = new double[3];*/
    double n[3];
    v_make(tp1, tp2, 3, u);
    v_make(tp1, tp3, 3, v);
    v_cros(u, v, 3, n);
    
    double euclu = v_magn(u,3);
    double euclv = v_magn(v,3);
    // euclu = v_magn(u,3); euclv = v_magn(v,3); // length of u and v
    double tiny = std::min(global_tiny / std::max(euclu, euclv), global_tiny);
    
    if (IsEqual(n[0],0,tiny) && IsEqual(n[1],0,tiny) && IsEqual(n[2],0,tiny)) {// triangle is degenerate
        intersect = -1;               // do not deal with this case
        return intersect;
    }
    
    double dir[3];
    v_make(rp1, rp2, 3, dir); // rp2 - rp1; %R.P1 - R.P0;             // ray direction vector
    double w0[3];
    v_make(tp1, rp1, 3, w0); //rp1 - tp1; %R.P0 - T.V0;
    double a = -v_dot(n,w0,3);  if (IsEqual(a,0,tiny)) a=0.;
    double b =  v_dot(n,dir,3); if (IsEqual(b,0,tiny)) b=0.;
    if (fabs(b) < tiny)    { // ray is parallel to triangle plane
        if (IsEqual(a,0,tiny)) {              // ray lies in triangle plane
            std::vector< std::vector<double> > p;
            int st2 = ray_triangle_coplanar(rp1,rp2,tp1,tp2,tp3,p,global_tiny);
            return (st2==0 ? 2 : st2);
        }
        else {
            return 0;         // ray disjoint from plane
        }
    }
    
    
    // get intersect point of ray with triangle plane
    if (IsEqual(a/b,0,tiny)) a=0.;
    bool tflag = (a*b<0) || ((a<0 || b<0) && a<b) || ((a>0 || b>0) && a>b);
    if (tflag) { // No intersection, either ray goes away from plane or the segment doesn't reach it.
        intersect = 0;
        return intersect;
    }
    double r = a / b;
    for (register int i=0; i<3; ++i) {
        I[i] = rp1[i] + r*dir[i]; // I = rp1 + r*dir; % R.P0 + r * dir;           // intersect point of ray and plane
    }
    
    
    // is I inside T?
    double uu = v_dot(u,u,3);
    double uv = v_dot(u,v,3);
    double vv = v_dot(v,v,3);
    double w[3];
    for (register int i=0; i<3; ++i) {
        w[i] = I[i] - tp1[i]; // w = I - tp1;
    }
    
    double wu = v_dot(w,u,3);
    double wv = v_dot(w,v,3);
    double D = uv * uv - uu * vv;
    
    // get and test parametric coords
    double temp1 = (uv * wv - vv * wu);
    if (IsEqual(temp1,0,tiny) || IsEqual(temp1/D,0,tiny)) temp1=0.;
    tflag = (temp1*D<0) || ((temp1<0 || D<0) && temp1<D) || ((temp1>0 || D>0) && temp1>D);
    if (tflag) {
        intersect = 0;
        return intersect;
    }
    double s = temp1 / D;
    if (IsEqual(s,0,tiny)) s=0;
    if (IsEqual(s,1,tiny)) s=1;
    
    double t = (uv * wu - uu * wv) / D;
    if (IsEqual(s+t,1.,tiny)) sumisone = true;
    if (t < 0.0 || (sumisone != true && (s + t) > 1.0))  {// I is outside T
        intersect = 0;
        return intersect;
    }
    bool szero = IsEqual(s,0,tiny);
    bool tzero = IsEqual(t,0,tiny);
    if (szero && tzero) {
        intersect = 20;
        return intersect;
    }
    if (IsEqual(s,1,tiny) && tzero) {
        intersect = 21;
        return intersect;
    }
    if (szero && IsEqual(t,1,tiny)) {
        intersect = 22;
        return intersect;
    }
    if (tzero /*&& !IsEqual(s,0,tiny)*/) {
        intersect = 10;
        return intersect;
    }
    if (szero /*&& !IsEqual(t,0,tiny)*/) {
        intersect = 12;
        return intersect;
    }
    if (sumisone == true) {
        intersect = 11;
        return intersect;
    }
    intersect = 1;
    return intersect;
}

int point_in_tetrahedron(double *v1, double *v2, double *v3, double *v4, double *p, double tiny) {
/* Checks to see if point 'p' is inside tethedron defined by 4 vertices v1,
    v2, v3 and v4.
    it returns:
    -1 if tet is degenerate
    -2 if tet is invalid
    0 if point is not inside tet
    1 if point is inside tet
    20,21,22,23 if point is on one of the faces (face 20 is the face not
                                                 containing v1, face 21 is the face not containing v2...)
    30,31,32,33,34,35 if the point is on one of the edges
        30 : Edge is intersection of face 20 and 21
        31 : Edge is intersection of face 20 and 22
        32 : Edge is intersection of face 20 and 23
        33 : Edge is intersection of face 21 and 22
        34 : Edge is intersection of face 21 and 23
        35 : Edge is intersection of face 22 and 23
    40,41,42,43 if the point is on one of the vertices
        40 : Vertex v1
        41 : Vertex v2
        42 : Vertex v3
        43 : Vertex v4 */
                                
    double v[4][4], temp[4][4], d[4];
    int st=0;
    v[0][0] = v1[0]; v[0][1] = v1[1]; v[0][2] = v1[2]; v[0][3] = 1;
    v[1][0] = v2[0]; v[1][1] = v2[1]; v[1][2] = v2[2]; v[1][3] = 1;
    v[2][0] = v3[0]; v[2][1] = v3[1]; v[2][2] = v3[2]; v[2][3] = 1;
    v[3][0] = v4[0]; v[3][1] = v4[1]; v[3][2] = v4[2]; v[3][3] = 1;

    for (int i=0; i<4; ++i)
        for (int j=0; j<4; ++j)
            temp[i][j] = v[i][j];

    double d0 = rmat4_det(v);
    if (IsEqual(d0, 0., tiny)) {
        st = -1;
        return st;
    }
    double mysign = d0/fabs(d0);

    temp[0][0] = p[0]; temp[0][1] = p[1]; temp[0][2] = p[2];
    d[0] = rmat4_det(temp);
    if (mysign*d[0]<0) return 0;
    for (int i=0; i<4; ++i)
        for (int j=0; j<4; ++j)
            temp[i][j] = v[i][j];
    
    temp[1][0] = p[0]; temp[1][1] = p[1]; temp[1][2] = p[2];
    d[1] = rmat4_det(temp);
    if (mysign*d[1]<0) return 0;
    for (int i=0; i<4; ++i)
        for (int j=0; j<4; ++j)
            temp[i][j] = v[i][j];
    
    temp[2][0] = p[0]; temp[2][1] = p[1]; temp[2][2] = p[2];
    d[2] = rmat4_det(temp);
    if (mysign*d[2]<0) return 0;
    for (int i=0; i<4; ++i)
        for (int j=0; j<4; ++j)
            temp[i][j] = v[i][j];
    
    temp[3][0] = p[0]; temp[3][1] = p[1]; temp[3][2] = p[2];
    d[3] = rmat4_det(temp);
    if (mysign*d[3]<0) return 0;
    
    if (!IsEqual(d0,d[0]+d[1]+d[2]+d[3],tiny)) {
        st = -2;
        return st;
    }
    int st_table[16]={-1,40,41,35,42,34,32,23,43,33,31,22,30,21,20,1};
    int idx=0, c=0;
    for (int i=0; i<4; ++i) {
        if (IsEqual(d[i],0.,tiny)) {
            d[i]=0.;
            ++c;
        }
        else
            d[i]=1.;
        idx += (int)((pow(2., i)*d[i]));
    }
    assert(c!=4);
    return st_table[idx];
}

int point_inside_segment(double *s, double *e, double *p, double tiny) {
/* Checks to see if p lies on line defined by s and e and if it's between those end points.
   It returns:
        0: p is on the line but is NOT between end points
        1: p is on the line and is between end points
        2: p does not lie on the line
*/
    int st;
    if (!IsEqual(dist_lp3d(s,e,p),0,tiny)) {
        st = 2;
        return st;
    }
    double d,s1,s2;
    d = dist_pp(s,e);
    s1 = dist_pp(p,s);
    s2 = dist_pp(p,e);
    if (IsEqual(d,s1+s2,tiny))
        st=1;
    else
        st=0;
    return st;
}
int point_in_triangle(double *tp1, double *tp2, double *tp3, double *I, double global_tiny) {
/*Checks if point I is inside triagnle defined by tp1,tp2 and tp2.
% this routine assumes that I is on the same plane as the triangle
% it returns:
%   0: outside
%   1: inside
%   10, 11, 12: on triangle edge 1, 2 or 3
%   20, 21, 22: on triangle vertex 1,2 or 3*/

    int intersect;
    bool sumisone = false;
    double u[3], v[3];
    /*double *vec = new double[3];
    double *n   = new double[3];*/
    double n[3];
    v_make(tp1, tp2, 3, u);
    v_make(tp1, tp3, 3, v);
    v_cros(u, v, 3, n);

    double euclu = v_magn(u,3);
    double euclv = v_magn(v,3);
    // euclu = v_magn(u,3); euclv = v_magn(v,3); // length of u and v
    double tiny = std::min(global_tiny / std::max(euclu, euclv), global_tiny);
    
    if (IsEqual(n[0],0,tiny) && IsEqual(n[1],0,tiny) && IsEqual(n[2],0,tiny)) {// triangle is degenerate
        intersect = -1;               // do not deal with this case
        return intersect;
    }

    double uu = v_dot(u,u,3);
    double uv = v_dot(u,v,3);
    double vv = v_dot(v,v,3);
    double w[3];
    for (int i=0;i<3;++i) {
        w[i] = I[i] - tp1[i]; // w = I - tp1;
    }
    
    double wu = v_dot(w,u,3);
    double wv = v_dot(w,v,3);
    double D = uv * uv - uu * vv;

    // get and test parametric coords
    double s = (uv * wv - vv * wu) / D;
    if (IsEqual(s,0,tiny)) s=0.;
    if (IsEqual(s,1,tiny)) s=1.;
    if (s < 0.0 || s > 1.0) {       // I is outside T
        intersect = 0;
        return intersect;
    }
    double t = (uv * wu - uu * wv) / D;
    if (IsEqual(t,0,tiny)) t=0.; 
    if (IsEqual(t,1,tiny)) t=1.; 
    if (IsEqual(s+t,1.,tiny)) sumisone = true;
    if (t < 0.0 || (sumisone != true && (s + t) > 1.0))  {// I is outside T
        intersect = 0;
        return intersect;
    }
    if (IsEqual(s,0,tiny) && IsEqual(t,0,tiny)) {
        intersect = 20;
        return intersect;
    }
    if (IsEqual(s,1,tiny) && IsEqual(t,0,tiny)) {
        intersect = 21;
        return intersect;
    }
    if (IsEqual(s,0,tiny) && IsEqual(t,1,tiny)) {
        intersect = 22;
        return intersect;
    }
    if (IsEqual(t,0,tiny) && !IsEqual(s,0,tiny)) {
        intersect = 10;
        return intersect;
    }
    if (IsEqual(s,0,tiny) && !IsEqual(t,0,tiny)) {
        intersect = 12;
        return intersect;
    }
    if (sumisone == true) {
        intersect = 11;
        return intersect;
    }
    intersect = 1;
    return intersect;
}
double dist_lp3d(double *a, double *b, double *p) {
    double pa[3], ba[3], crossp[3];
    v_make(a,p,3,pa);
    v_make(a,b,3,ba);
    double d = v_magn(ba,3);
    if (IsEqual(d,0.,TinyZero))
        return v_magn(pa,3);
    else {
        v_cros(pa,ba,3,crossp);
        return v_magn(crossp,3)/d;
    }
}
// function to check intersection of a ray and triangle if we already know that they are on the same plane.
// Behaviour of this function is undefined if it's called with non-conplanar ray/triangle.
// it returns:
// 0        : no intersection
// 100, 101, 102 - intersection point on one edge #0, 1, 2
// 200, 201, 202 - intersection point on node #0, 1, 2
// 300, 301, 302 - intersection points on two edges #0&1, 1&2, 2&0
// 400, 401, 402 - intersection points are n0e1, n1e2, n2e0
// 500, 501, 502 - ray coincides with edge #0, 1, 2
// -1            - a bug is found! report to sullivan@wpi.edu or hamid@alum.wpi.edu
int ray_triangle_coplanar(double rp1[3], double rp2[3], double tp1[3], double tp2[3], double tp3[3], std::vector<std::vector<double> > &ipnt, double global_tiny) {
    int lnlnst, idx;
    bool e[3] ={false,false,false}; bool n[3]={false,false,false};
    int edge_order[3]={0,0,0};
    int node_order[3]={0,0,0};
    int order_counter=0;
    std::vector<std::vector<double> > tmp;
    std::vector<double> rowvector;
    ipnt.clear();
    // global_tiny = std::min(global_tiny,1e-10);
    // check edge 1
    double p[3];
    lnlnst = segseg(rp1,rp2,tp1,tp2,global_tiny,p);
    if (lnlnst==1 || lnlnst==10 || lnlnst==11) {// intersection on edge 1 of triangle
        e[0] = true;
        edge_order[0]=++order_counter;
    }
    else if (lnlnst==12 || lnlnst==13) {// intersection on one of the vertices
        idx = lnlnst%10-2;
        n[idx]=true;
        node_order[idx]=++order_counter;
    }
    else if (lnlnst==200 || lnlnst==201) {// intersection on one of the vertices
        idx = lnlnst%200;
        n[idx]=true;
        node_order[idx]=++order_counter;
    }
    else if (lnlnst==210 || lnlnst==211) {// intersection on one of the vertices
        idx = lnlnst%210;
        n[idx]=true;
        node_order[idx]=++order_counter;
    }
    else if (lnlnst==2)
        return 500;
    if (lnlnst!=0) {
        for (int ii=0; ii<3; rowvector.push_back(p[ii]), ++ii)
            ;
        tmp.push_back(rowvector);
        rowvector.clear();
    }
    
    // check edge 2
    lnlnst = segseg(rp1,rp2,tp2,tp3,global_tiny,p);
    if (lnlnst==1 || lnlnst==10 || lnlnst==11) {// intersection on edge 2 of triangle
        e[1] = true;
        edge_order[1] = ++order_counter;
    }
    else if (lnlnst==12 || lnlnst==13)  {// intersection on one of the vertices
        idx = lnlnst%10-1;
        n[idx]=true;
        node_order[idx]= !node_order[idx] ? ++order_counter : node_order[idx];
    }
    else if (lnlnst==200 || lnlnst==201) {// intersection on one of the vertices        
        idx = lnlnst%200+1;
        n[idx]=true;
        node_order[idx]= !node_order[idx] ? ++order_counter : node_order[idx];
    }
    else if (lnlnst==210 || lnlnst==211) { // intersection on one of the vertices
        idx = lnlnst%210+1;
        n[idx]=true;
        node_order[idx]= !node_order[idx] ? ++order_counter : node_order[idx];
    }
    else if (lnlnst==2)
        return 501;
    if (lnlnst!=0) {
        for (int ii=0; ii<3; rowvector.push_back(p[ii]), ++ii)
            ;
        tmp.push_back(rowvector);
        rowvector.clear();
    }
    
    // check edge 3
    lnlnst = segseg(rp1,rp2,tp1,tp3,global_tiny,p);
    if (lnlnst==1 || lnlnst==10 || lnlnst==11) {// intersection on edge 3 of triangle
        e[2] = true;
        edge_order[2] = ++order_counter;
    }
    else if (lnlnst==12 || lnlnst==13) {// intersection on one of the vertices
        idx = (lnlnst==12 ? 0 : 2);
        n[idx]=true;
        node_order[idx] = !node_order[idx] ? ++order_counter : node_order[idx];
    }
    else if (lnlnst==200 || lnlnst==201) {// intersection on one of the vertices
        idx = ((lnlnst==200) ? 0 : 2);
        n[idx]=true;
        node_order[idx] = !node_order[idx] ? ++order_counter : node_order[idx];
    }
    else if (lnlnst==210 || lnlnst==211) {// intersection on one of the vertices
        idx = ((lnlnst==210) ? 0 : 2);
        n[idx]=true;
        node_order[idx] = !node_order[idx] ? ++order_counter : node_order[idx];
    }
    else if (lnlnst==2)
        return 502;
    if (lnlnst!=0) {
        for (int ii=0; ii<3; rowvector.push_back(p[ii]), ++ii)
            ;
        tmp.push_back(rowvector);
        rowvector.clear();
    }
    
    // Determine the return code
    int i;
    int nc=0, ec=0; // set number of node and edge intersections to zero
    for (i=0; i<3; ++i) {
        if (n[i])
            ++nc;
        if (e[i])
            ++ec;
    }
    // Just checking to make sure that we have covered only and only possible intersection scenarios
    assert(ec<3 && nc<2 || (nc==1 && ec==0) || (nc==1 && ec==1) 
           || (nc==0 && ec==1) || (nc==0 && ec==2) || (nc==0 && ec==0));
    
    if (nc==0 && ec==0) // no intersection
        return 0;
    else if (nc==0 && ec==1) {
        assert(tmp.size()==1);
        ipnt.push_back(tmp[0]);
        for (i=0; i<3; ++i)
            if (e[i])
                return 100+i;
        assert(false); // we should never hit this statement
    }
    else if (nc==0 && ec==2) {
        assert(tmp.size()==2);
        for (i=0; i<3; ++i) {
            if (e[i] && e[(i+1)%3]) {
                if (edge_order[i]>edge_order[(i+1)%3]) {
                    ipnt.push_back(tmp[1]);
                    ipnt.push_back(tmp[0]);
                }
                else {
                    ipnt.push_back(tmp[0]);
                    ipnt.push_back(tmp[1]);
                }
                return 300+i;
            }
        }
        assert(false); // we should never hit this statement
    }
    else if (nc==1 && ec==0) {
        assert(tmp.size()==2);
        for (i=0; i<3; ++i)
            if (n[i]) {
                ipnt.push_back(tmp[0]);
                return 200+i;
            }
        assert(false); // we should never hit this statement
    }
    else if (nc==1 && ec==1) {
        assert(tmp.size()==3);
        for (i=0; i<3; ++i) {
            if (n[i]) {
                assert(e[(i+1)%3]); // we should be only crossing over the edge opposite of n[i]
                ipnt.push_back(tmp[node_order[i]]);
                ipnt.push_back(tmp[(i+1)%3]);
                return 400+i;
            }
        }
        assert(false); // we should never hit this statement
    }
    return -1;
}

//% Routine to check if two line segments in 3D intersect or not!
//======================================
//% Written by: 
//% Hamid Ghadyani (Sep 26, 2007) (written out of frustration 
//% caused by lnln algorithm, specially when we had to perturb the start 
//% points to avoid zero cross products).
//=======================================
//% Based on idea from Ziji's code:
//% If we present two lines in their parametric form:
//% s = p1 + (p2-p1)*u  and  
//% t = p3 + (p4-p3)*v 
//% where 0 < u,v <1
//% then the two lines will intersect if we can find a value of u and v
//% between 0 and 1 that satisfies s == t
//% Of course taking care of degenerate situations is the most important part
//% of this routine ;)
//%========================================
//% input: line1 : p1-p2
//%        line2 : p3-p4
//%        tiny  : zero tolerance (if tiny<0, the routine will calculate it
//%                based on length of two segments
//%        twoD  : Flag to tell routine that points are in 2D
//% output: st : status of intersection
//%         0       : no valid intersection
//%         1       : valid intersectin (two segments cross over each other and
//%                   intersection point is none of the end points of the segments)
//%         10,11   : segment 2 is passing through one of the end points of
//%                   segment 1
//%         12,13   : segment 1 is passing through one of the end points of
//%                   segment 2
//%         200,201 : first  point of segment 1 is shared with one of the end
//%                   points of segment 2
//%         210,211 : second point of segment 1 is shared with one of the end
//%                   points of segment 2
//%         2       : if two segments are colinear and overlapping
//%         I[3]    : the intersection point if any
//==========================================
int segseg(double p1[3], double p2[3], double p3[3], double p4[3], double tiny, double *I, bool twoD) {
    double a[3],b[3],c[3],d[3];
    int st;
    if (twoD)
        p1[2]=p2[2]=p3[2]=p4[2]=0.;
    
    for (register int i=0; i<3; a[i]=p1[i], b[i]=p2[i]-p1[i], c[i]=p3[i], d[i]=p4[i]-p3[i], ++i)
        ;
    if (tiny < 0) {
        double lab = 0.; double lcd = 0.;
        double ab[3], cd[3];
        for (register int i=0; i<3; ab[i]=p2[i]-p1[i], cd[i]=p4[i]-p3[i], ++i)
            ;
        lab = v_magn(ab,3);
        lcd = v_magn(cd,3);
        tiny = std::min(lab, lcd) / 1e6;
        if (tiny > 1.0)
            tiny = 0.5;
    }
    /*double ab[3], cd[3];
    v_make(p1,p2,3,ab);
    v_make(p3,p4,3,cd);*/
    double len1 = v_magn(b,3);
    double len2 = v_magn(d,3);
//% ======== Take care of degenerate situations ===========
    if (IsEqual(len1,0.,tiny) && IsEqual(len2,0.,tiny)) { //% p1==p2 and p3==p4
        //% check if they are the same points
        if (IsEqual(p1[0],p3[0],tiny) && IsEqual(p1[1],p3[1],tiny) && IsEqual(p1[2],p3[2],tiny)) {
            st = 200;
            I[0]=p1[0]; I[1]=p1[1]; I[2]=p1[2];
        }
        else
            st = 0;
        return st;
    }
    if (IsEqual(len1,0.,tiny)) { //% p1==p2
        // % check if p1 lies within the segment p3-p4
        if (point_inside_segment(p3,p4,p1,tiny)==1) {
            I[0]=p1[0]; I[1]=p1[1]; I[2]=p1[2];
            st=1;
        }
        else {
            st=0;
        }
        return st;
    }
    if (IsEqual(len2,0.,tiny)) { // % p3==p4
        // % check if p3 lies within the segment p1-p2
        if (point_inside_segment(p1,p2,p3,tiny)==1) {
            I[0]=p3[0]; I[1]=p3[1]; I[2]=p3[2];
            st=1;
        }
        else {
            st=0;
        }
        return st;
    }
//% ======================================================
    double ac[3], top[3], bot[3];
    v_make(a,c,3,ac);
    v_cros(ac,d,3,top);
    v_cros(b,d,3,bot);

    double botmag = v_magn(bot,3);

    if (IsEqual(botmag,0,tiny)) { // % parallel
        // Check if the segments are disjoint
        double xp[3];
        // v_make(p1,p3,3,vec);
        v_cros(b,ac,3,xp);
        if (!IsEqual(v_magn(xp,3),0.,tiny)) // disjoint
            return 0;
        int i=0;
        while (i<3) {
            if (!IsEqual(b[i],0.,tiny)) {
                break;
            }
            ++i;
        }
        assert(i<3);
        double u[4]={0.,0.,0.,0.};
        u[0]=(p3[i]-p1[i])/b[i];
        u[1]=(p4[i]-p1[i])/b[i];
        u[2]=(p3[i]-p2[i]);
        u[3]=(p4[i]-p2[i]);
        int f[4] = {0,0,0,0}, sumf=0;
        for (int ii=0; ii<4; ++ii) {
            if (IsEqual(u[ii], 0., tiny)) {
                f[ii]=1;
                ++sumf;
            }
        }
        int idx=4;
        switch (sumf) {
            case 0:
                if (point_inside_segment(p1, p2, p3)==1 || point_inside_segment(p1, p2, p4)==1 ||
                    point_inside_segment(p3, p4, p1)==1 || point_inside_segment(p3, p3, p2)==1) {
                        I[0]=u[0]; I[1]=u[1];
                        st=2;
                }
                else {
                    st=0;
                }
                break;
            case 1:
                for (register int i=0; i<4; ++i) {
                    if (f[i]==1) {
                        idx=i;
                        break;
                    }
                }
                switch (idx) {
                    case 0: 
                        if (point_inside_segment(p2,p4,p1)==1) {
                                st=200; I[0]=p1[0]; I[1]=p1[1]; I[2]=p1[2];
                        }
                        else {
                            st=2;
                            I[0]=u[0]; I[1]=u[1];
                        }
                        break;
                    case 1:
                        if (point_inside_segment(p2,p3,p1)==1) {
                                st=201; I[0]=p1[0]; I[1]=p1[1]; I[2]=p1[2];
                        }
                        else {
                            st=2;
                            I[0]=u[0]; I[1]=u[1];
                        }
                        break;
                    case 2:
                        if (point_inside_segment(p1,p4,p2)==1) {
                                st=210; I[0]=p2[0]; I[1]=p2[1]; I[2]=p2[2];
                        }
                        else {
                            st=2;
                            I[0]=u[0]; I[1]=u[1];
                        }
                        break;
                    case 3:
                        if (point_inside_segment(p1,p3,p2)==1) {
                                st=211; I[0]=p2[0]; I[1]=p2[1]; I[2]=p2[2];
                        }
                        else {
                            st=2;
                            I[0]=u[0]; I[1]=u[1];
                        }
                        break;
                    default:
                        std::cout << "Check segseg() code. Two colinear segments are causing an error!" << std::endl;
                        exit(1);
                }
                break;
            case 2: // two line segments are the same
                st=2;
                I[0]=u[0]; I[1]=u[1];
                break;
            default:
                std::cout << "Are you kidding me ?!!!" << std::endl;
                assert(false);
                st=-1;
        }
        return st;
    }
    else {
        double uu[3]={0.,0.,0.}, vv[3]={0.,0.,0.};
        double top2[3],  bot2[3];
        v_make(c,a,3,ac);
        v_cros(ac,b,3,top2);
        v_cros(d,b,3,bot2);
        bool solved=true;
        // solve for u and v
        for (register int i=0; i<3; ++i) {
            if (!IsEqual(bot[i],0.,tiny)) {
                uu[i] = top[i]/bot[i];
            }
            else {
                if (!IsEqual(top[i],0.,tiny)) {
                    solved=false;
                    break;
                }
            }
            if (!IsEqual(bot2[i],0.,tiny)) {
                vv[i] = top2[i]/bot2[i];
            }
            else {
                if (!IsEqual(top2[i],0,tiny)) {
                    solved=false;
                    break;
                }
            }
        }       // check if a solution exists
        for (register int i=0; i<3; ++i) {
            int j1=i, j2=(i+1)%3;
            if (!IsEqual(bot[j1],0.,tiny) && !IsEqual(bot[j2],0.,tiny)) {
                if (!IsEqual(uu[j1],uu[j2],tiny)) {
                    solved=false;
                    break;
                }
            }
            if (!IsEqual(bot2[j1],0.,tiny) && !IsEqual(bot2[j2],0.,tiny)) {
                if (!IsEqual(vv[j1],vv[j2],tiny)) {
                    solved=false;
                    break;
                }
            }
        }
        if (!solved) {
            st = 0;
            return st;
        }
        else { // found solution, thus an intersection might exist
            double u=0.,v=0.;
            bool uset=false, vset=false; // just to catch some odd bug using this flag
            for (register int i=0; i<3; ++i) {
                if (!IsEqual(bot[i],0.,tiny)) {
                    u = uu[i];
                    uset=true;
                }
                if (!IsEqual(bot2[i],0.,tiny)) {
                    v = vv[i];
                    vset=true;
                }
            }
            assert(uset && vset);
            int f[4]={0,0,0,0};
            if (IsEqual(u,0.,tiny)) { u=0.; f[0]=1; }
            if (IsEqual(fabs(u),1.,tiny)) { u=_SIGN(u)*1.; f[1]=1; }
            if (IsEqual(v,0.,tiny)) { v=0.; f[2]=1; }
            if (IsEqual(fabs(v),1.,tiny)) { v=_SIGN(v)*1.; f[3]=1; }
            if (u>1 || u<0 || v>1 || v<0) { //% no intersection
                st = 0;
                return st;
            }
            else {
                int sumf=0;
                for(register int i=0; i<4; sumf+=f[i], ++i);
                int idx=0;
                if (sumf==1) {
                    for (register int i=0; i<4; ++i) {
                        if (f[i]==1) {
                            idx=i;
                            break;
                        }
                    }
                    st=10+idx;
                }
                else if (sumf==2) {
                    int cc=0; int idx[2]={0,0};
                    for (register int i=0; i<4; ++i) {
                        if (f[i]==1) {
                            idx[cc]=i;
                            ++cc;
                        }
                    }
                    st=200+(idx[0])*10+(idx[1]-2);
                }
                else {
                    st = 1;
                }
                double J[3];
                for (register int i=0; i<3; I[i]=a[i]+u*b[i], J[i]=c[i]+v*d[i], ++i);
                // Just to make sure that solution is valid
                assert(IsEqual(I[0],J[0],tiny) && IsEqual(I[1],J[1],tiny) && IsEqual(I[2],J[2],tiny));
                return st;
            }
        }
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

int intersect_ray_triangle_moller(double orig[3], double dir[3],
                              double vert0[3], double vert1[3], double vert2[3],
                              double *t, double *u, double *v, double EPSILON) {
    /*Return:        0 - no intersection point at all
     *            1 - valid intersection, intersection point is inside triangle but not on any of the edges
     *            10, 11, 12 - intersection point on edge #0, 1, 2
     *            20, 21, 22 - intersection point on node #0, 1, 2
     *          2 - ray lies in the plane of triangle, further test is need to see if the ray 
     *              actually intersects with triangle edges on the plane. Use ray_triangle_coplanar()
     * 
     * The intersection point can be calculated using 
     *                             I = orig + t * dir      OR
     *                                 I = (1-u-v)*vert0 + u*vert1 + v*vert2
     */
    
    double edge1[3], edge2[3], tvec[3], pvec[3], qvec[3];
    double det, inv_det;
    /* find vectors for two edges sharing vert0 */
    SUB(edge1, vert1, vert0);
    SUB(edge2, vert2, vert0);
    
    /* begin calculating determinant - also used to calculate U parameter */
    CROSS(pvec, dir, edge2);
    
    /* if determinant is near zero, ray lies in plane of triagnle */
    det = DOT(edge1, pvec);
    
    if (det > -EPSILON && det < EPSILON)
        return 2;
    inv_det = 1.0 / det;
    
    /* calculate distance from vert0 to ray origin */
    SUB(tvec, orig, vert0);
    
    /* calculate U parameter and test bounds */
    *u = DOT(tvec, pvec) * inv_det;
    if (*u < 0.0 || *u > 1.0)
        return 0;
    
    /* prepare to rest V parameter */
    CROSS(qvec, tvec, edge1);
    
    /* calculate V parameter and test bounds */
    *v = DOT(dir, qvec) * inv_det;
    if (*v < 0.0 || *u + *v > 1.0)
        return 0;
    
    /* calculate t, ray intersects triangle */
    *t = DOT(edge2, qvec) * inv_det;
    
    bool uzero = IsEqual(*u,0,EPSILON);
    bool vzero = IsEqual(*v,0,EPSILON);
    if (uzero && vzero) {
        return 20;
    }
    if (IsEqual(*u,1,EPSILON) && vzero) {
        return 21;
    }
    if (uzero && IsEqual(*v,1,EPSILON)) {
        return 22;
    }
    if (vzero /*&& !IsEqual(s,0,tiny)*/) {
        return 10;
    }
    if (uzero /*&& !IsEqual(t,0,tiny)*/) {
        return 12;
    }
    if (IsEqual(*u + *v,1.0,EPSILON) == true) {
        return 11;
    }
    return 1;
}
