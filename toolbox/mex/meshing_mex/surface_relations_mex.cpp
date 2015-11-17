#include "surface_relations_mex.h"

#define p(i,j) p[(i)+np*(j)]
#define ele(i,j) ele[(i)+ne*(j)]
#define facets_bbx(i,j) facets_bbx[(i)+(j)*ne]

/*
This program detects the the inclusion of nested 3D surfaces and how they are nested.
This is required to formulate BEM matrices.

This MEX file should be called from Matlab using following format:

>> st = surface_relations_mex(fnprefix,no_regions,test_type);

'fnprefix' is first part of .node/.ele filenames: 'fnprefix_4.node/.ele'
'no_regions' is total number of sepearate homogenous regions.
'test_type' 1 for BSP method. 2 for Jordan method

Output: 
st : 0 for successfull run non-zero otherwise
Also a text file "surface_relations.txt". For exmaple if we have 5 regions, this text file will be:

1 2 3 4
2 0
3 5
4 0
5 0

meaning that surface 1 has three direct children (2, 3 and 4). surface 3 has only one child (5) and
the rest of surfaces don't have any child.

If any pair of surfaces are intersecting, the program will not produce "surface_relations.txt" and
will return a value of '5'. Otherwise it will return 0.

*/

/* How to compile:

Windows:
mex -v -DCPU86 -DWIN32 -I./meshlib surface_relations_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp meshlib/polyhedron2BSP.cpp meshlib/CPoint.cpp meshlib/CVector.cpp meshlib/Plane3D.cpp meshlib/BSPNode.cpp meshlib/MeshIO.cpp meshlib/FileOperation.cpp meshlib/CPolygon.cpp meshlib/predicates.cpp meshlib/CStopWatch.cpp

Linux:
mex -v -DLINUX -I./meshlib surface_relations_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp meshlib/polyhedron2BSP.cpp meshlib/CPoint.cpp meshlib/CVector.cpp meshlib/Plane3D.cpp meshlib/BSPNode.cpp meshlib/MeshIO.cpp meshlib/FileOperation.cpp meshlib/CPolygon.cpp meshlib/predicates.cpp meshlib/CStopWatch.cpp

Mac OSX:
mex -v -I./meshlib                 surface_relations_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp meshlib/polyhedron2BSP.cpp meshlib/CPoint.cpp meshlib/CVector.cpp meshlib/Plane3D.cpp meshlib/BSPNode.cpp meshlib/MeshIO.cpp meshlib/FileOperation.cpp meshlib/CPolygon.cpp meshlib/predicates.cpp meshlib/CStopWatch.cpp
*/

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    if (nrhs!=2 && nrhs!=3)
        mexErrMsgTxt("surface_relations_mex needs 2 or 3 input arguments!");
    /*if (nlhs!=1)
        mexErrMsgTxt("surface_relations_mex needs 1 output variable!");*/
    if (!mxIsChar(prhs[0]))
        mexErrMsgTxt("first input argument to surface_relations_mex should filename prefix of .inp files!");

    char foo[256];
    char *fname_prefix = foo;
    //char *fname_prefix = new char[256];
    // Get filename prefix for all the .inp files
    fname_prefix = mxArrayToString(prhs[0]);
    // Get number of regions
    int no_regions = (int)(*mxGetPr(prhs[1]));
    
    int containment_test = 1;
    if (nrhs>=3) {
        containment_test = (int)(*mxGetPr(prhs[2]));
    }
    
    std::vector<std::string> snames;
    char buffer[256];
    std::string tmpstring("");
    
    for (int i=0; i<no_regions; ++i) {
#if defined(WIN32) || defined(WIN64) || defined(WINDOWS) || defined(windows)
        tmpstring = (((std::string)fname_prefix) + *(_itoa(i+1,buffer,10)));
#else
        sprintf(buffer,"%d",i+1);
        tmpstring = ((std::string)fname_prefix) + *buffer;
#endif
        tmpstring = tmpstring + ".node";
        snames.push_back(tmpstring);
    }
    std::vector< std::vector<int> > relations;
    if (containment_test == 1) // BSP Method
        relations = core(snames);
    else // Jordan's method
        relations = core2(fname_prefix,no_regions);
    
    int st = 0; 
    if (relations.size()==0)
        st = 1; // Could not establish spatial relationship, ERROR
        
    if (nlhs==1) {
        plhs[0] = mxCreateDoubleScalar((double) st);
    }
    //delete fname_prefix;
}
std::vector< std::vector<int> > core2(char* fn_prefix, int no_regions) {
    
    int c = 0;
    CFileOperation myfile;
    char buffer[256];
    std::string tmpstring("");
    std::vector< std::vector<int> > relations(no_regions);
    int nnpe=0;
    std::vector<Point *> _points;
    std::vector<ULONG> _ele;
    
    std::vector<mxArray *> eleArray(no_regions);
    std::vector<mxArray *> nodeArray(no_regions);
    
    std::ofstream ofs;
    std::string outfn("surface_relations.txt");
    std::vector<int> foo1, foo2;

    int mymax;
    std::vector<int> rank(no_regions,0);
    std::vector<bool> idxmarker(no_regions,false);
    std::vector< std::vector<int> >::iterator ite;
    
    std::vector< std::vector<double> > Extreme(no_regions);
    std::vector<double *> BBX(no_regions);
    double macheps = exactinit();
    // Read the .node/.ele files and store them in mxArray *[]
    for (int i=0; i<no_regions; ++i) {
        sprintf(buffer,"%d",i+1);
        tmpstring = ((std::string)fn_prefix) + *buffer;
        std::string nfn = tmpstring + ".node";
        std::string efn = tmpstring + ".ele";
        
        MeshIO meshio(nfn, efn);
        if ((nnpe = meshio.ReadPolyhedron(_points, _ele)) < 0) {
            std::cerr << std::endl << "\tsurface_relations_mex: Error in reading node/ele file!" << std::endl;
            // Free memory
            for (int jj=0; jj<i-1; ++jj) {
                mxDestroyArray(eleArray[jj]);
                mxDestroyArray(nodeArray[jj]);
            }
            relations.clear();
            return relations;
        }
        ULONG ne = _ele.size() / nnpe;
        eleArray[i] = mxCreateDoubleMatrix(ne,3,mxREAL);
        double *ele = (double *) mxGetPr(eleArray[i]);
        for (ULONG j=0; j<ne; ++j) {
            for (ULONG k=0; k<nnpe; ++k) {
                ele[j + k*ne] = _ele[j*nnpe + k];
            }
        }
        
        ULONG np = _points.size();
        nodeArray[i] = mxCreateDoubleMatrix(np,3,mxREAL);
        double *p = (double *) mxGetPr(nodeArray[i]);
        for (ULONG j=0; j<_points.size(); ++j) {
            p[j + 0*np] = (double) _points[j]->x;
            p[j + 1*np] = (double) _points[j]->y;
            p[j + 2*np] = (double) _points[j]->z;
        }
        Extreme[i].push_back(0.); Extreme[i].push_back(0.);
        double *foobbx;
        GetBBX(nodeArray[i],eleArray[i],Extreme[i],foobbx);
        BBX[i] = foobbx;
        _points.clear();
        _ele.clear();
    }
    
    std::vector<ULONG> int_facets;
    std::vector<points> int_points;
    bool allin_flag = true, inflag = false, loopflag = true;
    //~ relations.assign(no_regions,0);
    std::vector<int> foo;
    for (int i=0; i<no_regions; ++i) {
        mxArray *nodes_i = nodeArray[i];
        mxArray *ele_i = eleArray[i];
        for (int j=0; j<no_regions; ++j) {
            if (i==j) continue;
            ULONG np = mxGetM(nodeArray[j]);
            double P[3] = {0.,0.,0.};
            double *nodes_j = mxGetPr(nodeArray[j]);
            for (ULONG ii=0; ii<np; ++ii) {
                for (int jc=0; jc<3; ++jc) {
                    P[jc] = nodes_j[ii+np*jc];
                }
                int ret = isinvolume_randRay(P,nodes_i,ele_i,macheps*(Extreme[i][1]-Extreme[i][0]),BBX[i],200,Extreme[i][0],Extreme[i][1],int_facets,int_points);
                int_facets.clear();
                int_points.clear();
                if (ret == 0) {
                    allin_flag = false;
                    // break;
                }
                else if (ret == 1 || ret == 2) {
                    inflag = true;
                }
                else if (ret == 2) {
                    std::cerr << "    The provided surfaces are not disjoint. I found a node from" << std::endl;
                    std::cerr << "    surface " << j+1 << " sitting on surface " << i+1 << "!." << std::endl;
                    // Free memory
                    for (int jj=0; jj<no_regions; ++jj) {
                        mxDestroyArray(eleArray[jj]);
                        mxDestroyArray(nodeArray[jj]);
                        delete [] BBX[jj];
                        Extreme[jj].clear();
                    }
                    BBX.clear();
                    Extreme.clear();
                    relations.clear();
                    return relations;
                }
                else if (ret == 255) {
                    std::cerr << " surface_relations_mex: Could not find a clean direction for the cast ray!" << std::endl;
                    // Free memory
                    for (int jj=0; jj<no_regions; ++jj) {
                        mxDestroyArray(eleArray[jj]);
                        mxDestroyArray(nodeArray[jj]);
                        delete [] BBX[jj];
                        Extreme[jj].clear();
                    }
                    BBX.clear();
                    Extreme.clear();
                    relations.clear();
                    return relations;
                }
            }
            if (allin_flag == false && inflag == true) { // intersection surfaces, not suitable for BEM
                mexPrintf("  Warning!\n");
                mexPrintf("   This set of surfaces can not be used in BEM formulation!\n");
                mexPrintf("   Reason: they are NOT mutually exclusive sub-surfaces!\n\n");
                allin_flag = true; inflag = false;
                relations.clear();
                // Free memory
                for (int jj=0; jj<no_regions; ++jj) {
                    mxDestroyArray(eleArray[jj]);
                    mxDestroyArray(nodeArray[jj]);
                    delete [] BBX[jj];
                }
                Extreme.clear();
                return relations;
                goto exit;
            }
            else if (allin_flag == true) {
                //std::cout << "just before bug" << std::endl;
                if (relations[i].size())
                    foo = relations[i];
                else
                    foo.clear();
                                        
                foo.push_back(j);
                relations[i] = foo;
                inflag = false;
            }
            else if (allin_flag == false && inflag == false) {
                allin_flag = true;
            }
        }
    }
    // Sort the relations vector based on number of childern (max to min)
    c=0;
    while (loopflag) {
        loopflag = false;
        for (int i=0; i<relations.size(); ++i) {
            if (idxmarker[i]==true)
                continue;
            else {
                mymax = i;
                loopflag = true;
            }
            for (int j=i+1; j<relations.size(); ++j) {
                if (idxmarker[j]==true)
                    continue;
                if (relations[j].size() > relations[mymax].size())
                    mymax = j;
            }
            idxmarker[mymax]=true;
            rank[c] = mymax;
            ++c;
        }
    }

    for (int i=0; i<relations.size()-1; ++i) {
        foo1 = relations[rank[i]];
        for (int j=i+1; j<relations.size(); ++j) {
            foo2 = relations[rank[j]];
            for (int ii=0; ii<foo2.size(); ++ii) {
                for (std::vector<int>::iterator jj=foo1.begin(); jj!=foo1.end(); ++jj) {
                    if (foo2[ii]==*jj) {
                        foo1.erase(jj);
                        relations[rank[i]] = foo1;
                        break;
                    }
                }
            }
        }
    }
    
    myfile.OpenOutFile(ofs,outfn,"text");
    c=1;
    // Write a text file explaining the relationships between surfaces
    for (int i=0; i<no_regions; ++i) {
        foo1 = relations[rank[i]];
        ofs << rank[i] + 1;
        if (!foo1.empty()) {
            for (int j=0; j<foo1.size(); ++j) {
                ofs << ' ' << foo1[j] + 1;
            }
            ofs << std::endl;
        }
        else {
            ofs << " 0" << std::endl;
        }
    }
    ofs.close();
    
exit:
    for (int jj=0; jj<no_regions; ++jj) {
        mxDestroyArray(eleArray[jj]);
        mxDestroyArray(nodeArray[jj]);
        delete [] BBX[jj];
        Extreme[jj].clear();
    }
    BBX.clear();
    Extreme.clear();
    return relations;
}

