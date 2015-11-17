// [st intpnts all_ok intersection_status intersected_facets] =
//    intersect_ray_shell(rp1,rp2,p,t,tiny,facets_bbx,shell_normals,edge2tri_connectivity,indexing,mydir)
// Checks if a ray defined by rp1 and rp2 intersects the 3D shell
// defined by p and t, and if it does, how many intersections would occur.
// This routine assumes that ray rp1-rp2 is a ray that would never intersect
// the facets on any vertex since the points of the shell are perturbed infinitesimally.
// Return values are:
//     0 : rp1 is outside the shell
//     1 : rp1 is inside the shell
//     2 : rp1 is on one of the facets (note that not always this routine can detect all the points on the facet)
//    -1 : Can not determine the status of the node
//
// intersected_facets will be meanningful only if all_ok is true
// intersection_status will then have the following codes:
// 0 : crossed/pierced the mesh through only one face or edge - toggle worthy
// 1 : touched only one edge of the mesh, no crossing through mesh - toggle unworthy
// 2 : point on a parallel facet edge, ray entering the parallel facet through this point - toggle unworthy
// 3 : point on a parallel facet edge, ray exitting the parallel facet through this point - toggle   worthy
// 4 : point on a parallel facet edge, ray exitting the parallel facet through this point - toggle unworthy
// 5 : point on two parallel facets' common edge, toggle unworthy

// To compile this use:
// Windows
// mex -v -DWIN32 -I./meshlib intersect_ray_shell_mex.cpp ./meshlib/vector.cpp ./meshlib/geomath.cpp
//
// Mac
// mex -v         -I./meshlib intersect_ray_shell_mex.cpp ./meshlib/vector.cpp ./meshlib/geomath.cpp

#include "intersect_ray_shell_mex.h"

#define p(i,j) p[(i)+np*(j)]
#define t(i,j) t[(i)+ne*(j)]
#define facets_bbx(i,j) facets_bbx[(i)+ne*(j)];
#define indexing(i,j) indexing[(i)+m_indexing*(j)];

#define GetNormal(v,tri) \
				    v[0]=shell_normals[tri-1 + 0*ne]; \
				    v[1]=shell_normals[tri-1 + 1*ne]; \
				    v[2]=shell_normals[tri-1 + 2*ne];


// [st intpnts all_ok intersection_status intersected_facets] =
//                         intersect_ray_shell(rp1,rp2,p,t,tiny,facets_bbx,shell_normals,edge2tri_connectivity,indexing,mydir)
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    CheckArgsIn(nlhs, plhs, nrhs, prhs);
    bool debug=false;
    unsigned long cross_counter=0;
    std::vector<std::vector<double> > tmp_ipnt;

    int st=0;

    if (nrhs==7) // debug flag
        debug=true;
    if (/*rp1 & rp2 */!mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1]) || /*tiny*/!mxIsDouble(prhs[4]))
        mexErrMsgTxt("rp1 and rp2 need to be of type 'double'!");
    double *p;
    if (mxIsDouble(prhs[2]))
        p = mxGetPr(prhs[2]);
    else
        mexErrMsgTxt("p needs to be either 'single' or 'double'");
    /*unsigned long int *t;
    if (mxIsUint32(prhs[3]))
        t = (unsigned long int *) mxGetData(prhs[3]);
    else if (mxIsInt32(prhs[3])) {
        mexWarnMsgIdAndTxt("intersect_ray_shell:singedToUnsigned",
                            "Converting 't' to unsigned long! Might lose some data!");
        t = (unsigned long int *) mxGetData(prhs[3]);
    }
    else
        mexErrMsgTxt("t needs to be uint32!");*/

    double *t;
    if (mxIsDouble(prhs[3]))
        t = (double *) mxGetData(prhs[3]);
    else
        mexErrMsgTxt("intersect_ray_shell: t needs to be 'double'!");

	double tiny=mxGetScalar(prhs[4]);

	float *facets_bbx;
    double *rp1 = mxGetPr(prhs[0]);
    double *rp2 = mxGetPr(prhs[1]);

    unsigned long np=mxGetM(prhs[2]);
	unsigned long ne=mxGetM(prhs[3]);
	unsigned long nbbx=mxGetM(prhs[5]);

    if (debug) {
        mexPrintf("m=%d n=%d\n",mxGetM(prhs[5]),mxGetN(prhs[5]));
    }
