/*
 *  CPolygon.h
 *  polyhedron2BSP
 *
 *  Created by Hamid_R_Ghadyani on 6/4/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef __CPolygon_header
#define __CPolygon_header

#include <vector>
#include "CPoint.h"
#include "Plane3D.h"

class Polygon {
public:
	Polygon();
	Polygon(std::vector<Point *> points);
	Polygon(Point& A, Point& B, Point& C);
	Polygon(Point *A, Point *B, Point *C);
	Polygon(Point *V[], unsigned short n);
	~Polygon();

	enum PlanePolygonRelation {POLYGON_COPLANAR_WITH_PLANE, POLYGON_IN_FRONT_OF_PLANE, POLYGON_BEHIND_PLANE, POLYGON_STRADDLING_PLANE};
	
	unsigned short GetNV() { return this->_verts.size(); }
	bool empty() { return this->_verts.empty(); }
	Point* GetVertexPtr(unsigned short id) { return _verts[id]; }
	Point GetVertex(unsigned short id) { return *_verts[id]; }
	Plane3D* GetPlane() const { return this->myplane; }
	int ClassifyPolygonToPlane(Plane3D& plane, bool predicate_flag);
	int ClassifyPolygonToPlane(Plane3D* plane, bool predicate_flag);

	unsigned long id;
private:
	std::vector<Point *> _verts;
	unsigned short ndim;
	unsigned short _nv;
	Plane3D* myplane;
};

#endif
