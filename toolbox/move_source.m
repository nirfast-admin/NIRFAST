function mesh=move_source(mesh,mus_eff,w)

% mesh=move_source(mesh,mus_eff,w)
%
% This function moves the source location to make sure that it:
% (a) falls on the boundary and
% (b) it is moved one scattering distance (mus_eff) within the outer boundary
% Used as part of load_mesh and femdata program
% WARNING Assumes covex hull meshes!!
% 
% mesh is the input mesh (workspace variable)
% mus_eff is the scattering distance
% w is the distance for averaging scattering distance



% To start with, make sure the mesh is centered at [0 0 0]
x = (min(mesh.nodes(:,1)) + max(mesh.nodes(:,1)))/2;
y = (min(mesh.nodes(:,2)) + max(mesh.nodes(:,2)))/2;
z = (min(mesh.nodes(:,3)) + max(mesh.nodes(:,3)))/2;
mesh.nodes(:,1) = mesh.nodes(:,1) - x;
mesh.nodes(:,2) = mesh.nodes(:,2) - y;
mesh.nodes(:,3) = mesh.nodes(:,3) - z;

% apply same transformation to source positions
mesh.source.coord(:,1) = mesh.source.coord(:,1) - x;
mesh.source.coord(:,2) = mesh.source.coord(:,2) - y;
if mesh.dimension == 3
  mesh.source.coord(:,3) = mesh.source.coord(:,3) - z;
end

[nsource,msource]=size(mesh.source.coord);
for i = 1 : nsource
  if mesh.dimension == 2
    % distance of each boundary nodes from source
    dist = distance(mesh.nodes,mesh.bndvtx,[mesh.source.coord(i,:) 0]);
    % index of nearest boundary node
    r0_ind = find(dist==min(dist));
    r0_ind = r0_ind(1);
    % radius of nearest boundary node
    [th,r0]=cart2pol(mesh.nodes(r0_ind,1),mesh.nodes(r0_ind,2));
    % angle of source point
    [th1,r1]=cart2pol(mesh.source.coord(i,1),mesh.source.coord(i,2));
    % mean scatter value of where source will be
    dist = distance(mesh.nodes,ones(length(mesh.bndvtx),1),...
		    [mesh.nodes(r0_ind,1) ...
		     mesh.nodes(r0_ind,2) ...
		     mesh.nodes(r0_ind,3)]);
    scat_dist = 1./mean(mus_eff(dist<=w));
    % Corrected position
    [mesh.source.coord(i,1),...
     mesh.source.coord(i,2)] = pol2cart(th,r0-scat_dist);

  elseif mesh.dimension == 3
    % distance of each boundary nodes from source
    dist = distance(mesh.nodes,mesh.bndvtx,mesh.source.coord(i,:));
    % index of nearest boundary node
    r0_ind = find(dist==min(dist));
    r0_ind = r0_ind(1);
    % radius of nearest boundary node
    [th,phi,r0]=cart2sph(mesh.nodes(r0_ind,1),...
			 mesh.nodes(r0_ind,2),...
			 mesh.nodes(r0_ind,3));
    % angle of source point
    [th1,phi,r1]=cart2sph(mesh.source.coord(i,1),...
			 mesh.source.coord(i,2),...
			 mesh.source.coord(i,3));
    % mean scatter value of where source will be
    dist = distance(mesh.nodes,ones(length(mesh.bndvtx),1),...
		    [mesh.nodes(r0_ind,1) ...
		     mesh.nodes(r0_ind,2) ...
		     mesh.nodes(r0_ind,3)]);
    if isscalar(mus_eff) % for BEM you only have one value
        scat_dist = 1/mus_eff;
    else
        scat_dist = 1./mean(mus_eff(find(dist<=w)));
    end
    % Corrected position
    [mesh.source.coord(i,1),...
     mesh.source.coord(i,2),...
     mesh.source.coord(i,3)] = sph2cart(th,phi,r0-scat_dist);
  end
end

% Re-transform mesh back to original coordinates
mesh.nodes(:,1) = mesh.nodes(:,1) + x;
mesh.nodes(:,2) = mesh.nodes(:,2) + y;
mesh.nodes(:,3) = mesh.nodes(:,3) + z;

% apply same transformation to source positions
mesh.source.coord(:,1) = mesh.source.coord(:,1) + x;
mesh.source.coord(:,2) = mesh.source.coord(:,2) + y;
if mesh.dimension == 3
  mesh.source.coord(:,3) = mesh.source.coord(:,3) + z;
end
