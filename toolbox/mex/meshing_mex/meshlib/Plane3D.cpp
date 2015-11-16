#include "Plane3D.h"

double Plane3D::plane_thk_epsilon = PLANE_THICKNESS_EPSILON;

Plane3D::Plane3D() : n(0.,0.,0.), _d(0.), _has3points(false), _release_verts(false), id(0) {

}
Plane3D::Plane3D(Point& A, Point& B, Point& C)
{
	Vector v1 = B-A, v2 = C-A;
	n = v1 ^ v2; // Cross product
	//n.normalize();
	_d = -n*A; // Dot product
	_points[0] = new Point(A);
	_points[1] = new Point(B);
	_points[2] = new Point(C);
	_has3points = true;
	_release_verts = true;
}

Plane3D::Plane3D(Point* A, Point* B, Point* C) : _release_verts(false), _has3points(true) {
	Vector v1 = *B - *A, v2 = *C - *A;
	n = v1 ^ v2; // Cross product
	//n.normalize();
	_d = -n * *A; // Dot product
	_points[0] = A;
	_points[1] = B;
	_points[2] = C;

}
Plane3D::Plane3D(const Plane3D& other) {
	this->CopyFrom(other);
}

void Plane3D::CopyFrom(const Plane3D& other) {
	n = other.n;
	_d = other._d;
	id = other.id;
	if (other._has3points == true) {
		if (other._release_verts == true)
			for (int i=0; i<3; _points[i] = new Point(other._points[i]), ++i);
		else
			for (int i=0; i<3; _points[i] = other.GetThreePoints(i), ++i);
	}

	_has3points = other._has3points;
	_release_verts = other._release_verts;
}
Plane3D::Plane3D(Vector& n, Point& A) : _has3points(false) , _release_verts(false)  {
	this->n = n;
	//this->n.normalize();
	this->_d = -this->n*A;
}
Plane3D& Plane3D::operator =(const Plane3D& other) {
	if (this!=&other) {
		this->CopyFrom(other);
	}
	return *this;
}

int Plane3D::ClassifyPointToPlane(Point& p, bool flag) {
	if (flag) {
		double a[3],b[3],c[3],d[3];
		a[0] = _points[0]->x; a[1] = _points[0]->y; a[2] = _points[0]->z;
		b[0] = _points[1]->x; b[1] = _points[1]->y; b[2] = _points[1]->z;
		c[0] = _points[2]->x; c[1] = _points[2]->y; c[2] = _points[2]->z;
		d[0] = p.x; d[1] = p.y; d[2] = p.z;
        
		double ret = orient3d(a,b,c,d);
        //double ret = signed_tetrahedron_vol(a,b,c,d);
		
		if (ret == 0.0)
			return POINT_ON_PLANE;
		if (ret < 0.0)
			return POINT_IN_FRONT_OF_PLANE;
		else 
			return POINT_BEHIND_PLANE;
		
		/*if (ret < -plane_thk_epsilon)
			return POINT_IN_FRONT_OF_PLANE;
		else if (ret > plane_thk_epsilon)
			return POINT_BEHIND_PLANE;
		else
			return POINT_ON_PLANE;*/
	}
	else {
	// Compute signed distance of point from plane
		double dist = n*p + _d;
		// Classify p based on the signed distance
		if (dist > plane_thk_epsilon)
			return POINT_IN_FRONT_OF_PLANE;
		else if (dist < -plane_thk_epsilon)
			return POINT_BEHIND_PLANE;
		else
			return POINT_ON_PLANE;
	}
}
void Plane3D::SetThreePoints(Point *points[]) {
	for (int i=0; i<3; this->_points[i] = new Point(points[i]), ++i);
	_has3points = true;
}
Plane3D::~Plane3D(void)
{
	if (this->_has3points && _release_verts) {
		for (int i=0; i<3; ++i) {
			delete this->_points[i];
		}
	}
}
