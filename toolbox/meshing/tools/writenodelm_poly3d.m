function writenodelm_poly3d(fn, e, p, int_nodes, holes, regions, write_node_file_flag, nodemap)
% writenodelm_poly3d(fn, e, p, int_nodes, holes, regions, write_node_file_flag, nodemap)
% Writes the 3D boundary defined in e and p to .poly file format.
% write_node_file_flag = 1 writes a seperate .node file otherwise it is
% assumed that .node file already exists.
% 
% int_nodes: List of nodes that are not part of any polygon and we want to
% include them within the poly3d file. (it can be empty [])
% 
% holes: an nh by 3 matrix specifying location of the holes in the PLC (it
% can be empty [])
% 
% regions: a cell array which identifies a point inside a given region
% (material). It also can contain region ID and the volume constraint.
% regions{:,1} : coordinaets of a point inside the region
% regions{:,2} : material/attribute ID for the hole and volume constraint.
% 
% For more info check:
% http://tetgen.berlios.de/fformats.poly.html

if size(e,2)<3 || size(p,2)~=3
    error('Can not write a non 3D surface to .poly!');
end

fprintf('\n%s','Writing data to file... ')

ne = size(e,1);

if nargin>=8 && ~isempty(nodemap)
    nn=nodemap;
elseif nargin<8 || isempty(nodemap)
    if isempty(int_nodes)
        nn=(1:size(p,1))';
    else
        foo = size(p,1)-length(int_nodes);
        nn = (1:foo)';
    end
end

tf=ismember(nn,e);
if sum(tf)~=length(nn)
   error(sprintf('\n\nIt seems you have not renumbered your element list based on the nodemap provided!\n'));
end

if ~(nargin>=7 && ~isempty(write_node_file_flag) && write_node_file_flag==0)
    write_node_local(fn,p);
end

fn=add_extension(fn,'.poly');
fn2=remove_extension(fn);
fid = OpenFile(fn,'wt');

% .node file is seperate
fprintf(fid,'# node file is in %s\n', [fn2 '.node']);
fprintf(fid,'0 0 0 0\n');
% # of faces
fprintf(fid,'# facet list\n');
if isempty(int_nodes)
    nfacets = ne;
else
    nfacets = ne+length(int_nodes);
end
fprintf(fid,'%d 0\n',nfacets);
fprintf(fid,'1\n3 %d %d %d\n',(e(:,1:3))');
if ~isempty(int_nodes)
    fprintf(fid,'# interior nodes as facet list (degenerate polygons)\n');
    fprintf(fid,'1\n1 %d\n',int_nodes');
end
if isempty(holes)
    fprintf(fid,'# no holes\n');
    fprintf(fid,'0\n');
else
    fprintf(fid,'# holes\n');
    fprintf(fid,'%d\n',size(holes,1));
    for i=1:size(holes,1)
        fprintf(fid,'%d %f %f %f\n',i,holes(i,:));
    end
end
if isempty(regions)
    fprintf(fid,'# no region attributes\n');
    fprintf(fid,'0\n');
else
    fprintf(fid,'# region attributes\n');
    fprintf(fid,'%d\n',size(regions,1));
    for i=1:size(regions,1)
        coords = regions{i,1};
        formatstring = '%d %.12f %.12f %.12f %d';
        if length(regions{i,2})>1
            for jj=1:(length(regions{i,2})-1)
                formatstring = [formatstring ' %.12f'];
            end
        end
        formatstring = [formatstring '\n'];
        fprintf(fid,formatstring,i,coords,regions{i,2});
    end
    fprintf('\n');
end
fclose(fid);
    

[mypath myfn]=fileparts(fn);
fprintf('\b%s\n','Done writing surface to a poly file:')
if ~isempty(mypath)
    fprintf('\t%s\n',['Path: ' mypath])
end
fprintf('\t%s\n',['Filename: ' myfn '.poly'])



function write_node_local(fn,p)
[np dim] = size(p);

fn=remove_extension(fn);
fn = [fn '.node'];
fid=OpenFile(fn,'wt');

fprintf(fid,'%u %d 0 0\n',np,dim);

if dim==3
    format='%u %.10f %.10f %.10f\n';
elseif dim==2
    format='%u %.10f %.10f\n';
end
fprintf(fid,format,[(1:size(p,1))' p]');

fclose(fid);