//     check to see if we need to create facets_bbx
    if (nrhs>=6 && !mxIsEmpty(prhs[5])) {
        if (debug)
            mexPrintf("Checking facets_bbx\n");
        facets_bbx=(float *)mxGetData(prhs[5]);
        nbbx=mxGetM(prhs[5]);
        if (debug)
            mexPrintf("First facets_bbx: %f\n",facets_bbx[0]);
        if (nbbx!=ne) {
            mexErrMsgTxt("Number of patches and bounding box list does not match!\n");
        }
        if (mxGetN(prhs[5])!=6)
            mexErrMsgTxt("Facets bbx needs to be ne by 6 matrix!");
    }
    else if (nrhs<6 || mxIsEmpty(prhs[5])) {
        if (debug)
            mexPrintf("Calculating facets_bbx\n");
        facets_bbx = new float[ne*6];
        for (ULONG i=0; i<ne; ++i) {
            ULONG n1= (ULONG) t(i,0);
            ULONG n2= (ULONG) t(i,1);
            ULONG n3= (ULONG) t(i,2);
            double tmp;
            for (ULONG j=0; j<3; ++j) {
                tmp = std::min(p(n1-1,j),p(n2-1,j));
                facets_bbx[i+j*ne]=std::min(tmp,p(n3-1,j));
                tmp = std::max(p(n1-1,j),p(n2-1,j));
                facets_bbx[i+(j+3)*ne]=std::max(tmp,p(n3-1,j));
            }
        }
    }
    if (debug) {
        mexPrintf("First facets_bbx: %f\n",facets_bbx[0]);
//         mexErrMsgTxt("Done...!\n");
    }
    double *shell_normals;
    if (mxIsDouble(prhs[6]) /*|| mxIsSingle(prhs[6])*/)
        shell_normals = mxGetPr(prhs[6]);
    else
        mexErrMsgTxt("shell_normals needs to be either 'single' or 'double'");
    if (!mxIsCell(prhs[7]))
        mexErrMsgTxt("intersect_ray_shell_mex: edge2tri_connectivity needs to be a cell array!\n");
    unsigned long int *indexing;
    if (mxIsUint32(prhs[8])) {
        indexing = (unsigned long int *) mxGetData(prhs[8]);
		m_indexing = mxGetM(prhs[8]);
	}
    else
        mexErrMsgTxt("intersect_ray_shell_mex: 'indexing' should be of the type UINT32!\n");

    std::vector<points> intpnts;
    points p1;
    std::vector<int> intersection_status;
    std::vector<ULONG> intersected_facets;
    bool all_ok=true;
    if (debug)
        mexPrintf("Calculating ray's bbx\n");
    double raybbx[6]={0.,0.,0.,0.,0.,0.};
    for (int i=0; i<3; ++i) {
        raybbx[i]=std::min(rp1[i],rp2[i]);
        raybbx[i+3]=std::max(rp1[i],rp2[i]);
        if (debug)
            mexPrintf("ray: %f %f\n",raybbx[i],raybbx[i+3]);
    }
    if (debug)
        mexPrintf("Entering the main loop\n");
	std::vector<bool> examined_facets(ne,false);
    for (ULONG i=0; i<ne; ++i) {
		if (examined_facets[i]==true) // we have already checked this face in IsValidCrossing() function
			continue;
        double MaxX = facets_bbx(i,3); double MinX = facets_bbx(i,0);
        double MaxY = facets_bbx(i,4); double MinY = facets_bbx(i,1);
        double MaxZ = facets_bbx(i,5); double MinZ = facets_bbx(i,2);

        if (MaxX<raybbx[0] || raybbx[3]<MinX || MaxY<raybbx[1] ||
            raybbx[4]<MinY || MaxZ<raybbx[2] || raybbx[5]<MinZ)
            continue;
       double tp1[3], tp2[3], tp3[3];
        for (int k=0; k<3; ++k) {
           if (debug)
               mexPrintf("getting the triangle coordinates to check intersection with");
            tp1[k] = p( (ULONG)(t(i,0)-1), k);
            tp2[k] = p( (ULONG)(t(i,1)-1), k);
            tp3[k] = p( (ULONG)(t(i,2)-1), k);
        }
        if (debug)
            mexPrintf("Calling intersect_RayTriangle\n");
        double myipnt[3]={0.,0.,0.}, mydir[3]={1.,0.,0.};
        double tt=0, uu=0, vv=0;
//         int ret = intersect_RayTriangle(rp1, rp2, tp1, tp2, tp3, ipnt, tiny);

        int ret2 = intersect_ray_triangle_moller(rp1,mydir,tp1,tp2,tp3,&tt,&uu,&vv,tiny);
        if (ret2==2) { // parallel ray and plane of triangle, call a different routine
            ret2 = ray_triangle_coplanar(rp1, rp2, tp1, tp2, tp3, tmp_ipnt, tiny);
            assert(ret2!=-1);
            ret2 = (ret2==0 ? 2 : ret2);
        }
		else if (ret2!=0) {
			tmp_ipnt.clear();
			myipnt[0]=rp1[0]+tt*mydir[0];myipnt[1]=rp1[1]+tt*mydir[1];myipnt[2]=rp1[2]+tt*mydir[2];
			std::vector<double> tmp;
			for (int i=0; i<3; tmp.push_back(myipnt[i]), ++i);
			tmp_ipnt.push_back(tmp);
		}
        int ret=ret2;

        if (ret!=0 && ret!=2) {
           /* if (debug)
                mexPrintf("Intersection Exists!\n");*/
		}
		else if (ret==0 || ret==2)
			continue;

        if (ret==1) {
            ++cross_counter;
            for (int j=0;j<3;p1.c[j]=myipnt[j],++j);
            intpnts.push_back(p1);
            intersection_status.push_back(0);
            intersected_facets.push_back(i+1);
            continue;
        }
        else if (ret==10 || ret==11 || ret==12 || ret==300 || ret==301 || ret==302) { // ray is intersecting the triangle on edges
			std::vector<points> int_pnts;
			std::vector<int> int_status;
            if (IsValidCrossing(i+1,ret,tmp_ipnt,rp1,rp2,mydir,tiny,int_pnts,int_status,examined_facets,shell_normals,prhs[7],indexing,t,p,ne,np)) {
                ++cross_counter;
            }
			tmp_ipnt.clear();
            all_ok=false;
            for (int j=0; j<int_pnts.size(); ++j) {
                intpnts.push_back(int_pnts[j]);
                intersection_status.push_back(int_status[j]);
            }
        }
        else if (ret==20 || ret==21 || ret==22) { // Crossing through a vertex
            // What to do in this case if we haven't perturbed the nodes of mesh such that our rays won't pass through them ?!!
            // For now, we will terminate the routine!
            mexPrintf("intersect_ray_shell_mex: Ray has crossed a vertex. This was not supposed to happen.\nHave you purturbed the nodes ?!\n");
            st = -1;
            all_ok = false;
            break;
        }
        else if (ret==100 || ret==101 || ret==102) { // Ray parallel to facet and intersecting ONLY one edge
            // This most likely means that that start of ray is on the facet and the facets is parallel to the ray
            st=2;
            all_ok = false;
            break;
        }
        else if (ret==200 || ret==201 || ret==201) { // Ray parallel to facet and intersecting ONLY one vertex
            // Two scenarios: 1- onset of ray is one of the facets' vertices.
            //                2- This ray will intersect other facets on a vertex too, i.e., on a different 'i' (the loop counter for facets)
            // What to do ?!!
            st = -1;
            all_ok = false;
            break;
        }
        else if (ret==400 || ret==401 || ret==402) { // Ray Parallel to facet and intersecting a vertex AND opposing edge
            // What to do in this case if we haven't perturbed the nodes of mesh such that our rays won't pass through them ?!!
            // For now, we will terminate the routine!
            mexPrintf("intersect_ray_shell_mex: Ray has crossed a vertex. This was not supposed to happen.\nHave you purturbed the nodes ?!\n");
            st = -1;
            all_ok = false;
            break;
        }
        else if (ret==500 || ret==501 || ret==502) { // Ray parallel to facet and coincident with one of the edges of the facet
            // Again, as above, what to do if we haven't perturbed the nodes of the mesh ?!!
            // For now, we will terminate the routine!
            mexPrintf("intersect_ray_shell_mex: Ray has crossed a vertex. This was not supposed to happen.\nHave you purturbed the nodes ?!\n");
            st = -1;
            all_ok = false;
            break;
        }
    }
    if (st==0)
        (cross_counter%2==1) ? st=1 : st=0;

    if (debug)
            mexPrintf("Setting up output values!\n");
    plhs[0] = mxCreateDoubleScalar((double)st);
    unsigned long int nintpnts=0;
    if (st!=-1 && st!=2) {
        nintpnts = intpnts.size();
    }
    if (nintpnts>=0) {
        if (debug)
            mexPrintf("Setting intpnts!\n");
        plhs[1] = mxCreateDoubleMatrix(nintpnts,3,mxREAL);
		double *ipnts = mxGetPr(plhs[1]);
		for (ULONG i=0; i<nintpnts; ++i) {
			for (int j=0; j<3; ++j) {
				ipnts[j*nintpnts+i]=intpnts[i].c[j];
			}
		}
	}
    mxLogical foo2 = all_ok;
    plhs[2] = mxCreateLogicalScalar(foo2);
    if (nintpnts>=0) {
		if (debug)
            mexPrintf("Setting intersection_status!\n");
		plhs[3] = mxCreateNumericMatrix(nintpnts, 1, mxINT8_CLASS, mxREAL);
		char  *footmp1 = (char *) mxGetData(plhs[3]);
		for (ULONG i=0; i<nintpnts; footmp1[i]=intersection_status[i],++i)
            ;

        if (debug)
            mexPrintf("Setting intersected_facets!\n");
		if (all_ok) {
			plhs[4] = mxCreateNumericMatrix(nintpnts, 1, mxUINT32_CLASS, mxREAL);
			unsigned long int *footmp2 = (unsigned long int *) mxGetData(plhs[4]);
			for (ULONG i=0; i<nintpnts; footmp2[i]=intersected_facets[i],++i);
		}
		else
			plhs[4] = mxCreateNumericMatrix(0, 1, mxUINT32_CLASS, mxREAL); // empty
	}
    if (nrhs<6 || mxIsEmpty(prhs[5])) {
        delete [] facets_bbx;
    }
    // Exit

}

