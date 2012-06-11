function mesh = make_rectangle(sizevar)

% mesh = make_rectangle(sizevar)
%  
% Creates a 2D rectangular mesh
%
% sizevar.width - width
% sizevar.height - height
% sizevar.xc - x center
% sizevar.yc - y center
% sizevar.dist - distance between nodes


% error checking
if ~isfield(sizevar,'xc') || ~isfield(sizevar,'yc') || ~isfield(sizevar,'height') ...
       || ~isfield(sizevar,'width') || ~isfield(sizevar,'dist')
    errordlg('Missing input(s) for rectangle creation','NIRFAST Error');
    error('Missing input(s) for rectangle creation');
end
if sizevar.width <= 0
    errordlg('Width must be positive','NIRFAST Error');
    error('Width must be positive');
end
if sizevar.height <= 0
    errordlg('Height must be positive','NIRFAST Error');
    error('Height must be positive');
end
if sizevar.dist <= 0
    errordlg('Distance between nodes must be positive','NIRFAST Error');
    error('Distance between nodes must be positive');
end

h = waitbar(0,'Creating nodes');

xmin = sizevar.xc-sizevar.width/2;
xmax = sizevar.xc+sizevar.width/2;
ymin = sizevar.yc-sizevar.height/2;
ymax = sizevar.yc+sizevar.height/2;

[x,y]=meshgrid(xmin:sizevar.dist:xmax,ymin:sizevar.dist:ymax);
nn = numel(x);
mesh.nodes(:,1) = reshape(x,nn,1);
mesh.nodes(:,2) = reshape(y,nn,1);

ind1 = find(mesh.nodes(:,1)==xmin);
ind2 = find(mesh.nodes(:,1)>xmax-sizevar.dist);
ind3 = find(mesh.nodes(:,2)==ymin);
ind4 = find(mesh.nodes(:,2)>ymax-sizevar.dist);

ind = unique([ind1; ind2; ind3; ind4]);
mesh.bndvtx = zeros(nn,1);
mesh.bndvtx(ind) = 1;

waitbar(0.1,h,'Creating elements');

mesh.elements = delaunayn(mesh.nodes);
[mesh.elements mesh.nodes] = remove_unused_nodes(mesh.elements, mesh.nodes);

mesh.nodes(:,3) = zeros(size(mesh.nodes(:,1)));

waitbar(1.0,h,'Done');
close(h);
