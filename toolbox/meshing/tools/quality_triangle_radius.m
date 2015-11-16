function q=quality_triangle_radius(p,t)
% calculates quality of triangular meshes using radius ratio method.

a=sqrt(sum((p(t(:,2),:)-p(t(:,1),:)).^2,2));
b=sqrt(sum((p(t(:,3),:)-p(t(:,1),:)).^2,2));
c=sqrt(sum((p(t(:,3),:)-p(t(:,2),:)).^2,2));
r=1/2*sqrt((b+c-a).*(c+a-b).*(a+b-c)./(a+b+c));
R=a.*b.*c./sqrt((a+b+c).*(b+c-a).*(c+a-b).*(a+b-c));

q=2*r./R;