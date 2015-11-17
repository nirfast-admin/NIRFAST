/*
 *  orient_surface_mex.cpp
 *  
 *
 *  Created by Hamid Ghadyani on 1/7/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
/*
 * Will attemp to re-orient all triangular facets in ele such that their normal points outward.
 * In case one of the edges of the input mesh is shared by more than two triangles it will call a point
 * inclusion routine which determine if a point in a very close vicinity of the given triangle
 * is inside our outside the whole mesh and based on that test it will decided the orientation of that
 * triangle. Otherwise, i.e. no edges is shared by more than two triangles, it will sweep through
 * all triangles and re-orient them based on the original seed triangle. Orientation of the seed triangle
 * is determined by finding the left most triangle and comparing its normal to unit vector of X axis.
 * If this routine fails to determine the orientation of a triangle it will return 1, otherwise 0.
 */

#include "orient_surface_mex.h"

#define p(i,j) p[(i)+np*(j)]
#define ele(i,j) ele[(i)+ne*(j)]
#define list(i,j) list[(i)+ne*(j)];
#define facets_bbx(i,j) facets_bbx[(i)+(j)*ne]
/* To compile this file use:
* For Windows:
* mex -v -DWIN32 -I./meshlib orient_surface_mex.cpp meshlib/vector.cpp meshlib/geomath.cpp isinvolume_randRay.cpp
For Linux/Mac:
 * mex -v        -I./meshlib orient_surface_mex.cpp meshlib/vector.cpp meshlib/geomath.cpp isinvolume_randRay.cpp
 */


// [status,tc]=orient_surface_mex(ele,p,list)
// list(i): list of 3 connected triangles to triangle i
// tc is the list of oriented triangles 
// ele is the input list of triangles
// status:
// 0 = OK
// 1 = Random point on either side of one of triangles returns the same interior/exterior status
// 2 = None of triangles could be used as an orientation seed
// 3 = Some of the facets on the surface could not be examined
// 255 = Not enough number of perturbation to determine interior/exterior of a random point

// NOTE: THIS SHOULD ONLY BE USED ON CLOSED SURFACES, MANIFOLD OR NON-MANIFOLD

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	ExtremeFlag=false; BBXFlag=false;
    if (nrhs!=3 || nlhs!=2)
        mexErrMsgTxt("orient_surface: Needs 3 input and 2 output arguments!");
    if (!mxIsDouble(prhs[1]))
        mexErrMsgTxt("orient_surface: input argument 2 should be of 'double' type");
    np = mxGetM(prhs[1]);
    int dim = mxGetN(prhs[1]);
	ne = mxGetM(prhs[0]);
	std::vector< std::set<ulong> > Graph(ne);
	p=mxGetPr(prhs[1]);
    if (dim!=3)
        mexErrMsgTxt("orient_surface: input points should be either 3D");
    
	// returned status
	int st=0;
	
	
    if (mxIsDouble(prhs[0]))
        ele = (double *) mxGetData(prhs[0]);
    else
        mexErrMsgTxt("orient_surface: t needs to be 'double'!");

	// Check 'list' argument
	if (!mxIsCell(prhs[2]))
		mexErrMsgTxt("orient_surface: 'list' needs to be cell!");
	else
		list = prhs[2];

	// mxArray *cell_pointer; // Returned variable which holds connectivity list of triangles.

	ulong elemid;
 
 
	bool endflag = false;
	elemid = 1;
	std::queue<ulong> q;
	std::vector<short> color(ne, White);
	bool firstTimeFlag = true;
	while (!endflag) {
		int myst=0;
		if (color[elemid-1]!=White) { // we have tried this element before to no success
			break;
		}
		assert(q.empty());
		q.push(elemid);
		color[elemid-1] = Gray;
		
		mxArray *tmpArray;
		double *tris;
		
		while (!q.empty()) {
			ulong u = q.front();
			ulong v, index;
			// Get the list of connected triangles to element number 'u' from 'list' ('list' is a cell)
			index = u-1 + 0*ne;
			tmpArray = mxGetCell(list,index);
			int nconn_tris = mxGetNumberOfElements(tmpArray);
			if (nconn_tris>3 && firstTimeFlag) {
				mexPrintf("\tFound a triangle with more than 3 neighbors!\n");
				firstTimeFlag = false;
			}
			if (nconn_tris==0) {
				mexPrintf("\tList of neighboring triangles to face number %d is empty!\n",u);
				mexErrMsgTxt("\tAborting...");
			}

			if (!mxIsDouble(tmpArray))
				mexErrMsgTxt("entries of 'list' should be 'double' type!");
			tris = (double *) mxGetData(tmpArray);
			for (int i=0; i<nconn_tris; ++i) {
				v = (ulong) tris[i];
				if (color[v-1] == White) {
					if (nconn_tris<=3)
						CheckOrientation(v,u);
					else {
						myst = CalculateOrientation(v,prhs[0],prhs[1]);
						if (myst>1) {
							st = 3;
							goto EXIT;
						//	continue;
						}
					}
					color[v-1] = Gray;
					q.push(v);
				}
			}
			q.pop();
			color[u-1] = Black;
		}
		// Check to see if all the elements are tagged as visited
		endflag = true;
		for (ulong i=0; i<ne; ++i) {
			if (color[i] != Black) {// Found another un-visited element
				elemid = i+1;
				endflag = false;
				break;
			}
		}
	}
	/* Check if we have visited all triangles */
	for (ulong i=0; i<ne; ++i) {
		if (color[i]!=Black) {
			mexPrintf("Couldn't visit all triangles. Please send your input files to ccni-support@wpi.edu\n");
			delete [] facets_bbx;
			mexErrMsgTxt("Aborting...");
		}
	}
	if (!endflag) { // the loop didn't end naturally
		st=3;
		goto EXIT;
	}
	 if (ReOrient(prhs[0],prhs[1])!=0) {
		 st=4;
		 goto EXIT;
	 }

	

