function phi = solve_pardiso(MASS,qvec,solvertype)
% phi = solve_pardiso(MASS,qvec,solvertype) solves a complex, non-symmetric
% system of linear equations with multiple RHS terms using a mex'd version
% of UBasel's PARDISO solver library. MASS is the sparse
% system matrix, qvec is the sparse RHS matrix and phi is a sparse
% solution. solvertype should be 0 for direct solve and 1 for iterative
% solve. Visit www.pardiso-project.org for more details on the solver.
% nirfast_pardiso_readme.txt has details on how to setup the linux
% environment to run the solver through matlab.
%
% venkat krishnaswamy, 08/25/2010

%nc=System.Environment.ProcessorCount;
%system(['export OMP_NUM_THREADS =' num2str(nc)]);

fullqvec = full(qvec); %NIRFAST stores the RHS matrix as sparse but PARDISO wants it as full
info = pardisoinit(13,solvertype);
info = pardisoreorder(MASS,info,false);
[fullphi, info] = pardisosolve(MASS,fullqvec,info,false);
phi = sparse(fullphi); %PARDISO will return a full solution matrix but NIRFAST wants it sparse
pardisofree(info);
clear info;
