function mesh2vtk(mesh,value,spacing,outfname)

% mesh2vtk(mesh,outfname)
%
% convert nirfast mesh into vtk structured format with a single solution
%
% mesh is the nirfast mesh
% value is the parameter to save
% spacing the voxel resolution
% outfname is the location to save the vtk file


%% load mesh and get optical properties
if ischar(mesh)== 1
  mesh = load_mesh(mesh);
end

tmp = mesh.nodes(:,1);
mesh.nodes(:,1) = mesh.nodes(:,2);
mesh.nodes(:,2) = tmp;
clear tmp;

maxn = max(mesh.nodes);
minn = min(mesh.nodes);
foo = maxn-minn;
vol = foo(1)*foo(2)*foo(3);
nodense = length(mesh.nodes)/vol;
defspace = 1/nodense^(1/3)*ones(1,3);

if isempty(spacing) == 1
    spacing = defspace;
else
    spacing = defspace/spacing;
end
clear nodense vol foo defspace

[xi,yi,zi] = meshgrid(minn(1):spacing(1):maxn(1)+spacing(1),...
                      minn(2):spacing(2):maxn(2)+spacing(2),...
                      minn(3):spacing(3):maxn(3)+spacing(3));
dimension = size(xi);

F = TriScatteredInterp(mesh.nodes(:,1),mesh.nodes(:,2),mesh.nodes(:,3),value);
w = F(xi,yi,zi);

origin = [minn(2) minn(1) minn(3)];

point_data = numel(w);
w = reshape(w,[],1);
w(isnan(w)) = 0;

%% write to vtk
outfname = add_extension(outfname,'.vtk');

if ~canwrite(outfname)
    [junk fn ext1] = fileparts(outfname);
    outfname = [tempdir fn ext1];
    disp(['No write access, writing here instead: ' outfname]);
end
fid = fopen(outfname,'w');

%define an VTK header for FEM mesh representation
line0 = '# vtk DataFile Version 3.0';
line1 = 'NIRFAST mesh with a solution in structured format';
line2 = 'ASCII';
line3 = 'DATASET STRUCTURED_POINTS';
fprintf(fid,'%s\n%s\n%s\n',line0,line1,line2,line3);

line4 = ['DIMENSIONS ', num2str(dimension)]; 
fprintf(fid,'%s\n',line4);

line5 = ['SPACING ', num2str(spacing)]; 
fprintf(fid,'%s\n',line5);

line6 = ['ORIGIN ', num2str(origin)]; 
fprintf(fid,'%s\n',line6);

line7 = ['POINT_DATA ', num2str(point_data)];
fprintf(fid,'%s\n',line7);

fprintf(fid,'%s\n',['SCALARS value1 float 1']);
fprintf(fid,'%s\n','LOOKUP_TABLE default');
fprintf(fid,'%e\n', w);
fclose(fid);
