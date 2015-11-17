function [mesh_p mesh_e ext_bdy_nodes regions] = ...
                         mask2mesh(I,pixel_dim,edge_size,tri_area)
% [mesh_ele mesh_nodes bdy_nodes] = mask2mesh(I)
% Creates a 2D triangular mesh using the mask info defined in I
% I : input mask (either filename or a grascale image matrix
% pixel_dim : size of each pixel in mm, cm, inches ...
%             has two values, for x and y
% edge_size : size of exterior boundary edges (that contains the whole
% mask)
% tri_area : area of each mesh triangle, this number specifies the maximum
% area that any given triangle in the final mesh would have.
% 
% To control the number of nodes make sure 'edge_size' is reasonable and
% then alter 'tri_area'
%
% The outputs are:
% mesh_e: 'ne' by 3 matrix, 
% mesh_p: nn by 2 matrix, containg node coordinates
% ext_bdy_nodes:  nbdy by 1, indecies to mesh_p matrix identifying the nodes
%             that are sitting on outmost boundary of the mesh.
% mesh_edges: exterior edge connectivity
% mesh : the output of the function:
%        mesh.nodes
%        mesh.elements
%        mesh.regions
% 
% Written by:
%  Hamid R Ghadyani : July 2009
% Modified by:
%  Hamid R Ghadyani : March 2010
% 
% Triangulation program is 'Triangle' written by: 
% Jonathan Richard Shewchuk, Delaunay Refinement Algorithms for Triangular
% Mesh Generation,
% Computational Geometry: Theory and Applications 22(1-3):21-74, May 2002
% http://www.cs.cmu.edu/~quake/triangle.html


%% Based on the test image sent by Josiah, pixel dimension is 0.1923
if nargin==1 || nargin==0
    pixel_dim = [0.1923 0.1923];
    edge_size = 3;
    tri_area = 60;
elseif nargin~=4
    fprintf(['\n  Usage: [mesh_e mesh_p ext_bdy_nodes mesh_edges] = ...' ...
                         'mask2mesh(I,pixel_dim,edge_size,tri_area)\n\n']);
    errordlg(' mask2mesh needs 4 input arguments','Meshing Error');
    error(' mask2mesh needs 4 input arguments');
end

if size(pixel_dim,2)==1
    pixel_dim = [pixel_dim pixel_dim];
end

%% Read in image from file or matrix
if nargin>=1
    if ischar(I)
        a=imread(I);
        [fn ext]=remove_extension(I);
    else
        a=I;
        fn='mask2mesh-output';
    end
else
    [fname, pname, filterindex] = uigetfile({'*.*',...
        'Select Image File '},...
        'Please select an image file',...
                        'MultiSelect','off');
    fname = [pname fname];
    a=imread(fname);
    [fn ext]=remove_extension(fname);
end

if ndims(a)==3
    a=rgb2gray(a);
end

edge_size = edge_size/pixel_dim(1);
mask=flipdim(a,1);

% Create a 2D boundary for the exterior of the mask
foofn = fullfile(tempdir,'image2mesh2D_ext');
[extb_e, extb_p] = GetExteriorBoundary(mask,edge_size);
write_nodelm_poly2d(foofn,extb_e(:,1:2),extb_p(:,1:2));

%% For checking the density of nodes on the exterior boundary you can
%% comment this out
% figure;plotbdy2d(extb_e,extb_p,'r');

% Run mesh generator
syscommand = GetSystemCommand('triangle.exe');
% delete existing mesh files
if exist([foofn '.1.ele'],'file')
    delete([foofn '.1.ele']); 
end
if exist([foofn '.1.node'],'file')
    delete([foofn '.1.node'])
end
% Run the mesh generator
eval(['! "' syscommand '" -pqAa' ...
    num2str(tri_area/pixel_dim(1)) ' "' foofn '.poly" > ' ...
    tempdir filesep 'junk.txt']);
[mesh_e,mesh_p]=read_nod_elm([foofn '.1.'],1);
delete([foofn '.1.ele']);  delete([foofn '.1.node']);

%% Get the nodes on the exterior of the mesh
% the following two variables are not returned and those two lines can be
% commented out
mesh_edges = boundedges(mesh_p, mesh_e(:,1:3));
ext_bdy_nodes = unique([mesh_edges(:,1); mesh_edges(:,2)]);

mesh.nodes = mesh_p;
mesh.elements = mesh_e(:,1:3);
mesh.region = GetNodeRegions(mesh,mask);
mesh.nodes(:,1) = mesh.nodes(:,1) * pixel_dim(1);
mesh.nodes(:,2) = mesh.nodes(:,2) * pixel_dim(2);

mesh_p = mesh.nodes;
mesh_e = mesh_e(:,1:3);
regions = mesh.region;
% Plot the mesh
% figure;
% trisurf(mesh.elements,mesh.nodes(:,1),mesh.nodes(:,2),double(mesh.region))
% colormap(cool); view(2); shading interp;
















function [extb_e, extb_p] = GetExteriorBoundary(mask,edge_size)
mask(mask ~= 0) = 1;
C=contourc(double(mask),1);
idx=1;
startidx=2;
totalnodes=0;
p=[];
ele=[];
flag=true;
counter=1;

while flag
    endidx=startidx+C(2,idx)-1-1;
    mat = C(1,idx);
    totalnodes=totalnodes+C(2,idx)-1;
    for i=startidx:endidx
        temp=C(:,i);
        p=[p;temp'];
        if i~=startidx
            ele(counter,1)=counter-1;
        elseif i==startidx
           ele(counter,1)=totalnodes;
        end
        ele(counter,2)=counter;
        counter=counter+1;
    end
    if i+1==size(C,2)
        flag=false;
    else
        idx=i+1+1;
        startidx=idx+1;
    end
end
[extb_e extb_p]=create_nodes_perimeter(ele(:,1:2),p(:,1:2),edge_size);

function regions = GetNodeRegions(mesh,mask)
%%
nodes = mesh.nodes;
regs = int32(unique(mask));
foo = mask;
tmp1 = zeros(size(nodes,1),1,'int32');
tmp2 = tmp1;
regions = tmp1;
for i=2:length(regs) % ignore region whose ID is 0
    bf = mask == regs(i);
    mask(~bf) = 0;
    B = getBDYfromContour(mask,regs(i));
    for j = 1:length(B)
        bb = B{j};
        clear mex
        IN = pnpoly_mex(bb(:,1),bb(:,2),nodes(:,1),nodes(:,2));
        tmp1 = tmp1 + int32(IN);
    end
    bf = (mod(tmp1,2)==1);
    regions(bf) = regs(i);
    mask = foo;
    tmp1 = tmp2;
end

bf = regions == 0;
if sum(bf) ==0, return; end
elm = mesh.elements(:,1:3);
changed = false;
while true
    for i=1:size(elm,1)
        
            foo = bf(elm(i,:));
            if all(~foo)
                continue;
            elseif all(foo)
                continue
            else
                val=max(regions(elm(i,:)));
                for j=1:3
                    if foo(j)
                        regions(elm(i,j)) = val;
                        bf(elm(i,j)) = false;
                    end
                end
                changed=true;
            end

    end
    if ~changed
        break
    else
        changed = false;
    end
end
if sum(bf)~=0
    error('Can''t determine the node region');
end


function B = getBDYfromContour(mask,lvlval)

B={};

bf = mask==lvlval;
mask(~bf)=0;

c=contourc(double(mask),1);

idx=1;
counter = 1;
while idx<size(c,2)
    c(1,idx) = lvlval; % assign the material code as contour value
    endidx = idx + c(2,idx);
    B{counter} = (c(:,(idx+1):endidx))';
    counter = counter+1;
    idx = idx + c(2,idx) + 1;
end

