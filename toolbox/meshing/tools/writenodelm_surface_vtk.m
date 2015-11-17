function writenodelm_surface_vtk(fn,t,p)
% writenodelm_vtk_surface(fn,t,p)
% Writes the surface defined in 't' and 'p' to a file called 'fn'
% This routine renumbers elements before writing them.
% Written by Hamid Ghadyani 2009

fprintf('%s','Writing data to file... ')

nodes = unique(t(:));
p = p(nodes,:);
[tf t] = ismember(t,nodes);

fn = add_extension(fn,'.vtk');
fid=OpenFile(fn,'wt');

nnpe = size(t,2);
np = size(p,1); ne = size(t,1);

[mypath myfn myext]=fileparts(fn);

% Write the header info
fprintf(fid,'# vtk DataFile Version 2.0\n');
fprintf(fid,['vtk ' myfn '\n']);
fprintf(fid,'ASCII\n');
fprintf(fid,'DATASET POLYDATA\n');

fprintf(fid,'POINTS %d double\n',np);
fprintf(fid,'%.18f %.18f %.18f\n',p');
fprintf(fid,'\n');

sf = repmat(' %d',1,nnpe); 
sf = sprintf('%d%s\n',nnpe,sf);

fprintf(fid,'POLYGONS %d %d\n',ne,(nnpe+1)*ne);
fprintf(fid, sf, (t-1)');
fprintf(fid,'\n');

fclose(fid);

fprintf('\b%s\n','Done writing mesh to:')
if ~isempty(mypath)
    fprintf('\t%s\n',['Path: ' mypath])
end
fprintf('\t%s\n',['Filename: ' myfn myext])
