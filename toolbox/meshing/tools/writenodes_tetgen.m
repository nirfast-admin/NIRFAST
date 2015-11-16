function writenodes_tetgen(fn,p,nodemap)
% writenodes_tetgen(fn,p,nodemap)
% Writes the 3D nodes in 'p' to a file called 'fn' in tetgen format
% <# of points> <dimension> <# of attributes> <boundary markers (0 or 1)>
% nnodes 3 0 0
% 1 x y z
% 2 x y z
% 3 x y z
fprintf('%s','Writing data to file...')
np=size(p,1); dim=size(p,2);
if dim~=3 && dim~=2
    error('writenodes_tetgen: Input points are not 3D or 2D');
end
if isempty(fn), error('Filename should be specified'), end

fn = add_extension(fn,'.node');
fid = OpenFile(fn,'wt');

fprintf(fid,'%u %d 0 0\n',np,dim);
if nargin==2
    nn=(1:np)';
else
    if size(nodemap,1)==1
        nn=nodemap';
    elseif size(nodemap,2)==1
        nn=nodemap;
    elseif size(nodemap,2)~=1
        error('The nodemap list provided should be an n by 1 vector');
    end
end

if dim == 2
    formatstring = '%u %.10f %.10f\n';
elseif dim == 3
    formatstring = '%u %.10f %.10f %.10f\n';
end

fprintf(fid,formatstring,[nn p(:,1:3)]');

fclose(fid);

[mypath myfn myext]=fileparts(fn);
fprintf('\b\b%s\n','Done writing the nodes to:')
if ~isempty(mypath)
    fprintf('\t%s\n',['Path: ' mypath])
end
fprintf('\t%s\n',['Filename: ' myfn myext])




