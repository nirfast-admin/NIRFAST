function [e p tris_ nnpe] = readMEDIT(fn)
% Reads mesh form a .mesh file formatted in MEDIT style
tris_=[];
fid = OpenFile(fn,'rt');

while true
    junk = fgetl(fid);
    if strcmp(junk,'Vertices');
        break;
    end
end
nn = str2num(fgetl(fid));

data = textscan(fid,'%f %f %f%*[^\n]',nn);
if length(data{1}) ~= nn
    error(' Corrupted mesh file.');
end

p = [data{1} data{2} data{3}];
clear data;

tri=0;tet=0;
while true
    junk = fgetl(fid);
    if strcmp(junk,'Triangles')
        tri=1;
        break
    end
    if strcmp(junk,'Tetrahedra')
        tet=1;
        break;
    end
end

if tri==1
    nt = str2num(fgetl(fid));
    tris_ = textscan(fid,'%d %d %d %d%*[^\n]',nt);
    if length(tris_{1}) ~= nt
        warning('Expecting %d faces, but got %d instead!\n', nt, length(tris_{1}));
    end
    tris_ = [tris_{1} tris_{2} tris_{3} tris_{4}];
    while ~feof(fid)
        junk = fgetl(fid);
        if strcmp(junk,'Tetrahedra')
            tet=1;
            break
        end
    end
end

if tet==1
    ne = str2num(fgetl(fid));
    data = textscan(fid,'%d %d %d %d %d%*[^\n]',ne);
    if length(data{1}) ~= ne
        warning('Expecting %d elements, but got %d instead!\n', ne, length(data));
    end
    e = [data{1} data{2} data{3} data{4} data{5}];
    nnpe = 4;
else
    e = tris_;
    nnpe = 3;
end

fclose(fid);