void GetBBX(mxArray *pmx, mxArray *elemx, std::vector<double>& extremes, double *&facets_bbx) {

    double xMax = -std::numeric_limits<double>::max();
    double xMin =  std::numeric_limits<double>::max();
    ULONG np = mxGetM(pmx);
    double *p = mxGetPr(pmx);
    for (ULONG i=0; i<np; ++i) {
        if (p(i,0)>xMax)
            xMax = p(i,0);
        if (p(i,0)<xMin)
            xMin = p(i,0);
    }
    extremes[0] = xMin;
    extremes[1] = xMax;
    
    ULONG ne = mxGetM(elemx);
    facets_bbx = new double[ne*6];
    double *ele = mxGetPr(elemx);
    for (ULONG i=0; i<ne; ++i) {
        ULONG n1=(ULONG)(ele(i,0));
        ULONG n2=(ULONG)(ele(i,1));
        ULONG n3=(ULONG)(ele(i,2));
        double tmp;
        for (ULONG j=0; j<3; ++j) {
            tmp = std::min(p(n1-1,j),p(n2-1,j));
            //facets_bbx[i][j] = std::min(tmp,p(n3-1,j));
            facets_bbx(i,j) = std::min(tmp,p(n3-1,j));
            tmp = std::max(p(n1-1,j),p(n2-1,j));
            //facets_bbx[i][j+3] = std::max(tmp,p(n3-1,j));
            facets_bbx(i,j+3) = std::max(tmp,p(n3-1,j));
        }
    }
}
std::vector< std::vector<int> > core(std::vector<std::string>&surface_fnames) {
    int c = 0;
    CFileOperation myfile;

    int NumberOfDomains = (int) surface_fnames.size();
    Polyhedron2BSP *tree = new Polyhedron2BSP[NumberOfDomains];
    std::vector< std::vector<int> > relations(NumberOfDomains);

    for (int i=0; i<NumberOfDomains; ++i) {
        int j = tree[i].ReadPolyhedronFromFile(surface_fnames[i]);
        if (j!=0) {
            mexPrintf("surface_relations_mex: Could not read one of the input files!\n");
//          delete [] tree;
            return relations;
        }
        tree[i].SetSplitType(1); // Full scoring system
    }


    std::vector<BSPNode *> root;
    root.resize(NumberOfDomains);
    mexPrintf("Constructiong the BSP tree... ");
    double tic = CPU_TIME;
    for (int i=0; i<NumberOfDomains; ++i) {
        root[i] = tree[i].GetBSP_SolidLeaf_no_split();
    }
    double toc = CPU_TIME;
    mexPrintf("done (time: %.12g).\n",(toc-tic)/(double)CLOCKS_PER_SEC);

    std::ofstream ofs;
    std::string outfn("surface_relations.txt");
    std::vector<int> foo1, foo2;

    int mymax;
    std::vector<int> rank(NumberOfDomains,0);
    std::vector<bool> idxmarker(NumberOfDomains,false);
    std::vector< std::vector<int> >::iterator ite;

    bool allin_flag = true, inflag = false, loopflag = true;;
    
    //~ relations.assign(NumberOfDomains,0);
    std::vector<int> foo;
    for (int i=0; i<NumberOfDomains; ++i) {
        double foothk = tree[i].GetPlaneThickness();
        for (int j=0; j<NumberOfDomains; ++j) {
            if (i==j) continue;
            for (ULONG ii=0; ii<tree[j]._points.size(); ++ii) {
                Point P = *(tree[j]._points[ii]);
                int ret = tree[i].IsInside(P, foothk);
                if (ret == 0) {
                    allin_flag = false;
                    // break;
                }
                else if (ret == 1 || ret == 2) {
                    inflag = true;
                }
            }
            if (allin_flag == false && inflag == true) { // intersection surfaces, not suitable for BEM
                mexPrintf("  Warning!\n");
                mexPrintf("   This set of surfaces can not be used in BEM formulation!\n");
                mexPrintf("   Reason: they are NOT mutually exclusive sub-surfaces!\n\n");
                allin_flag = true; inflag = false;
                relations.clear();
                goto exit;
            }
            else if (allin_flag == true) {
                //std::cout << "just before bug" << std::endl;
                if (relations[i].size())
                    foo = relations[i];
                else
                    foo.clear();
                    
                foo.push_back(j);
                relations[i] = foo;
                inflag = false;
            }
            else if (allin_flag == false && inflag == false) {
                allin_flag = true;
            }
        }
    }
    // Sort the relations vector based on number of childern (max to min)
    c=0;
    while (loopflag) {
        loopflag = false;
        for (int i=0; i<relations.size(); ++i) {
            if (idxmarker[i]==true)
                continue;
            else {
                mymax = i;
                loopflag = true;
            }
            for (int j=i+1; j<relations.size(); ++j) {
                if (idxmarker[j]==true)
                    continue;
                if (relations[j].size() > relations[mymax].size())
                    mymax = j;
            }
            idxmarker[mymax]=true;
            rank[c] = mymax;
            ++c;
        }
    }

    for (int i=0; i<relations.size()-1; ++i) {
        foo1 = relations[rank[i]];
        for (int j=i+1; j<relations.size(); ++j) {
            foo2 = relations[rank[j]];
            for (int ii=0; ii<foo2.size(); ++ii) {
                for (std::vector<int>::iterator jj=foo1.begin(); jj!=foo1.end(); ++jj) {
                    if (foo2[ii]==*jj) {
                        foo1.erase(jj);
                        relations[rank[i]] = foo1;
                        break;
                    }
                }
            }
        }
    }
    
    myfile.OpenOutFile(ofs,outfn,"text");
    c=1;
    // Write a text file explaining the relationships between surfaces
    for (int i=0; i<NumberOfDomains; ++i) {
        foo1 = relations[rank[i]];
        ofs << rank[i] + 1;
        if (!foo1.empty()) {
            for (int j=0; j<foo1.size(); ++j) {
                ofs << ' ' << foo1[j] + 1;
            }
            ofs << std::endl;
        }
        else {
            ofs << " 0" << std::endl;
        }
    }
    ofs.close();
    
exit:
    for (int i=0; i<NumberOfDomains; ++i) {
        tree[i].DeleteTree();
    }
    root.clear();
    
    return relations;
}

