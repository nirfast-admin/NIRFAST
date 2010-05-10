function [mesh2pixel,pixel] = pixel_basis(numpix,mesh)

% [mesh2pixel,pixel] = pixel_basis(numpix,mesh)
%
% Calculates pixel basis for reconstruction
% 
% numpix is the number of pixels
% mesh is the input mesh (workspace variable)
% mesh2pixel is the interpolation function
% pixel is the result


% error checking
if size(numpix,2) ~= mesh.dimension
    errordlg('The pixel basis must be equal in size to the mesh dimension; e.g. [30 30] for 2D, [30 30 20] for 3D','NIRFAST Error');
    error('The pixel basis must be equal in size to the mesh dimension; e.g. [30 30] for 2D, [30 30 20] for 3D');
end

% trap to do non-region based pixelization
[nr,nc]=size(numpix);
if nr == 1
  region_tmp = mesh.region;
  mesh.region(:) = 0;
end

% Trap to make sure number of pixels agree with number of regions
% and mesh dimensions.
[nr,nc]=size(numpix);
if nr > 1
  if nr ~= numel(unique(mesh.region)) | nc ~= mesh.dimension
    out = sprintf([' Number of regions and pixel specifications\n OR\n' ...
		   ' mesh dimension is not compatible']);
    disp(out);
    mesh2pixel = [];
    pixel = [];
    return
  end
end
clear nr nc

% find unique regions
region = unique(mesh.region);

% set pixel.nodes array
pixel.nodes = [];
pixel.region = [];

% loop through each region
for i  = 1 : length(region)
  % find nodes in each region
  nodes = mesh.nodes(find(mesh.region==region(i)),:);
  
  % Create uniform grid
  xmax = max(nodes(:,1));
  xmin = min(nodes(:,1));   
  xstep=(xmax-xmin)/(numpix(i,1)-1);
  
  ymax = max(nodes(:,2));
  ymin = min(nodes(:,2));   
  ystep=(ymax-ymin)/(numpix(i,2)-1);
  
  if mesh.dimension == 2
    % Creating a grid
    [X,Y]=meshgrid(xmin:xstep:xmax,...
		   ymin:ystep:ymax);
    [nx,ny]=size(X);
    nodes = [reshape(X,nx*ny,1) ...
	     reshape(Y,nx*ny,1)];
    clear nx ny X Y
    % Find where new nodes fall
    [index] = mytsearchn(mesh,...
		       nodes(:,1:2));  
    
  elseif mesh.dimension == 3
    zmax = max(nodes(:,3));
    zmin = min(nodes(:,3));   
    zstep=(zmax-zmin)/(numpix(i,3)-1);
    
    [X,Y,Z]=meshgrid(xmin:xstep:xmax,...
		     ymin:ystep:ymax,...
		     zmin:zstep:zmax);
    [nx,ny,nz]=size(X);
    nodes = [reshape(X,nx*ny*nz,1) ...
	     reshape(Y,nx*ny*nz,1) ...
	     reshape(Z,nx*ny*nz,1)];
    clear nx ny nz X Y Z
    [index] = mytsearchn(mesh,...
		       nodes(:,1:3));
  end  
  
  % find nodes that fall into current region
  r = ones(size(index)).*-1;
  ind = find(isnan(index)==0);
  r(ind) = mode(mesh.region(mesh.elements(index(ind,1),:))');
  
  index = find(r==region(i));
  nodes = nodes(index,:);
  
  pixel.nodes = [pixel.nodes; nodes];
  [nr,nc]=size(nodes);
  pixel.region = [pixel.region; ones(nr,1).*region(i)];
  out = sprintf('Number of nodes in Region %d is = %d',...
		region(i),nr);
  disp(out);
  
end

% create elements for new pixel basis
if mesh.dimension == 2
  pixel.elements = delaunayn(pixel.nodes(:,1:2));
elseif mesh.dimension == 3
  pixel.elements = delaunayn(pixel.nodes);
end

if mesh.dimension == 2
  [index,intfunc] = mytsearchn(mesh,...
			     pixel.nodes(:,1:2));
elseif mesh.dimension == 3
  [index,intfunc] = mytsearchn(mesh,...
			     pixel.nodes(:,1:3));
end

% find interpolation functions
mesh2pixel = [index intfunc];
mesh2pixel(find(isnan(mesh2pixel(:,1))==1),:) = 0;

if mesh.dimension == 2
    pixel.dimension = 2;
  [index,intfunc] = mytsearchn(pixel,...
			     mesh.nodes(:,1:2));
elseif mesh.dimension == 3
    pixel.dimension = 3;
  [index,intfunc] = mytsearchn(pixel,...
			     mesh.nodes(:,1:3));
end

% make sure that all nodes do fall onto the other mesh
ind_out = find(isnan(index)==1);
for i = 1 : length(ind_out)
  dist = distance(mesh.nodes,...
		  ones(length(mesh.nodes),1),...
		  mesh.nodes(ind_out(i),:));
  dist(ind_out) = 1000;
  n = find(dist==min(dist));n = n(1);
  index(ind_out(i)) = index(n);
  intfunc(ind_out(i),:) = intfunc(n,:);
end

pixel.coarse2fine = [index intfunc];

if mesh.dimension == 2
  pixel.nodes(:,3) = 0;
end