EXIT:
	plhs[0] = mxCreateDoubleScalar((double) st);
	
	// Populate the return value of 'tc'
	if (st==0) {
		plhs[1] = mxCreateNumericMatrix(ne, 3, mxDOUBLE_CLASS, mxREAL);
		double *tmp = (double *) mxGetData(plhs[1]);
		for (ulong i=0; i<ne; ++i) {
			for (int j=0; j<3; ++j) {
				tmp[i+ne*j] = ele(i,j);
			}
		}
	}
	else {
		plhs[1] = mxCreateDoubleScalar(0);
	}
	delete [] facets_bbx;
}

ulong FindSeedsDirection(ulong elemid, const mxArray *prhs[], int &myst) {
	int foo;
	std::queue<ulong> q;
	foo = CalculateOrientation(elemid,prhs[0],prhs[1]);
    bool firstTimeFlag = true;
	if (foo!=0) { // Get a neighbor triangle
		std::vector<short> color(ne, White);
		q.push(elemid);
		color[elemid-1] = Gray;
		bool myflag=false;
		mxArray *tmpArray;
		double *tris;
        firstTimeFlag = false;
		while (!q.empty()) {
			ulong u = q.front();
			ulong v, index;
			// Get the list of connected triangles to element number 'u' from 'list' ('list' is a cell)
			index = u-1 + 0*ne;
			tmpArray = mxGetCell(list,index);
			int nconn_tris = mxGetNumberOfElements(tmpArray);
			if (nconn_tris>3 && firstTimeFlag ) {
				mexPrintf("\tFound a triangle with more than 3 neighbors!\n");
                firstTimeFlag = false;
			}
			if (!mxIsDouble(tmpArray))
				mexErrMsgTxt("orient_surface_mex: entries of 'list' should be 'double' type!");
			tris = (double *) mxGetData(tmpArray);
			for (int i=0; i<nconn_tris; ++i) {
				v = (ulong) tris[i];
				if (color[v-1] == White) {
					foo = CalculateOrientation(v,prhs[0],prhs[1]);
					if (foo==0) {
						elemid = v;
						myflag = true;
						break;
					}
					color[v-1] = Gray;
					q.push(v);
				}
			}
			if (myflag) break;
			q.pop();
			color[u-1] = Black;
		}
	}
	if (foo==0) { 
		myst=0;
		return elemid;
	}
	else { // we have examined all triangles of the current surface shell and none of them could be used for orientation decision
		assert(q.empty());
		myst=foo;
		return elemid;
	}
}



// Will ensure that the orientation of triangle v is the same as triangle u
// List of triangles is stored in the global variable ele
void CheckOrientation(ulong v, ulong u) {
	bool flag = false;
	ulong NV[3]={(ulong)(ele(v-1,0)), (ulong)(ele(v-1,1)), (ulong)(ele(v-1,2))};
	ulong NU[3]={(ulong)(ele(u-1,0)), (ulong)(ele(u-1,1)), (ulong)(ele(u-1,2))};
	ulong eu1, eu2, ev1, ev2;

	for (int i=0; i<3; ++i) {
		eu1 = NU[edge[i][0]]; eu2 = NU[edge[i][1]];
		for (int j=0; j<3; ++j) {
			ev1 = NV[edge[j][0]]; ev2 = NV[edge[j][1]];
			if (eu1==ev1 && eu2==ev2) { // vertices in triangle 'v' should be reoriented
				double tmp = ele(v-1,0);
				ele(v-1,0) = ele(v-1,1);
				ele(v-1,1) = tmp;
				return;
			}
			else if (eu1==ev2 && eu2==ev1)
				flag = true;
		}
	}
	assert(flag); // This is just to check that triangles 'u' and 'v' are definitely sharing an edge
}

