function write_nodelm_poly2d(fn,e,p,nodemap,holes)
% Writes the 2D boundary defined in e and p to .poly file format.
% Note that it will create a .poly and a .node file.
% holes is a cell of n by 2:
% holes(:,1) : coordinaets of a point inside the region
% holes(:,2) : material/attribute ID for the hole.

if ~((size(e,2)==2 || size(e,2)==4) && size(p,2)==2)
    error('Can not write a non 2D polyline to .poly!');
end
if nargin>=4 && ~isempty(nodemap)
    nn=nodemap;
else
    nn=(1:size(p,1))';
end

[tf idx]=ismember(nn,e);
if sum(tf)~=length(nn)
   error('It seems you have not renumbered your element list based on the nodemap provided!');
end

fid=fopen([fn '.poly'],'wt');
if fid==0
    disp(' ');
    error(['Cant open the output file: ' fn]);
    disp(' ');
end

% We will write the nodes to a different .node file
fprintf(fid,'0 2 0 0\n');
fprintf(fid,'%d 0\n',size(e,1));
for i=1:size(e,1)
    fprintf(fid,'%d\t%d\t%d\n',i,e(i,1),e(i,2));
end
fprintf(fid,'0\n');
if nargin >= 5 && ~isempty(holes)
    fprintf(fid,'%d\n',size(holes,1));
    for i=1:size(holes,1)
        coords = holes{i,1};
        fprintf(fid,'%d %.8f %.8f %d\n',i,coords(1),coords(2),cell2mat(holes{i,2}));
    end
else
    fprintf(fid,'0\n0\n');
end
fclose(fid);

fid=fopen([fn '.node'],'wt');
if fid==0
    disp(' ');
    error(['Cant open the output file: ' fn]);
    disp(' ');
end

fprintf(fid,'%d 2 0 0\n',size(p,1));
for i=1:size(p,1)
    fprintf(fid,'%d\t%.12f\t%.12f\n',nn(i),p(i,1),p(i,2));
end
fclose(fid);
