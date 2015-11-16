/*
 *  GetListOfConnTri2Tri_mex.cpp
 *  
 *
 *  Created by Hamid Ghadyani on 1/7/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "GetListOfConnTri2Tri_mex.h"

// #define p(i,j) p[(i)+np*(j)]
#define ele(i,j) ele[(i)+nele*(j)]
//#define list(i,j) list[(i)+nele*(j)];
/* To compile this file use:
 * For Windows:
 * mex -v -DWIN32 -I./meshlib GetListOfConnTri2Tri_mex.cpp meshlib/vector.cpp
 *
 *For Mac/Linux
 *  mex -v -I./meshlib GetListOfConnTri2Tri_mex.cpp meshlib/vector.cpp
 */


// [list,vertex_tri_hash]=GetListOfConnTri2Tri_mex(ele,p)
// list(i): list of 3 connected triangles to triangle i
// vertex_tri_hash(i): list of all triangles sharing node i
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs!=2 || nlhs<1) {
        mexPrintf("[list,vertex_tri_hash]=GetListOfConnTri2Tri_mex(ele,p)\n");
        mexErrMsgTxt("GetListOfConnTri2Tri_mex: Needs 2 input argument");
    }
	nele = mxGetM(prhs[0]);
	std::vector< std::set<ulong> > Graph(nele);
	

	if (!mxIsDouble(prhs[1]))
        mexErrMsgTxt("GetListOfConnTri2Tri_mex: input argument 2 should be of 'double' type");
    np = mxGetM(prhs[1]);
	std::vector< std::set<ulong> > vertex_tri_hash(np);

    if (mxIsDouble(prhs[0]))
        ele = (double *) mxGetData(prhs[0]);
    else 
       mexErrMsgTxt("GetListOfConnTri2Tri_mex: t needs to be 'double'!");


	mxArray *cell_pointer; // Returned variable which holds connectivity list of triangles.
	mxArray *cell_pointer2; // The list that holds which triangles are connected to a given vertex

	
	// Populate the return value of 'list'
	PopulateGraph(Graph, vertex_tri_hash);
	cell_pointer=mxCreateCellMatrix(nele,1);
	for (ulong i=0; i<nele; ++i) {
		SetCell(cell_pointer, Graph[i], i);
	}
	plhs[0] = cell_pointer;

	if (nlhs>=2) {
		cell_pointer2 = mxCreateCellMatrix(np,1);
		for (ulong i=0; i<np; ++i) {
			SetCell(cell_pointer2, vertex_tri_hash[i], i);
		}
		plhs[1] = cell_pointer2;
	}
}


void PopulateGraph(std::vector< std::set<ulong> > &Graph, std::vector< std::set<ulong> > &vertex_tri_hash) {

	std::set<ulong> myneighbors;
	// Populate the hash table which tells us which triangles are sharing a specific node.
	for (ulong i=0; i<nele; ++i) {
		for (int j=0; j<3; ++j)
			vertex_tri_hash[(ulong) (ele(i,j)-1)].insert(i+1);
	}
	std::set<ulong> tmpSet;
	std::queue<ulong> q;
	std::vector<long> edge_check (nele, White);
	bool endflag=false;
	ulong starte=1;
	while (!endflag) {
		q.push(starte);
		ulong dummyc=0;
		while (!q.empty()) {
			ulong u = q.front();
			myneighbors = FindNeighboringTriangles(u, vertex_tri_hash);
			for (std::set<ulong>::iterator it=myneighbors.begin(); it!=myneighbors.end(); ++it) {
				if (edge_check[(*it)-1]==Black) continue;
				if (u != *it) {
					ulong tempak = *it;
					tmpSet.clear();
					tmpSet = Graph[u-1];
					tmpSet.insert(*it);
					Graph[u-1] = tmpSet;

					tmpSet.clear();
					tmpSet = Graph[(*it)-1];
					tmpSet.insert(u);
					Graph[(*it)-1] = tmpSet;
					if (edge_check[(*it)-1] == White)
						q.push(*it);
					edge_check[(*it)-1] = edge_check[(*it)-1] + 1;
	// 				if (edge_check[(*it)-1]>=3)
	// 					edge_check[(*it)-1] = Black;
				}
					
			}
			edge_check[u-1] = Black;
			q.pop();
			dummyc++;
		}
		endflag=true;
		for (ulong i=0; i<nele; ++i) {
			if (edge_check[i]!=Black)  {
				starte = i+1;
				endflag=false;
				break;
			}
		}
	}
}

// Searches all the triangles sharing a node with 'tri' in order to figure out
// the ones that share an edge. It then returns those triangles' IDs
std::set<ulong> FindNeighboringTriangles(ulong tri, std::vector< std::set<ulong> > &vertex_tri_hash ) {
	std::set<ulong> neighbours, ret;
	std::set<ulong>::iterator it;
	for (int i=0; i<3; ++i) {
		for (it=vertex_tri_hash[(ulong)(ele(tri-1,i))-1].begin(); it!=vertex_tri_hash[(ulong)(ele(tri-1,i))-1].end(); ++it) {
			if (*it != tri)
				neighbours.insert(*it);
		}
	}

	for (it=neighbours.begin(); it!=neighbours.end(); ++it) {
		if (ShareEdge(tri,*it)) {
			ret.insert(*it);
		}
	}
	return ret;
}

// If triangle u and v share an edge, it will return true, otherwise false
bool ShareEdge(ulong u, ulong v) {
	bool flag = false;
	ulong NV[3]={(ulong)(ele(v-1,0)), (ulong)(ele(v-1,1)), (ulong)(ele(v-1,2))};
	ulong NU[3]={(ulong)(ele(u-1,0)), (ulong)(ele(u-1,1)), (ulong)(ele(u-1,2))};
	ulong eu1, eu2, ev1, ev2;

	for (int i=0; i<3; ++i) {
		eu1 = NU[edge[i][0]]; eu2 = NU[edge[i][1]];
		for (int j=0; j<3; ++j) {
			ev1 = NV[edge[j][0]]; ev2 = NV[edge[j][1]];
			if ((eu1==ev1 && eu2==ev2) || (eu1==ev2 && eu2==ev1)) {
				return true;
			}
		}
	}
	return flag;
}

void SetCell(mxArray* cell_pointer, std::set<ulong> conn_elems, ulong i) {

	mwSize dims[2] = {1, conn_elems.size()};
	mxArray *tmpArray2=mxCreateNumericArray(2,dims,mxDOUBLE_CLASS,mxREAL);
    double *temp2 = (double *) mxGetData(tmpArray2);

	ulong counter=0;
	for (std::set<ulong>::iterator j=conn_elems.begin(); j!=conn_elems.end(); 
		 temp2[counter]=*j, ++counter, ++j);
	mxSetCell(cell_pointer, i, mxDuplicateArray(tmpArray2));

	mxDestroyArray(tmpArray2);
}