/*
 *  sfchk_mex.h
 *  
 *
 *  Created by Hamid Ghadyani on 1/7/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef orient_surface_h
#define orient_surface_h

#include <iostream>
#include "mex.h"
#include <queue>
#include <limits>
#include <set>
#include "vector.h"
#include "geomath.h"
#include "isinvolume_randRay.h"

#ifndef ulong
#define ulong unsigned long
#endif

double tiny = 1e-11;
double tiny_offset = 1e-5;

double *ele;
const double *p;
const mxArray *list;
const int edge[3][2]={{0,1},{1,2},{2,0}};


ulong ne, np;


bool ExtremeFlag=false, BBXFlag=false;
int numPerturb = 50;
double *facets_bbx;
double xMax, xMin;
enum {White=0, Gray, Black=-1};

void CheckOrientation(ulong v, ulong u);
unsigned int CalculateOrientation(ulong v, const mxArray *mxT, const mxArray *mxP);
ulong FindSeedsDirection(ulong elemid, const mxArray *prhs[], int &myst);
int ReOrient(const mxArray *mxT, const mxArray *mxP);
#endif
