function qvec = gen_source_adjoint(mesh)

% qvec = gen_source_adjoint(mesh)
%
% Calculates the RHS for adjoint source.
% 
% mesh is the input mesh
% qvec is the RHS



% Allocate memory
[nnodes,junk]=size(mesh.nodes);
[nmeas,junk]=size(mesh.meas.coord);
qvec = spalloc(nnodes,nmeas,nmeas*5);

% Go through all measurements and integrate to get nodal values
for i = 1 : nmeas
  qvec(mesh.elements(mesh.meas.int_func(i,1),:),i) = ...
      mesh.meas.int_func(i,2:end)' .* ...
      complex(cos(0.15),sin(0.15));
end
