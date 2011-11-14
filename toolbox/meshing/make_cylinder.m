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
x(1) = 0;
y(1) = 0;
z(1) = 0;
i=2;
mesh.bndvtx=[];

if exist('surf','var') && surf == 1
    delta = sizevar.dist;
    h = sizevar.height;
    ri = sizevar.r;
    
    hi = 0-h/2:delta:h/2;
    hmax = hi(end); hmin = -h/2;
    hi = hi(2:end-1);
    thi=0:2*3.1415/floor(2*3.1415*ri/sizevar.dist):2*3.141;
    [theta, R, Z] = ndgrid(thi, ri, hi);
    [x y z] = pol2cart(theta, R, Z);
    x = x(:); y = y(:); z = z(:);
    
    clear theta;
    i = 1;
    for ri=sizevar.dist:sizevar.dist:sizevar.r
        for thi=0:2*3.1415/floor(2*3.1415*ri/sizevar.dist):2*3.141
            r(i) = ri; theta(i) = thi;
            i = i + 1;
        end
    end
    [t1 t2 t3] = pol2cart(theta, r, ones(1,length(r))*hmax);
    x = [x; t1']; y = [y; t2']; z = [z; t3'];
    [t1 t2 t3] = pol2cart(theta, r, ones(1,length(r))*hmin);
    x = [x; t1']; y = [y; t2']; z = [z; t3'];
    
    mesh.bndvtx = ones(length(x),1);
    x = x + sizevar.xc;
    y = y + sizevar.yc;
    z = z + sizevar.zc;
    mesh.nodes(:,1) = x(:);
    mesh.nodes(:,2) = y(:);
    mesh.nodes(:,3) = z(:);
    mesh.elements = MyRobustCrust(mesh.nodes);
    mesh.elements = FixPatchOrientation(mesh.nodes,mesh.elements,[],1);
else
    for hi=0-sizevar.height/2:sizevar.dist:sizevar.height/2
        for ri=sizevar.dist:sizevar.dist:sizevar.r
            for thi=0:2*3.1415/floor(2*3.1415*ri/sizevar.dist):2*3.141       
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
    mesh.nodes = mesh.nodes(mesh.bndvtx==1,:);
    mesh.elements = MyRobustCrust(mesh.nodes);
    if isfield(sizevar,'outputfn')
        outputdir = fileparts(sizevar.outputfn);
    else
        outputdir = pwd;
    end
    
    writenodelm_nod_elm([outputdir filesep 'test_node_ele'],mesh.elements,mesh.nodes);
    mesh = checkerboard3d_mm([outputdir filesep 'test_node_ele.ele'],'stnd');
end

