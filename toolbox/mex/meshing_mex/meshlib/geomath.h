/*
    Filename:   geomath.h
    Language:   C++
    Date:       1998/05/25
    Authors:        Ziji Wu
              Hamid Ghadyani 2005-2007
    Version:    Version: 1.0
    Description:Declare math / geometric functions
*/

#ifndef __dlmathlib_h
#define __dlmathlib_h

#include "init.h"
#include "vector.h"

#ifndef sqrttwo
#define sqrttwo 1.4142135623730950488016887242097
#endif

#ifndef sqrtthree
#define sqrtthree 1.732050807568877
#endif

#ifndef PI
#define PI 3.14159265358979323846264338327950288419716939937510
#endif

#ifndef _SIGN
#define _SIGN(x) (fabs(x)/(x))
#endif

#define CROSS(dest,v1,v2) \
dest[0] = v1[1]*v2[2]-v1[2]*v2[1]; \
dest[1] = v1[2]*v2[0]-v1[0]*v2[2]; \
dest[2] = v1[0]*v2[1]-v1[1]*v2[0];
#define DOT(v1,v2) (v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2])
#define SUB(dest,v1,v2) \
dest[0] = v1[0]-v2[0]; \
dest[1] = v1[1]-v2[1]; \
dest[2] = v1[2]-v2[2];

#ifndef umaxof
#define umaxof(t) (((0x1ULL << ((sizeof(t) * 8ULL) - 1ULL)) - 1ULL) | \
                    (0xFULL << ((sizeof(t) * 8ULL) - 4ULL)))

#define smaxof(t) (((0x1ULL << ((sizeof(t) * 8ULL) - 1ULL)) - 1ULL) | \
                    (0x7ULL << ((sizeof(t) * 8ULL) - 4ULL)))
#endif
// NodeDead should be deleted, 
// NodeLive is in database and in one loop
// NodeActive is/will be in database but doesn't belong to any loop
enum NodeStatus {NodeDead=0, NodeLive=1, NodeActive=2}; 

// LoopDead should be deleted
// LoopLive is live and can be offset
// LoopActive is dead but it has some isolated/active nodes
enum LoopStatus {LoopDead=0, LoopLive=1, LoopActive=2};

// Status of line-crossing-line algorithm
struct LnLnIntersectionStatus {
    int intersection; // 0 : no intersection, 1: Intersection, 2: colinear
    // check crossStatus if intersection is not 0, it's meaningless otherwise.
    // 1 : intersection point is one of endpoints of first line passed to lnln() function
    // 2 : intersection point is one of endpoints of second line passed to lnln () function
    // 3 : two lines intersect at each other's end, i.e. they share one endpoint
    // 4 : intersection point is none of endpoints of either lines being examined for intersection but it exists!
//  int crossStatus; 
    double point[2]; // intersection point coordinates, if 'intersection' is 2 (colinear) it contains the midpoint of
                 // overlapped part of two elements
};

/*  calculates the cross product of two vectors of  
    dimension n (n<=3).  vec1 x vec2 = prod */
//void v_cros(double *, double *, int , double *);

/*  calculates the dot product of two vectors of dimension n */
double v_dot(double *, double *, int );

/*  determine if a point lies inside or outside of the given 2D boundary */
int ddcrsline(double , double , double , double , double , double, double tiny=TinyZero );

/*   Determines the intersection point of two straight lines where */
int lnln(double a1[3], double b1[3], double c1[3], double d1[3], double p[3], double tiny, bool twoDflag=false);

/* calculates the distance between two points */
double dist_pp(double *, double *);

// calculates the distance of a point and a straight line
double dist_lp3d(double *, double *, double *);

/* calculates the minimum distance between a point and a straight line*/
double dist_lp(double *, double *, double *, double *);

/* calculates the minimum distance between a point and a straight line segment*/
double dist_VL(double *, double *, double *, int *, double *);

