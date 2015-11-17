function q_area_ratio=quality_triangle_area(p,t,area)
% Calculates the quality of triangles defined in p and t
% p is the list of node coordinates
% t is the list of node connectivity (n by 3)
% if 'area' is given, this routine will use as the calculated area of each
% triangle and it won't attempt to calculate it.

dim=size(p,2);
np=size(p,1);

if nargin==2
    area = triangle_area_3d(p(t(:,1),:),p(t(:,2),:),p(t(:,3),:));
end
if dim==2
    p(:,3)=ones(np,1);
end

edges = [t(:,[1 2]) t(:,[1 3]) t(:,[2 3])];
l1=sqrt(sum((p(edges(:,1),:)-p(edges(:,2),:)).^2,2));
l2=sqrt(sum((p(edges(:,3),:)-p(edges(:,4),:)).^2,2));
l3=sqrt(sum((p(edges(:,5),:)-p(edges(:,6),:)).^2,2));

maxl=max([l1 l2 l3],[],2);
ideal_area=sqrt(3)/4*maxl.^2;

q_area_ratio=area./ideal_area;

