function data = get_boundary_data(mesh,phi)

% data = get_boundary_data(mesh,phi)
%
% Used by femdata and Jacobian
% Calculates boundary data based on detector positions, mesh.meas 
% and the calculated field
% uses mesh.meas_int_func as calculated using move_detector.m
% 
% mesh is the input mesh
% phi is the field
% data is the boundary data



if isfield(mesh.meas,'int_func') == 0
   errordlg('Need to call move_detector on the mesh first','NIRFAST Error');
   error('Need to call move_detector on the mesh first');
else

  % We don't want contributions from internal nodes on boundary
  % values
  bnd_val = mesh.bndvtx(mesh.elements(mesh.meas.int_func(:,1),:));
  [nrow,ncol]=size(bnd_val);
  for i = 1 : nrow
    for j = 1 : ncol
      if bnd_val(i,j) == 0
	mesh.meas.int_func(i,j+1) = 0;
	% make sure the integral is unity here!
	mesh.meas.int_func(i,2:end) = ...
	    1./sum(mesh.meas.int_func(i,2:end)) .* ...
	    mesh.meas.int_func(i,2:end);
      end
    end
  end
  [junk,nsource]=size(phi);
  
  data = zeros(length(find(mesh.link~=0)),1);
  k = 1;
  for i = 1 : nsource
    for j = 1 : length(mesh.link(i,:))
      if mesh.link(i,j) ~= 0
	jj = mesh.link(i,j);
	vtx_ind = mesh.elements(mesh.meas.int_func(jj,1),:);
	data(k) = mesh.meas.int_func(jj,2:end)*phi(vtx_ind,i);
	k = k + 1;
      end
    end
  end
end
