#ifndef __surface_relations_mex_h
#define __surface_relations_mex_h

#include "polyhedron2BSP.h"
#include "FileOperation.h"
#include "isinvolume_randRay.h"
#include <iostream>
#include <fstream>
#include <time.h>

#include "mex.h"

std::vector< std::vector<int> > core(std::vector<std::string>&surface_fnames);
std::vector< std::vector<int> > core2(char* fn_prefix, int no_regions);
void GetBBX(mxArray *pmx, mxArray *elemx, std::vector<double>& extremes, double *&facets_bbx);

#endif