function [t p nnpe] = readVTK(fn)
% This is a basic VTK reader that is intended to read meshes with uniform
% number of nodes per elements (ex. triangular surface or tetrahedral
% meshes)
% Written by Hamid Ghadyani

fn = add_extension(fn,'.vtk');

fid = OpenFile(fn,'rt');

s = fgetl(fid);
if isempty(regexp(s,'Version 3\.0', 'once')) &&...
        isempty(regexp(s,'Version 2\.0', 'once')) && ...
        isempty(regexp(s,'Version 1\.0', 'once'))
    error('Can only read versions 2.0 or 3.0 of vtk file format.')
end
s = fgetl(fid);
s = fgetl(fid);

if ~strcmp(s,'ASCII')
    error('Can only read ASCII form of vtk files.')
end

s = fgetl(fid);
while isempty(s)
    s = fgetl(fid);
end
tmp = sscanf(s,'%*s%s');
% if 
if ~strcmp(tmp,'UNSTRUCTURED_GRID') && ~strcmp(tmp,'POLYDATA')
    error(['Can not read dataset of type: ' tmp])
end

s = fgetl(fid);
keyword = sscanf(s,'%s',1);
if ~strcmp(keyword,'POINTS')
    error('Expecting POINTS data in vtk file')
end
nn = str2double(sscanf(s,'%*s%s'));
p=zeros(nn*3,1);

s = fgetl(fid);
sidx = 1;

while ~strcmp(sscanf(s,'%s',1),'CELLS') && ~strcmp(sscanf(s,'%s',1),'POLYGONS')
    tmp = textscan(s,'%f');
    tmp=tmp{1};
    eidx = sidx + length(tmp) - 1;
    p(sidx:eidx) = tmp;
    sidx = eidx + 1;
    s = fgetl(fid);
    while isempty(s)
        s = fgetl(fid);
    end
end
p = (reshape(p,3,nn))';

if strcmp(sscanf(s,'%s',1),'CELLS')
    kw = 'CELLS';
else
    kw = 'POLYGONS';
end
tmp = textscan(s,[kw '%d %d']);
ne = tmp{1}; totent = tmp{2};
nnpe = totent/ne - 1;
fmtstr = repmat('%d',1,nnpe);
data = textscan(fid,['%*d' fmtstr]);
if length(data{1}) ~= ne
    error('Can not parse the vtk file.')
end
t=zeros(ne,nnpe,'uint32');
for i=1:nnpe
    t(:,i) = data{i};
end
t=t+1;
fclose(fid);





