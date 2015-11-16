/*
 *  CPolygon.cpp
 *  polyhedron2BSP
 *
 *  Created by Hamid_R_Ghadyani on 6/4/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "CPolygon.h"

Polygon::Polygon() {
	this->ndim = 0;
	this->_nv = 0;
}

Polygon::Polygon(std::vector<Point *> P) {
	this->_nv = P.size();
	if (_nv!=0) {
		this->ndim = (*(P[0])).dim();
		for (unsigned short i=0; i<_nv; ++i) {
			this->_verts.push_back(P[i]);
		}
		this->myplane = new Plane3D(_verts[0],_verts[1],_verts[2]);
	}
}
Polygon::Polygon(Point& A, Point& B, Point& C) {
	this->_nv = 3;
	this->ndim = A.dim();
	_verts.push_back(new Point(A));
	_verts.push_back(new Point(B));
	_verts.push_back(new Point(C));
	this->myplane = new Plane3D(A,B,C);
}

Polygon::Polygon(Point *A, Point *B, Point *C) {
	this->_nv = 3;
	this->ndim = A->dim();
	_verts.push_back(A);
	_verts.push_back(B);
	_verts.push_back(C);
	this->myplane = new Plane3D(_verts[0],_verts[1],_verts[2]);
}

Polygon::Polygon(Point *V[], unsigned short n) {
	this->_nv = n;
	if (n!=0) {
		this->ndim = (*V[0]).dim();
		for (unsigned short i=0; i<n; ++i) {
			this->_verts.push_back(V[i]);
		}
		this->myplane = new Plane3D(_verts[0],_verts[1],_verts[2]);
	}
}

int Polygon::ClassifyPolygonToPlane(Plane3D& plane, bool predicate_flag)
{
    // Loop over all polygon vertices and count how many vertices
    // lie in front of and how many lie behind of the thickened plane
    unsigned long numInFront = 0, numBehind = 0;
    for (unsigned long i = 0; i < this->_nv; i++) {
        // Point *p = _verts[i];
		switch (plane.ClassifyPointToPlane(*_verts[i], predicate_flag)) {
        //switch (ClassifyPointToPlane(p, plane)) {
			case Plane3D::POINT_IN_FRONT_OF_PLANE:
				numInFront++;
				break;
			case Plane3D::POINT_BEHIND_PLANE:
				numBehind++;
				break;
        }
    }
	/*if (numInFront+numBehind != 3 && !(numInFront==0 && numBehind==0))
		return POLYGON_STRADDLING_PLANE;*/
    // If vertices on both sides of the plane, the polygon is straddling
    if (numBehind != 0 && numInFront != 0)
        return POLYGON_STRADDLING_PLANE;
    // If one or more vertices in front of the plane and no vertices behind
    // the plane, the polygon lies in front of the plane
    if (numInFront != 0)
        return POLYGON_IN_FRONT_OF_PLANE;
    // Ditto, the polygon lies behind the plane if no vertices in front of
    // the plane, and one or more vertices behind the plane
    if (numBehind != 0)
        return POLYGON_BEHIND_PLANE;
    // All vertices lie on the plane so the polygon is coplanar with the plane
    return POLYGON_COPLANAR_WITH_PLANE;
}

int Polygon::ClassifyPolygonToPlane(Plane3D* plane, bool predicate_flag)
{
    // Loop over all polygon vertices and count how many vertices
    // lie in front of and how many lie behind of the thickened plane
    unsigned long numInFront = 0, numBehind = 0;
    for (unsigned long i = 0; i < this->_nv; i++) {
        // Point *p = _verts[i];
		switch (plane->ClassifyPointToPlane(*_verts[i], predicate_flag)) {
        //switch (ClassifyPointToPlane(p, plane)) {
			case Plane3D::POINT_IN_FRONT_OF_PLANE:
				numInFront++;
				break;
			case Plane3D::POINT_BEHIND_PLANE:
				numBehind++;
				break;
        }
    }
	/*if (numInFront+numBehind != 3 && !(numInFront==0 && numBehind==0))
		return POLYGON_STRADDLING_PLANE;*/
    // If vertices on both sides of the plane, the polygon is straddling
    if (numBehind != 0 && numInFront != 0)
        return POLYGON_STRADDLING_PLANE;
    // If one or more vertices in front of the plane and no vertices behind
    // the plane, the polygon lies in front of the plane
    if (numInFront != 0)
        return POLYGON_IN_FRONT_OF_PLANE;
    // Ditto, the polygon lies behind the plane if no vertices in front of
    // the plane, and one or more vertices behind the plane
    if (numBehind != 0)
        return POLYGON_BEHIND_PLANE;
    // All vertices lie on the plane so the polygon is coplanar with the plane
    return POLYGON_COPLANAR_WITH_PLANE;
}

Polygon::~Polygon() {
	this->_verts.clear();
	delete myplane;
}
