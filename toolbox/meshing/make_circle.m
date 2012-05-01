function mesh = make_circle(sizevar)

% mesh = make_circle(sizevar)
%
% Creates a 2D circular mesh
%
% sizevar.xc - x coordinate of the center
% sizevar.yc - y coordinate of the center
% sizevar.r - radius
% sizevar.dist - distance between nodes


% error checking
if ~isfield(sizevar,'xc') || ~isfield(sizevar,'yc') ...
        || ~isfield(sizevar,'r') || ~isfield(sizevar,'dist')
    errordlg('Missing input(s) for circle creation','NIRFAST Error');
    error('Missing input(s) for circle creation');
end
if sizevar.r <= 0
    errordlg('Radius must be positive','NIRFAST Error');
    error('Radius must be positive');
end
if sizevar.dist <= 0
    errordlg('Distance between nodes must be positive','NIRFAST Error');
    error('Distance between nodes must be positive');
end

h = waitbar(0,'Creating nodes');

x=[];
y=[];
x(1) = 0;
y(1) = 0;
i=2;
for ri=sizevar.dist:sizevar.dist:sizevar.r
    s=0;
    for thi=0:2*3.1415/floor(2*3.1415*ri/sizevar.dist):2*3.141
        [x(i),y(i)] = pol2cart(thi,ri);
        i = i + 1;
        s=s+1;
    end
end
nn = numel(x);
x = x + sizevar.xc;
y = y + sizevar.yc;
mesh.nodes(:,1) = x;
mesh.nodes(:,2) = y;

mesh.bndvtx = zeros(nn,1);
mesh.bndvtx(end-s+1:end) = 1;

waitbar(0.1,h,'Creating elements');

mesh.elements = delaunayn(mesh.nodes);

mesh.nodes(:,3) = zeros(length(x),1);

waitbar(1.0,h,'Done');
close(h);