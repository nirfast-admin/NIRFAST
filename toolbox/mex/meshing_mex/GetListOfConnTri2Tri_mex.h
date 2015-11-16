/*
 *  sfchk_mex.h
 *  
 *
 *  Created by Hamid Ghadyani on 1/7/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef getlist_conntritri_mex
#define getlist_conntritri_mex

#include <iostream>
#include "mex.h"
#include <queue>
#include <set>
#include "vector.h"
#include "geomath.h"

#define ulong unsigned long int

// unsigned long int *ele;
double *ele;
const double *p;
//const mxArray *list;
const int edge[3][2]={{0,1},{1,2},{2,0}};


ulong nele, np;

enum {White=0, Gray, Black=-1};

void PopulateGraph(std::vector< std::set<ulong> > &, std::vector< std::set<ulong> > &);
std::set<ulong> FindNeighboringTriangles(ulong tri, std::vector< std::set<ulong> > &vertex_tri_hash );
bool ShareEdge(ulong u, ulong v);
void SetCell(mxArray* cell_pointer, std::set<ulong> conn_elems, ulong i);

#endif