bool CheckArgsIn(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

    if (nrhs!=10) {
        mexPrintf("nargin = %d\n",nrhs);
        mexErrMsgTxt("intersect_ray_shell: You need to enter 9 input args!");
    }
    if (nlhs<2) {
        mexErrMsgTxt("intersect_ray_shell: Output arguments should be at least 2!");
    }
	if (mxGetN(prhs[2])!=3 || mxGetN(prhs[3])!=3) {
		mexErrMsgTxt("intersect_ray_shell can only be used for 3D triangular shells!\n");
	}
    bool f1=true;
    for (int i=0; i<nrhs; f1=f1 && !mxIsComplex(prhs[i]), ++i);
    if (!f1) {
        mexErrMsgTxt("intersect_ray_shell: Input arguments are complex!");
    }
    for (int i=0; i<nrhs; f1=f1 && (!mxIsEmpty(prhs[i]) || i==5), ++i);
    if (!f1) {
        mexErrMsgTxt("intersect_ray_shell: Input arguments are empty!");
    }
    f1=true;
    for (int i=0; i<nrhs; f1=f1 && !mxIsChar(prhs[i]), ++i);
    if (!f1) {
        mexErrMsgTxt("intersect_ray_shell: Input arguments are string!");
    }
	/*
	const mxArray *tmp;
	tmp = mxGetCell(prhs[7],0);
	mxClassID category;
	category = mxGetClassID(tmp[0]);
	if (category != mxUINT32_CLASS)
		mexErrMsgTxt("edge2tri_connectivity needs to be a cell array of type UINT32!\n");
*/
    return true;
}

