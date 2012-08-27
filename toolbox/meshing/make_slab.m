function mesh = make_slab(sizevar,surf)

% mesh = make_slab(sizevar)
%  
% Creates a 3D slab mesh
%
% sizevar.width - width
% sizevar.height - height
% sizevar.depth - depth
% sizevar.xc - x center
% sizevar.yc - y center
% sizevar.zc - z center
% sizevar.dist - distance between nodes
% surf - optional, if 1 surface mesh is created


% error checking
if ~isfield(sizevar,'xc') || ~isfield(sizevar,'yc') || ~isfield(sizevar,'height') ...
       || ~isfield(sizevar,'width') || ~isfield(sizevar,'dist') || ...
       ~isfield(sizevar,'depth') || ~isfield(sizevar,'zc')
    errordlg('Missing input(s) for slab creation','NIRFAST Error');
    error('Missing input(s) for slab creation');
end
if sizevar.width <= 0
    errordlg('Width must be positive','NIRFAST Error');
    error('Width must be positive');
end
if sizevar.height <= 0
    errordlg('Height must be positive','NIRFAST Error');
    error('Height must be positive');
end
if sizevar.depth <= 0
    errordlg('Depth must be positive','NIRFAST Error');
    error('Depth must be positive');
end
if sizevar.dist <= 0
    errordlg('Distance between nodes must be positive','NIRFAST Error');
    error('Distance between nodes must be positive');
end

h = waitbar(0,'Creating boundary nodes');

xmin = sizevar.xc-sizevar.width/2;
xmax = sizevar.xc+sizevar.width/2;
ymin = sizevar.yc-sizevar.height/2;
ymax = sizevar.yc+sizevar.height/2;
zmin = sizevar.zc-sizevar.depth/2;
zmax = sizevar.zc+sizevar.depth/2;

[x,y,z]=meshgrid(xmin:sizevar.dist:xmax,ymin:sizevar.dist:ymax,zmin:sizevar.dist:zmax);

nn = numel(x);
mesh.nodes(:,1) = reshape(x,nn,1);
mesh.nodes(:,2) = reshape(y,nn,1);
mesh.nodes(:,3) = reshape(z,nn,1);

ind1 = find(mesh.nodes(:,1)==xmin);
ind2 = find(mesh.nodes(:,1)>xmax-sizevar.dist);
ind3 = find(mesh.nodes(:,2)==ymin);
ind4 = find(mesh.nodes(:,2)>ymax-sizevar.dist);
ind5 = find(mesh.nodes(:,3)==zmin);
ind6 = find(mesh.nodes(:,3)>zmax-sizevar.dist);

ind = unique([ind1; ind2; ind3; ind4; ind5; ind6]);
mesh.bndvtx = zeros(nn,1);
mesh.bndvtx(ind) = 1;

if isfield(sizevar,'outputfn') && ~isempty(sizevar.outputfn)
    outputdir = fileparts(sizevar.outputfn);
    outputfn = sizevar.outputfn;
else
    outputdir = pwd;
    outputfn = fullfile(outputdir,'_slab_');
end

waitbar(0.1,h,'Creating surface');

if exist('surf','var') && surf == 1
    mesh.nodes = mesh.nodes(mesh.bndvtx==1,:);
    mesh.bndvtx = ones(size(mesh.nodes,1),1);
    mesh.elements = MyRobustCrust(mesh.nodes);
    mesh.elements = FixPatchOrientation(mesh.nodes,mesh.elements,[],1);
else
    mesh.nodes = mesh.nodes(mesh.bndvtx==1,:);
    mesh.elements = MyRobustCrust(mesh.nodes);
    
    writenodelm_nod_elm(fullfile(outputdir,'test_node_ele'),mesh.elements,mesh.nodes);
    waitbar(0.6,h,'Creating volume');
    mesh = checkerboard3d_mm(fullfile(outputdir,'test_node_ele.ele'),...
        'stnd',[],[],outputfn);
    delete(fullfile(outputdir,'test_node_ele.node'),...
        fullfile(outputdir,'test_node_ele.ele'));
end

waitbar(1.0,h,'Done');
close(h);