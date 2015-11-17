function [new_faces new_points]=boundfaces(points,tet,renumber_flag)
% boundfaces Find boundary faces from tetrahedral mesh
%   bdy_faces = boundfaces(tet)
% if renumber_flag is not specified or if it's true then
% the returned faces and points are renumbered and
%        the node numbers in 'new_faces' does not follow
%        the node numbering in input mesh 'tet'
% Written by: Hamid Ghadyani, March 2010

if nargin < 3
    renumber_flag = true;
end

faces=[tet(:,[1,2,3]);
      tet(:,[1,2,4]);
      tet(:,[1,3,4]);
      tet(:,[2,3,4])];

faces=sort(faces,2);
[foo,ix,jx]=unique(faces,'rows');
vec=histc(jx,1:max(jx));
qx= vec==1;
bdy_faces=faces(ix(qx),:);

if renumber_flag
    nodes=unique(bdy_faces(:));
    [tf new_faces]=ismember(bdy_faces,nodes);
    new_points = points(nodes,:); 
else
    new_faces = bdy_faces;
    new_points = points;
end