// Randomly, chooses one side of triangle 'v' and creates a point very close to it and determines
// if that point is within the boundary or not. Then calculates the normal of triangle and
// checks if the point created is on the same side of the normal and accordingly decides if
// the orientation of the triangle is correct.
// This routine will return following codes:
// 0 : everything is OK and triangle v's orientation was not changed
// 1 : everything is OK and triangle v's orientation was     changed
// 2 : couldn't orient v because random points created on both sides of v have the same inclusion test results. (i.e. v is very close to another triangle)
// 255 : could not decide if the random point created was inside or outside of the boundary
unsigned int CalculateOrientation(ulong v, const mxArray *mxT, const mxArray *mxP) {
	unsigned int st=0;
	
	if (!ExtremeFlag) {
		xMax = -std::numeric_limits<double>::max();
		xMin =  std::numeric_limits<double>::max();
		for (ulong i=0; i<np; ++i) {
			if (p(i,0)>xMax)
				xMax = p(i,0);
			if (p(i,0)<xMin)
				xMin = p(i,0);
		}
		ExtremeFlag = true;
	}
	if (!BBXFlag) {
		facets_bbx = new double[ne*6];
		for (ulong i=0; i<ne; ++i) {
			ulong n1=(ulong)(ele(i,0));
            ulong n2=(ulong)(ele(i,1));
            ulong n3=(ulong)(ele(i,2));
            double tmp;
            for (ulong j=0; j<3; ++j) {
				tmp = std::min(p(n1-1,j),p(n2-1,j));
				//facets_bbx[i][j] = std::min(tmp,p(n3-1,j));
				facets_bbx(i,j) = std::min(tmp,p(n3-1,j));
				tmp = std::max(p(n1-1,j),p(n2-1,j));
				//facets_bbx[i][j+3] = std::max(tmp,p(n3-1,j));
				facets_bbx(i,j+3) = std::max(tmp,p(n3-1,j));
			}
		}
		BBXFlag = true;
	}
	// Assume an orientation for v and create a node very close to v
	double p1[3],p2[3],p3[3], v1[3], v2[3], vec[3];
	for (int j=0; j<3; ++j) {
		p1[j] = p( (ulong)(ele(v-1,0))-1, j);
		p2[j] = p( (ulong)(ele(v-1,1))-1, j);
		p3[j] = p( (ulong)(ele(v-1,2))-1, j);
	}
	SUB(v1,p2,p1);
	SUB(v2,p3,p1);
	CROSS(vec,v1,v2);
	v_norm(vec,3);
	double p0[3]={0.,0.,0.};

	// Find the centroid of triangle
	double cent[3]={0.,0.,0.};
	for (int i=0; i<3; ++i) {
		cent[i] += p1[i]+p2[i]+p3[i] ;
	}
	for (int i=0; i<3; cent[i] /= 3., ++i);

	std::vector<ULONG> int_facets;
    std::vector<points> int_points;
	for (int i=0; i<3; p0[i] = cent[i] + tiny_offset*vec[i], ++i);
	unsigned int st1 = isinvolume_randRay(p0,mxP,mxT,tiny,facets_bbx,200,xMin,xMax,int_facets,int_points);

	for (int i=0; i<3; p0[i] = cent[i] - tiny_offset*vec[i], ++i);
	unsigned int st2 = isinvolume_randRay(p0,mxP,mxT,tiny,facets_bbx,200,xMin,xMax,int_facets,int_points);
	
	if (st1==st2 && st1!=255)
		st = 2;
	else if (st1==255 || st2==255) // couldn't determine the location of point, ran out of numPertub!
		st = 255;
	else if (st1==1) { // need to change the orientation
		double tmp = ele(v-1,0);
		ele(v-1,0) = ele(v-1,1);
		ele(v-1,1) = tmp;
		st = 1;
	}
	return st;
}

int ReOrient(const mxArray *mxT, const mxArray *mxP) {
	unsigned char st;
	ulong i, eleid=0;
	bool s=false;
	for (i=0; i<ne; ++i) {
		st = CalculateOrientation(i+1, mxT, mxP);
		if (st <= 1) {
			eleid = i;
			s=true;
			break;
		}
	}
	if (s) {
		if (st==1) { 
			double ltmp;
			// Could determine orientation of one element and that element was in wrong direction
			// therefore since we assume all the elements in 'ele' are in the same directin,
			//  we need to change all of them.
			for (i=0; i<ne; ++i) {
				if (i==eleid) continue;
				ltmp = ele(i,0);
				ele(i,0) = ele(i,1);
				ele(i,1) = ltmp;
			}
		}
		return 0; // everything went well
	}
	else
		return 1; // could not orient
}
