function mesh = make_cylinder(sizevar,surf)

% mesh = make_cylinder(sizevar)
%
% Creates a 3D cylindrical mesh
%
% sizevar.xc - x coordinate of the center
% sizevar.yc - y coordinate of the center
% sizevar.zc - z coordinate of the center
% sizevar.r - radius
% sizevar.height - height
% sizevar.dist - distance between nodes
% surf - optional, if 1 surface mesh is created


% error checking
if ~isfield(sizevar,'xc') || ~isfield(sizevar,'yc') || ~isfield(sizevar,'height') ...
       || ~isfield(sizevar,'zc') || ~isfield(sizevar,'r') || ~isfield(sizevar,'dist')
    errordlg('Missing input(s) for cylinder creation','NIRFAST Error');
    error('Missing input(s) for cylinder creation');
end
if sizevar.r <= 0
    errordlg('Radius must be positive','NIRFAST Error');
    error('Radius must be positive');
end
if sizevar.dist <= 0
    errordlg('Distance between nodes must be positive','NIRFAST Error');
    error('Distance between nodes must be positive');
end
if sizevar.height <= 0
    errordlg('Height must be positive','NIRFAST Error');
    error('Height must be positive');
end

x=[];
y=[];
z=[];
i=1;
mesh.bndvtx=[];
for hi=0-sizevar.height/2:sizevar.dist:sizevar.height/2
    for ri=sizevar.dist:sizevar.dist:sizevar.r
        for thi=sizevar.dist/ri:sizevar.dist/ri:2*3.1415926        
            [x(i),y(i),z(i)] = pol2cart(thi,ri,hi);
            if (hi == 0-sizevar.height/2) || (hi + sizevar.dist > sizevar.height/2) || (ri+sizevar.dist>sizevar.r)
                mesh.bndvtx(i) = 1;
            else
                mesh.bndvtx(i) = 0;
            end
            i = i + 1;          
        end
    end
end
nn = numel(x);

mesh.bndvtx=mesh.bndvtx';
x = x + sizevar.xc;
y = y + sizevar.yc;
z = z + sizevar.zc;
mesh.nodes(:,1) = x;
mesh.nodes(:,2) = y;
mesh.nodes(:,3) = z;

if exist('surf','var') && surf == 1
    mesh.nodes = mesh.nodes(mesh.bndvtx==1,:);
    mesh.bndvtx = ones(size(mesh.nodes,1),1);
    mesh.elements = MyRobustCrust(mesh.nodes);
    mesh.elements = FixPatchOrientation(mesh.nodes,mesh.elements);
else
    mesh.nodes = mesh.nodes(mesh.bndvtx==1,:);
    mesh.elements = MyRobustCrust(mesh.nodes);
    writenodelm_nod_elm('test_node_ele',mesh.elements,mesh.nodes);
    mesh = checkerboard3d_mm('test_node_ele.ele','stnd');
end