/* Checks equlaity of two float numbers within tiny tolerance */
bool IsEqual(double const &a, double const &b, double const &tiny);

/* Checls if a point lies on a line */
int ptOnLine(double sx, double sy, double ex, double ey, double px, double py);

/* computes a line perpendicular to a line and through a point */
double *line_exp_perp_2d ( double *p1, double *p2, double *p3, int DIM_NUM );

/* Checks if point (x,y) resides inside the triangle defined by other 3 nodes */
int tri_inout(double x, double y, double xi, double yi, double xj, double yj, double xk, double yk);

/* Checks if infinite horizontal ray originating from (x1,y1) crosses other line segment */
int CCrossLine(double x1, double y1, double x3, double y3, double x4, double y4 );

/* Creates 3 triangles inside xx[],yy[] triangle, and returns their areas */
void cal_area_coor( double x, double y, double xx[], double yy[], double a_coor[] );

/* Finds the nearest point on a line to a point in 2D and returns it in pn[] */
int line_exp_point_near_2d ( double p1[2], double p2[2], double p[2], double (&pn)[2], double &dist, double &t, double tinyzero = TinyZero);

// Converts an explicit plane to implicit form in 3D.
void plane_exp2imp_3d ( double x1, double y1, double z1, double x2, double y2, 
  double z2, double x3, double y3, double z3, double &a, double &b, double &c, 
  double &d );

// Calculates volume of tetrahedron in 3D
double tetra_volume_3d ( double x1, double y1, double z1, double x2, 
  double y2, double z2, double x3, double y3, double z3, double x4, 
  double y4, double z4 );

// Calculates signed volume of a tetrahedon
double signed_tetrahedron_vol(double (*tetra)[3]);
double signed_tetrahedron_vol(double a[3], double b[3], double c[3],  double d[3]);

// Calculates determinant of a 4x4 matrix
double rmat4_det ( double a[4][4] );

// Calculates volume quality measure of a tetrahedron
double tetra_vol_quality(double (*tet)[3], double orig_vol=0.);

// Calculates mean volume quality measure of a tetrahedron
double tetra_quality3(double (*tet)[3], double orig_vol);

// Checks if a ray intersects a 3D triangular patch
int intersect_RayTriangle(double *rp1, double *rp2, double *tp1, double *tp2, double *tp3, double *I, double global_tiny = TinyZero);

// Check if point p resides inside tetrahedron defined by v1-v4 (uses determinant method)
int point_in_tetrahedron(double *v1, double *v2, double *v3, double *v4, double *p, double tiny = TinyZero);

// Check if point p resides inside triangle defined by v1-v3
int point_in_triangle(double *v1, double *v2, double *v3, double *p, double global_tiny = TinyZero);

// Check if point p lies on a line segment defined by s and e and if it's between those two points
int point_inside_segment(double *s, double *e, double *p, double tiny = TinyZero);

// function to check intersection of a ray and triangle if we already know that they are on the same plane
// it returns:
// 0        : no intersection
// 1        : intersection and ray is crossing over at least one of triangle's edges
// 20,21,22 : if intersection is on one of the triangle vertices
// 30,31,32 : if ray and one of the triangle edges are colinear (fully or partially)
// it also returns the intersection point in *p
int ray_triangle_coplanar(double rp1[3], double rp2[3], double tp1[3], double tp2[3], double tp3[3], std::vector< std::vector<double> > &ipnt, double global_tiny);

// Routine to check if two line segments in 3D intersect or not!
int segseg(double p1[3], double p2[3], double p3[3], double p4[3], double tiny, double *I, bool twoD=false);

// Routine to check if point is inside a polygon
int pnpoly(int nvert, double *vertx, double *verty, double testx, double testy);

// Routine to check intersection of a 'ray' and a triangle
int intersect_ray_triangle_moller(double orig[3], double dir[3],
                              double vert0[3], double vert1[3], double vert2[3],
                              double *t, double *u, double *v, double EPSILON=TinyZero);
#endif
