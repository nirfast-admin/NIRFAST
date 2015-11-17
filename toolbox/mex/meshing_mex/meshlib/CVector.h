//==================================================================
// Copyright 2002, softSurfer (www.softsurfer.com)
// This code may be freely used and modified for any purpose
// providing that this copyright notice is included with it.
// SoftSurfer makes no warranty for this code, and cannot be held
// liable for any real or imagined damage resulting from it's use.
// Users of this code must verify correctness for their application.
//==================================================================

#ifndef SS_Vector_H
#define SS_Vector_H

#include "common.h"
#include "CPoint.h"
//==================================================================
//  Vector Class Definition
//==================================================================

class Vector : public Point {
public:
	// Constructors same as Point class
	Vector() : Point() {};
	Vector( int a) : Point(a) {};
	Vector( double a) : Point(a) {};
	Vector( int a, int b) : Point(a,b) {};
	Vector( double a, double b) : Point(a,b) {};
	Vector( int a, int b, int c) : Point(a,b,c) {};
	Vector( double a, double b, double c) : Point(a,b,c) {};
	Vector( int n, int a[]) : Point(n,a) {};
	Vector( int n, double a[]) : Point(n,a) {};
	~Vector() {};

	//----------------------------------------------------------
	// IO streams and Comparisons: inherit from Point class

	//----------------------------------------------------------
	// Vector Unary Operations
	Vector operator-();                // unary minus
	Vector operator~();                // unary 2D perp operator

	//----------------------------------------------------------
	// Scalar Multiplication
	friend Vector operator*( int&, Vector&);
	friend Vector operator*( double&, Vector&);
	friend Vector operator*( Vector&, int&);
	friend Vector operator*( Vector&, double&);
	// Scalar Division
	friend Vector operator/( Vector&, int&);
	friend Vector operator/( Vector&, double&);

	//----------------------------------------------------------
	// Vector Arithmetic Operations
	Vector operator+( Vector&);        // vector add
	Vector operator-( Vector&);        // vector subtract
	double operator*( Vector&);        // inner dot product
	double operator*( Point&);
	double operator|( Vector&);        // 2D exterior perp product
	Vector operator^( Vector&);        // 3D exterior cross product

	Vector& operator*=( double&);      // vector scalar mult
	Vector& operator/=( double&);      // vector scalar div
	Vector& operator+=( Vector&);      // vector increment
	Vector& operator-=( Vector&);      // vector decrement
	Vector& operator^=( Vector&);      // 3D exterior cross product

	//----------------------------------------------------------
	// Vector Properties
	double len() {                    // vector length
		return sqrt(x*x + y*y + z*z);
	}
	double len2() {                   // vector length squared (faster)
		return (x*x + y*y + z*z);
	}

	//----------------------------------------------------------
	// Special Operations
	void normalize();                 // convert vector to unit length
	friend Vector sum( int, int[], Vector[]);     // vector sum
	friend Vector sum( int, double[], Vector[]);  // vector sum
};
#endif 