// int_status : contains following codes about the status of intersected points
// 0 : crossed/pierced the mesh through only one edge - toggle worthy
// 1 : touched only one edge of the mesh, no crossing through mesh - toggle unworthy
// 2 : point on a parallel facet edge, ray entering the parallel facet through this point - toggle unworthy
// 3 : point on a parallel facet edge, ray exitting the parallel facet through this point - toggle   worthy
// 4 : point on a parallel facet edge, ray exitting the parallel facet through this point - toggle unworthy
// 5 : point on two parallel facets' common edge, toggle unworthy
// int_facets: will be used in calling function to make sure that we don't check them again.
bool IsValidCrossing(ULONG idx, int first_st, std::vector<std::vector<double> > first_intpnts,
					 double *rp1, double *rp2, double *mydir, double tiny,
					 std::vector<points> &int_pnts, std::vector<int> &int_status, std::vector<bool> &int_facets,
					 double *shell_normals, const mxArray *list, ULONG *indexing,
					 double *t, double *p, ULONG ne, ULONG np) {
	double tp1[3], tp2[3], tp3[3];
	double tt=0, uu=0, vv=0;
	double norm[2][3];
	double tmp_norm[2][3], n_curr[3], dot;
	double mysign[2]={0,0};
	bool ret;
	int tmp_i;
	ULONG starting_triangle;
	ULONG edge[2][2]={{0,0}, {0,0}};
	ULONG comm_edge[2]={0,0};
	ULONG N[3];
	ULONG tri1;
	std::vector<std::vector<double> > myipnt, myipnt2;
    points points_tmp;
    ULONG tri, next_tri;
    ULONG edge1[2], edge2[2];

	int_pnts.clear();
	int_status.clear();
	//int_facets.clear();

	tri1 = idx;
	starting_triangle=tri1;
	GetNormal(norm[0],tri1);
	mysign[0] = DOT(norm[0],mydir);
	if (!IsEqual(mysign[0],0,tiny)) {
		mysign[0] = sign(mysign[0]);
		for (int i=0; i<3; N[i]=(ULONG)t(tri1-1,i), ++i);
		int foo1 = first_st % 10;
		int foo2 = (foo1+1) % 3;
		edge[0][0] = std::min(N[foo1],N[foo2]); edge[0][1] = std::max(N[foo1],N[foo2]);
	}
	else {
		assert(first_st!=-1 && first_st<=302 && first_st>=300);
		for (int i=0; i<3; N[i]=(ULONG)t(tri1-1,i), ++i);
		ULONG foo1 = first_st % 10;
		ULONG foo2 = (foo1 + 1) % 3;
		edge[0][0] = std::min(N[foo1],N[foo2]); edge[0][1] = std::max(N[foo1],N[foo2]);
		foo1 = (foo1+1) % 3;
		foo2 = (foo1+1) % 3;
		edge[1][0] = std::min(N[foo1],N[foo2]); edge[1][1] = std::max(N[foo1],N[foo2]);
	}
	comm_edge[0]=edge[0][0]; comm_edge[1]=edge[0][1];
	next_tri = starting_triangle;
	int_facets[next_tri-1] = true;
	myipnt2 = first_intpnts;
	tmp_i=0;
	while (true) { // Loop until we get a non-parallel facet
		tri = GetNeighborTriangle(comm_edge,next_tri,list,indexing);
		int_facets[tri-1] = true;
		GetNormal(n_curr,tri);
		dot = DOT(n_curr,mydir);
		if (!IsEqual(dot,0,tiny)) { // Found a non-parallel facet
			dot = sign(dot);
			if (myipnt2.size()==2)
				tmp_i = tmp_i ? 0 : 1;
			else if (myipnt2.size()==1)
				tmp_i=0;
			else
				mexErrMsgTxt("IsValidCrossing(): Was expecting 1 or 2 intersection points!");
			for (int iii=0; iii<3; points_tmp.c[iii]=myipnt2[tmp_i][iii], ++iii);
			int_pnts.push_back(points_tmp);
			comm_edge[0]=edge[1][0]; comm_edge[1]=edge[1][1];
			next_tri = starting_triangle;
			if (IsEqual(mysign[0],0,tiny))
				mysign[0] = dot;
			else if (IsEqual(mysign[1],0,tiny)) {
				mysign[1] = dot;
				break;
			}
			else {
				mexPrintf("\n\n Sanity check: IsValidCrossing(): both directions are filled but we are still checking!!!\n\n");
				mexErrMsgTxt("Fatal error/bug!");
			}
		}
		else {
			for (int k=0; k<3; ++k) { // Copy coordinates of next triangle to tp1, tp2, tp3
				tp1[k] = p( (ULONG)(t(tri-1,0)-1), k);
				tp2[k] = p( (ULONG)(t(tri-1,1)-1), k);
				tp3[k] = p( (ULONG)(t(tri-1,2)-1), k);
			}
			for (int iii=0; iii<3; N[iii]=(ULONG)t(tri-1,iii), ++iii);
			int ret2 = ray_triangle_coplanar(rp1, rp2, tp1, tp2, tp3, myipnt2, tiny);
			assert(ret2!=-1 && ret2<=302 && ret2>=300);
			ULONG foo1 = ret2 % 10;
			ULONG foo2 = (foo1 + 1) % 3;
			edge1[0] = std::min(N[foo1],N[foo2]); edge1[1] = std::max(N[foo1],N[foo2]);
			foo1 = (foo1+1) % 3;
			foo2 = (foo2+1) % 3;
			edge2[0] = std::min(N[foo1],N[foo2]); edge2[1] = std::max(N[foo1],N[foo2]);
			// Find the other edge of triangle crossed by the ray.
			if (edge1[0]==comm_edge[0] && edge1[1]==comm_edge[1]) {
				comm_edge[0]=edge2[0];
				comm_edge[1]=edge2[1];
				tmp_i = 0;
			}
			else if (edge2[0]==comm_edge[0] && edge2[1]==comm_edge[1]) {
				comm_edge[0]=edge1[0];
				comm_edge[1]=edge1[1];
				tmp_i = 1;
			}
			next_tri = tri;
			for (int iii=0; iii<3; points_tmp.c[iii]=myipnt2[tmp_i][iii], ++iii);
			int_pnts.push_back(points_tmp);
		}
	}

	// Now we need to sort intersection points based on their distance from rp1.
	// After the sorting, any point between first and last would be considered
	// 'toggle unworthy'!

	std::vector<double> d;
	double tmp_d=0.;
	for (int i=0; i<int_pnts.size(); ++i) {
		for (int j=0; j<3; tmp_norm[0][j] = int_pnts[i].c[j], ++j);
		SUB(tmp_norm[1],tmp_norm[0],rp1);
		d.push_back(v_magn(tmp_norm[1],3));
	}
	for (int i=0; i<int_pnts.size()-1; ++i) {
		for (int j=i+1; j<int_pnts.size(); ++j) {
			if (d[i]>d[j]) {
				tmp_d = d[j];
				d[j] = d[i];
				d[i] = tmp_d;

				for (int k=0; k<3; points_tmp.c[k]=int_pnts[j].c[k], ++k);
				for (int k=0; k<3; int_pnts[j].c[k]=int_pnts[i].c[k], ++k);
				for (int k=0; k<3; int_pnts[i].c[k]=points_tmp.c[k], ++k);
			}
		}
	}
	for (int i=0; i<int_pnts.size(); ++i) {
		int_status.push_back(5); // no toggeling, all intersectio points on the parallel facets will have 5 for their status
	}
	int_status.clear(); // we decided that we don't want to report back all the status codes
	std::vector<points> tmpnts;
	tmpnts.push_back(int_pnts.front());
	tmpnts.push_back(int_pnts.back());
	int_pnts.clear();
	int_pnts = tmpnts;
	int_status.push_back(2);
	// int_status.front() = 2; // entering a parallel facet but no toggeling

	if (mysign[0]*mysign[1]>0) // valid crossing over parallel faces
		ret=true;
	else
		ret=false;
	int_status.push_back(ret ? 3 : 4); // exitting a parallel facet. 3 for toggling and 4 for non-toggling
	return ret;
}

