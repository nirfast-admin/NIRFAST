#ifndef __MeshIO_h
#define __MeshIO_h

#include <string>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <vector>

#include "CPoint.h"
#include "CVector.h"
#include "FileOperation.h"

class MeshIO
{
public:
	MeshIO();
	MeshIO(std::string& nodefn, std::string& elefn);
	~MeshIO();

	int ReadPolyhedron(std::vector<Point *> &nodes, std::vector<unsigned long>& ele); // reads node coordinates and element connectivity
private:
	std::string nfn;
	std::string efn;
};



#endif
