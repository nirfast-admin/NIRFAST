function mesh=move_detector(mesh)

% mesh=move_detector(mesh)
%
% This function moves the detector location to make sure that it:
% (a) falls on the boundary and
% (b) it is just inside the boundary
% Used as part of load_mesh program
% 
% mesh is the input mesh (workspace variable)


% To start with, make sure the mesh is centered at [0 0 0]
x = (min(mesh.nodes(:,1)) + max(mesh.nodes(:,1)))/2;
y = (min(mesh.nodes(:,2)) + max(mesh.nodes(:,2)))/2;
z = (min(mesh.nodes(:,3)) + max(mesh.nodes(:,3)))/2;
mesh.nodes(:,1) = mesh.nodes(:,1) - x;
mesh.nodes(:,2) = mesh.nodes(:,2) - y;
mesh.nodes(:,3) = mesh.nodes(:,3) - z;

% apply same transformation to detector positions
mesh.meas.coord(:,1) = mesh.meas.coord(:,1) - x;
mesh.meas.coord(:,2) = mesh.meas.coord(:,2) - y;
if mesh.dimension == 3
  mesh.meas.coord(:,3) = mesh.meas.coord(:,3) - z;
end

[nmeas,mmeas]=size(mesh.meas.coord);
for i = 1 : nmeas
  if mesh.dimension == 2
    % distance of each boundary nodes from source
    dist = distance(mesh.nodes,mesh.bndvtx,[mesh.meas.coord(i,:) 0]);
    % index of nearest boundary node
    r0_ind = find(dist==min(dist));
    r0_ind = r0_ind(1);
    % radius of nearest boundary node
    %[th,r0]=cart2pol(mesh.nodes(r0_ind,1),mesh.nodes(r0_ind,2));
    % angle of source point
    %[th,r1]=cart2pol(mesh.meas.coord(i,1),mesh.meas.coord(i,2));
    % Corrected position
    mesh.meas.coord(i,1:2) = mesh.nodes(r0_ind,1:2);
    
  elseif mesh.dimension == 3
    % distance of each boundary nodes from source
    dist = distance(mesh.nodes,mesh.bndvtx,mesh.meas.coord(i,:));
    % index of nearest boundary node
    r0_ind = find(dist==min(dist));
    r0_ind = r0_ind(1);
    % radius of nearest boundary node
    %[th,phi,r0]=cart2sph(mesh.nodes(r0_ind,1),...
	%		 mesh.nodes(r0_ind,2),...
	%		 mesh.nodes(r0_ind,3));
    % angle of source point
    %[th,phi,r1]=cart2sph(mesh.meas.coord(i,1),...
	%		 mesh.meas.coord(i,2),...
	%		 mesh.meas.coord(i,3));
    % Corrected position
     mesh.meas.coord(i,:) = mesh.nodes(r0_ind,:);
  end
end

% Now make sure they all fall just inside!
if mesh.dimension == 2
  [ind,int_func] = mytsearchn(mesh,mesh.meas.coord(:,1:2));
  if any(isnan(ind)) == 1
    for j = 0.999 : -0.001 : 0.99
      ind = find(isnan(ind)==1);
      mesh.meas.coord(ind,:) = mesh.meas.coord(ind,:).*j;
      [ind,int_func] = mytsearchn(mesh,mesh.meas.coord(:,1:2));
      if any(isnan(ind)) == 0
	break
      end
    end
  end    
elseif mesh.dimension == 3
  [ind,int_func] = mytsearchn(mesh,mesh.meas.coord);
  if any(isnan(ind)) == 1
    for j = 0.999 : -0.001 : 0.99
      ind = find(isnan(ind)==1);
      mesh.meas.coord(ind,:) = mesh.meas.coord(ind,:).*j;
      [ind,int_func] = mytsearchn(mesh,mesh.meas.coord);
      if any(isnan(ind)) == 0
	break
      end
    end
  end
end

% Re-transform mesh back to original coordinates
mesh.nodes(:,1) = mesh.nodes(:,1) + x;
mesh.nodes(:,2) = mesh.nodes(:,2) + y;
mesh.nodes(:,3) = mesh.nodes(:,3) + z;

% apply same transformation to detector positions
mesh.meas.coord(:,1) = mesh.meas.coord(:,1) + x;
mesh.meas.coord(:,2) = mesh.meas.coord(:,2) + y;
if mesh.dimension == 3
  mesh.meas.coord(:,3) = mesh.meas.coord(:,3) + z;
end

% set mesh array variable with the interpolation functions
% calculated above to get the boundary measuremets
mesh.meas.int_func = [ind int_func];
