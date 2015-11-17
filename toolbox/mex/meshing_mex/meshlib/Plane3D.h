#include "CVector.h"

#ifndef __Plane3D_h
#define __Plane3D_h

#ifndef PLANE_THICKNESS_EPSILON
#define PLANE_THICKNESS_EPSILON 1E-8
#endif

#ifndef REAL
#define REAL double
#endif

extern REAL orient3d(REAL *pa, REAL *pb, REAL *pc, REAL *pd);
extern REAL orient3dexact(REAL *pa, REAL *pb, REAL *pc, REAL *pd);
extern double signed_tetrahedron_vol(double (*tetra)[3]);
extern double signed_tetrahedron_vol(double a[3], double b[3], double c[3],  double d[3]);
class Plane3D :	public Vector
{
public:
	Plane3D();
	Plane3D(Point& A, Point& B, Point& C);
	Plane3D(Point* A, Point* B, Point* C);
	Plane3D(Vector& n, double& d): n(n), _d(d) {};
	Plane3D(Vector& n, Point& A);
	Plane3D(const Plane3D& other);
	~Plane3D(void);

	enum PointPlaneRelation {POINT_IN_FRONT_OF_PLANE, POINT_BEHIND_PLANE, POINT_ON_PLANE};

	Plane3D& operator=(const Plane3D& other);

	int ClassifyPointToPlane(Point& P, bool flag=true);
	void SetThreePoints(Point *points[3]);
	Point *GetThreePoints(int id) const { return this->_points[id]; }
	void SetThickness(double thk) { this->plane_thk_epsilon = thk; }
	// n = (a,b,c)
	// Plane's normal and offset: a.x + b.y + c.z + d = 0
	Vector n;
	double _d;

	static double plane_thk_epsilon;
	unsigned long id;
private:
	void CopyFrom(const Plane3D& other);
	Point *_points[3];
	bool _has3points, _release_verts;
};

#endif
