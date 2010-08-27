function phi = solve_pardiso(MASS,qvec,solvertype)
% phi = solve_pardiso(MASS,qvec,solvertype) solves a complex, non-symmetric
% system of linear equations with multiple RHS terms using the matlab interface
% of UBasel's PARDISO solver library. MASS is the sparse system matrix, qvec 
% is the sparse RHS matrix and phi is a sparse solution. solvertype should 
% be 0 for direct solve and 1 for iterative solve. 
%
% Visit www.pardiso-project.org for more details on the solver.
%
% venkat krishnaswamy, 08/27/2010

%nc=System.Environment.ProcessorCount;
%system(['export OMP_NUM_THREADS =' num2str(nc)]);

fullqvec = full(qvec); %NIRFAST stores the RHS matrix as sparse but PARDISO wants it as full
info = pardisoinit(13,solvertype);

% set num of comp threads explicitly to workaround some situations where
% OMP_NUM_THREADS is not honored
info.iparm(3) = 8;
 
info = pardisoreorder(MASS,info,false);
[fullphi, info] = pardisosolve(MASS,fullqvec,info,false);
phi = sparse(fullphi); %PARDISO will return a full solution matrix but NIRFAST wants it sparse

pardisofree(info);
clear info;