// Returns the triangle neighbor to 'tri' that is sharing the edge 'edge'
ULONG GetNeighborTriangle(ULONG edge[2], ULONG tri, const mxArray *list, ULONG *indexing) {
	unsigned long int m = mxGetM(list);
    mxArray *tmp;
    unsigned long int *temp_edge;
    unsigned long int *tris;
	int subs[2]={0,0};
	int nsubs = 2;
    int nconn_tris = 0;
	mwIndex index;

	if (edge[0]>edge[1])
		std::swap(edge[0],edge[1]);
	ULONG starti = indexing(edge[0]-1,0);
	ULONG endi   = indexing(edge[0]-1,1);
	--starti; --endi;
	for (ULONG i=starti; i<=endi; ++i) {
		index = i + 0*m;
		tmp = mxGetCell(list,index);
		temp_edge = (unsigned long int *) mxGetData(tmp);
		if (edge[0]==temp_edge[0] && edge[1]==temp_edge[1]) {
			index = i + 1*m; // list{i,1}
			tmp = mxGetCell(list,index);
			tris = (unsigned long int *) mxGetData(tmp);
			nconn_tris = mxGetNumberOfElements(tmp);
			if (nconn_tris!=2) {
				mexPrintf("\tintersect_ray_shell_mex: edge2tri_connectivity cell array needs to be {[N1 N2], [Tri1 Tri2]}\n");
				mexPrintf("\t\tYour input has more or less than two triangles connected to edge [%d %d] : %d\n",edge[0],edge[1],nconn_tris);
				mexErrMsgTxt("\tExiting...\n");
			}
			if (tris[0]==tri)
				return tris[1];
			else if (tris[1]==tri)
				return tris[0];
			else {
				mexPrintf("intersect_ray_shell_mex:GetNeighborTriangle: Couldn't find the given triangle: %d %d\n",edge[0],edge[1]);
				mexErrMsgTxt("Exitting...\n");
			}
		}
	}
	mexPrintf("intersect_ray_shell_mex:GetNeighborTriangle: Couldn't find the given edge: %d %d\n",edge[0],edge[1]);
	mexErrMsgTxt("Exitting...\n");
}
