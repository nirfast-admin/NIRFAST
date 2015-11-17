function [t p edges] = readGTS(fn)
% Reads a surface mesh from a file formatted in GNU Triangulated Surface mesh

fid = OpenFile(fn,'rt');
junk = fgetl(fid);
blah = sscanf(junk,'%d %d %d');

nnodes = blah(1);
nedges = blah(2);
nfaces = blah(3);

data = textscan(fid,'%f %f %f%*[^\n]',nnodes);
if length(data{1}) ~= nnodes
    fclose(fid);
    error('Expexting %d nodes, but got %d instead!\n', nnodes, length(data));
end

p = [data{1} data{2} data{3}];

data = textscan(fid,'%d %d%*[^\n]',nedges);
if length(data{1}) ~= nedges
    fclose(fid);
    error('Expexting %d edges, but got %d instead!\n', nnodes, length(data));
end

edges = [data{1} data{2}];

data = textscan(fid,'%d %d %d%*[^\n]',nfaces);
fclose(fid);
if length(data{1}) ~= nfaces
    error('Expecting %d faces, but got %d instead!\n', nfaces, length(data));
end

t = [data{1} data{2} data{3}];

foo = edges(t',:);

for i=1:nfaces
    t(i,:) = unique(foo((3*i-2):3*i,:));
end