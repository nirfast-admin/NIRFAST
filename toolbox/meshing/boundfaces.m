function [new_faces new_points]=boundfaces(points,tet)
% boundfaces Find boundary faces from tetrahedral mesh
%   bdy_faces = boundfaces(tet)
% NOTE : The returned faces and points are renumbered and
%        the node numbers in 'bdy_faces' does not follow
%        the node numbering in input mesh 'tet'
% Written by: Hamid Ghadyani, March 2010

faces=[tet(:,[1,2,3]);
      tet(:,[1,2,4]);
      tet(:,[1,3,4]);
      tet(:,[2,3,4])];

faces=sort(faces,2);
[foo,ix,jx]=unique(faces,'rows');
vec=histc(jx,1:max(jx));
qx= vec==1;
bdy_faces=faces(ix(qx),:);

nodes=unique([bdy_faces(:,1); bdy_faces(:,2); bdy_faces(:,3)]);
[tf new_faces]=ismember(bdy_faces,nodes);
new_points = points(nodes,:); 