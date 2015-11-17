function writenodelm_solidmesh_vtk(fn,e,p,soldata,nnpe)
% Writes a solid mesh defined in e and p to 'fn'
% 'soldata' is the nodal solution for every point in p:
%   soldata{1} = Name of fields/solutions
%   soldata{2} = a numnodes by d matrix where d is number of fields
%   defined in soldata{1,:}
% 
% Written by Hamid Ghadyani, adopted from nirfast2vtk by Mike Jermyn
% 
nodes = p;
numnodes = size(nodes,1);
elems = e;
numelems = size(elems,1);
if nargin<5 % assuming tet mesh
    nnpe = 4;
end

fid = fopen(fn,'wt');

%define an VTK header for FEM mesh representation
line0 = '# vtk DataFile Version 2.0';
line1 = 'NIRFAST mesh with solutions';
line2 = 'ASCII';
line3 = 'DATASET UNSTRUCTURED_GRID';
fprintf(fid,'%s\n%s\n%s\n',line0,line1,line2,line3);

line4 = ['POINTS ', num2str(numnodes), ' double']; %node defs
fprintf(fid,'%s\n',line4);
fprintf(fid, '%.18f %.18f %.18f\n', nodes');

line5 = ['CELLS ',num2str(numelems),' ',num2str(numelems*nnpe+numelems)]; %connectivity maps
fprintf(fid,'%s\n',line5);

sf = repmat(' %d',1,nnpe); 
sf = sprintf('%d%s\n',nnpe,sf);
fprintf(fid, sf, (elems(:,1:nnpe)-1)');

% cell id: right now we support tet and hex only
if nnpe == 4
    cellid = 10;
elseif nnpe == 8
    cellid = 12;
else
    error(' Unsupported cell format.')
end
line6 = ['CELL_TYPES ', num2str(numelems)]; %specify the mesh basis 10-tetrahedral for all connectivity maps 
fprintf(fid,'%s\n',line6);
fprintf(fid,'%d\n', ones(numelems,1)*cellid);

if nargin>3 && ~isempty(soldata)
    fprintf(fid,'POINT_DATA %d\n',numnodes); %specify the data that follows is defined on the nodes

    for i = 1:size(soldata,2)
        fprintf(fid,'%s\n',['SCALARS ', soldata{1}{i}, ' float 1']);
        fprintf(fid,'%s\n','LOOKUP_TABLE default');
        fprintf(fid,'%f\n', soldata{2}(:,i));
    end;
end

if size(elems,2)>nnpe
    fprintf(fid,'CELL_DATA %d\n', numelems);
    fprintf(fid,'SCALARS materials float 1\n');
    fprintf(fid,'LOOKUP_TABLE default\n');
    fprintf(fid,'%f\n', elems(:,nnpe+1));

end
fclose(fid);