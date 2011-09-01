function mesh = make_sphere(sizevar,surf)

% mesh = make_cylinder(sizevar,surf)
%
% Creates a 3D spherical mesh
%
% sizevar.xc - x coordinate of the center
% sizevar.yc - y coordinate of the center
% sizevar.zc - z coordinate of the center
% sizevar.r - radius
% sizevar.dist - distance between nodes
% surf - optional, if this is 1 only a surface mesh is made


% error checking
if ~isfield(sizevar,'xc') || ~isfield(sizevar,'yc') || ~isfield(sizevar,'zc') ...
        || ~isfield(sizevar,'r') || ~isfield(sizevar,'dist')
    errordlg('Missing input(s) for sphere creation','NIRFAST Error');
    error('Missing input(s) for sphere creation');
end
if sizevar.r <= 0
    errordlg('Radius must be positive','NIRFAST Error');
    error('Radius must be positive');
end
if sizevar.dist <= 0
    errordlg('Distance between nodes must be positive','NIRFAST Error');
    error('Distance between nodes must be positive');
end

x=[];
y=[];
z=[];
i=1;
mesh.bndvtx=[];
for ri=sizevar.dist:sizevar.dist:sizevar.r
    for thi=sizevar.dist/ri:sizevar.dist/ri:2*3.1415926  
        for phii=sizevar.dist/ri-(3.1415926/2):sizevar.dist/ri:(3.1415926/2)-sizevar.dist/ri
            [x(i),y(i),z(i)] = sph2cart(thi,phii,ri);
            if ri + sizevar.dist > sizevar.r
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
    mesh.elements = FixPatchOrientation(mesh.nodes,mesh.elements,[],1);
else
    mesh.nodes = mesh.nodes(mesh.bndvtx==1,:);
    mesh.elements = MyRobustCrust(mesh.nodes);
    writenodelm_nod_elm('test_node_ele',mesh.elements,mesh.nodes);
    mesh = checkerboard3d_mm('test_node_ele.ele','stnd');
end
