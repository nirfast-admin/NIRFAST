function [e p] = readOFF(fn)
% Reads surface mesh from 'fn'
% Note: For now it can only read triangulared surface meshes

fid = OpenFile(fn,'rt');

blah = fgetl(fid);
if isempty(strfind(blah,'OFF'))
    error(['Invalid OFF mesh file:' fn]);
end

junk = fgetl(fid);
blah = str2num(junk);
nnodes = blah(1);
nfaces = blah(2);

data = textscan(fid,'%f %f %f%*[^\n]',nnodes);
if length(data{1}) ~= nnodes
    fclose(fid);
    error('Expexting %d nodes, but got %d instead!\n', nnodes, length(data));
end

p = [data{1} data{2} data{3}];

data = textscan(fid,'%d %d %d %d%*[^\n]',nfaces);
fclose(fid);

if length(data{1}) ~= nfaces
    error('Expecting %d faces, but got %d instead!\n', nfaces, length(data));
end

bf = data{1}==3;
if ~all(bf)
    error('Can only read triangulated surfaces from a OFF file.');
end

e = [data{2} data{3} data{4}]+1;

