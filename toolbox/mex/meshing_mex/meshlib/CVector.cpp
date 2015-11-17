//==================================================================
// Copyright 2002, softSurfer (www.softsurfer.com)
// This code may be freely used and modified for any purpose
// providing that this copyright notice is included with it.
// SoftSurfer makes no warranty for this code, and cannot be held
// liable for any real or imagined damage resulting from it's use.
// Users of this code must verify correctness for their application.
//==================================================================

#include "CPoint.h"
#include "CVector.h"

//==================================================================
// Vector Class Methods
//==================================================================

//------------------------------------------------------------------
//  Unary Ops
//------------------------------------------------------------------

// Unary minus
Vector Vector::operator-() {
	Vector v;
	v.x = -x; v.y = -y; v.z = -z;
	v.dimn = dimn;
	return v;
}

// Unary 2D perp operator
Vector Vector::operator~() {
	if (dimn != 2) err = Edim;   // and continue anyway
	Vector v;
	v.x = -y; v.y = x; v.z = z;
	v.dimn = dimn;
	return v;
}

//------------------------------------------------------------------
//  Scalar Ops
//------------------------------------------------------------------

// Scalar multiplication
Vector operator*( int &c, Vector& w ) {
	Vector v;
	v.x = c * w.x;
	v.y = c * w.y;
	v.z = c * w.z;
	v.dimn = w.dim();
	return v;
}

Vector operator*( double& c, Vector& w ) {
	Vector v;
	v.x = c * w.x;
	v.y = c * w.y;
	v.z = c * w.z;
	v.dimn = w.dim();
	return v;
}

Vector operator*( Vector& w, int& c ) {
	Vector v;
	v.x = c * w.x;
	v.y = c * w.y;
	v.z = c * w.z;
	v.dimn = w.dim();
	return v;
}

Vector operator*( Vector& w, double& c ) {
	Vector v;
	v.x = c * w.x;
	v.y = c * w.y;
	v.z = c * w.z;
	v.dimn = w.dim();
	return v;
}

// Scalar division
Vector operator/( Vector& w, int& c ) {
	Vector v;
	v.x = w.x / c;
	v.y = w.y / c;
	v.z = w.z / c;
	v.dimn = w.dim();
	return v;
}

Vector operator/( Vector& w, double& c ) {
	Vector v;
	v.x = w.x / c;
	v.y = w.y / c;
	v.z = w.z / c;
	v.dimn = w.dim();
	return v;
}

//------------------------------------------------------------------
//  Arithmetic Ops
//------------------------------------------------------------------

Vector Vector::operator+( Vector& w ) {
	Vector v;
	v.x = x + w.x;
	v.y = y + w.y;
	v.z = z + w.z;
	v.dimn = std::max( dimn, w.dim());
	return v;
}

Vector Vector::operator-( Vector& w ) {
	Vector v;
	v.x = x - w.x;
	v.y = y - w.y;
	v.z = z - w.z;
	v.dimn = std::max( dimn, w.dim());
	return v;
}

//------------------------------------------------------------------
//  Products
//------------------------------------------------------------------

// Inner Dot Product
double Vector::operator*( Vector& w ) {
	return (x * w.x + y * w.y + z * w.z);
}

double Vector::operator *(Point& w) {
	return (x * w.x + y * w.y + z * w.z);
}

// 2D Exterior Perp Product
double Vector::operator|( Vector& w ) {
	if (dimn != 2) err = Edim;    // and continue anyway
	return (x * w.y - y * w.x);
}

// 3D Exterior Cross Product
Vector Vector::operator^( Vector& w ) {
	Vector v;
	v.x = y * w.z - z * w.y;
	v.y = z * w.x - x * w.z;
	v.z = x * w.y - y * w.x;
	v.dimn = 3;
	return v;
}

//------------------------------------------------------------------
//  Shorthand Ops
//------------------------------------------------------------------

Vector& Vector::operator*=( double& c ) {        // vector scalar mult
	x *= c;
	y *= c;
	z *= c;
	return *this;
}

Vector& Vector::operator/=( double& c ) {        // vector scalar div
	x /= c;
	y /= c;
	z /= c;
	return *this;
}

Vector& Vector::operator+=( Vector& w ) {        // vector increment
	x += w.x;
	y += w.y;
	z += w.z;
	dimn = std::max(dimn, w.dim());
	return *this;
}

Vector& Vector::operator-=( Vector& w ) {        // vector decrement
	x -= w.x;
	y -= w.y;
	z -= w.z;
	dimn = std::max(dimn, w.dim());
	return *this;
}

Vector& Vector::operator^=( Vector& w ) {        // 3D exterior cross product
	double ox=x, oy=y, oz=z;
	x = oy * w.z - oz * w.y;
	y = oz * w.x - ox * w.z;
	z = ox * w.y - oy * w.x;
	dimn = 3;
	return *this;
}

//------------------------------------------------------------------
//  Special Operations
//------------------------------------------------------------------

void Vector::normalize() {                      // convert to unit length
	double ln = sqrt( x*x + y*y + z*z );
	if (ln == 0.) return;                    // do nothing for nothing
	x /= ln;
	y /= ln;
	z /= ln;
}

Vector sum( int n, int c[], Vector w[] ) {     // vector sum
	int     maxd = 0;
	Vector  v;

	for (int i=0; i<n; i++) {
		if (w[i].dim() > maxd)
			maxd = w[i].dim();
	}
	v.dimn = maxd;

	for (int i=0; i<n; i++) {
		v.x += c[i] * w[i].x;
		v.y += c[i] * w[i].y;
		v.z += c[i] * w[i].z;
	}
	return v;
}

Vector sum( int n, double c[], Vector w[] ) {  // vector sum
	int     maxd = 0;
	Vector  v;

	for (int i=0; i<n; i++) {
		if (w[i].dim() > maxd)
			maxd = w[i].dim();
	}
	v.dimn = maxd;

	for (int i=0; i<n; i++) {
		v.x += c[i] * w[i].x;
		v.y += c[i] * w[i].y;
		v.z += c[i] * w[i].z;
	}
	return v;
}
