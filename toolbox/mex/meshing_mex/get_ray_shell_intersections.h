#ifndef __get_ray_shell_intersections_h
#define __get_ray_shell_intersections_h

#include "isinvolume_randRay.h"

bool CheckArgsIn(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);
void GetFacetsBBX(double *facets_bbx, int nrhs, const mxArray *prhs[]);
void SetCell_intpnts(mxArray* cell_pointer, std::vector<points> int_points, ULONG i);
void SetCell_facets(mxArray* cell_pointer, std::vector<ULONG> facets, ULONG i);


//[all_ok st intpnts intersected_facets]=get_ray_shell_intersections(rp1,p,t,tiny,facets_bbx,xmin,xmax,ntries)

#define inrp1     prhs[0]
#define innode    prhs[1]
#define inele     prhs[2]
#define intiny    prhs[3]
#define infacets  prhs[4]
#define inxmin    prhs[5]
#define inxmax    prhs[6]
#define inntries  prhs[7]

#define outallok     plhs[0]
#define outst        plhs[1]
#define outintpnts   plhs[2]
#define outintfacets plhs[3]
double *p;
double *t;
ULONG ne, np;
#endif