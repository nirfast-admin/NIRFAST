function di_angles = get_tetrahedron_dihedrals(e,p)

v1 = p(e(:,2),:) - p(e(:,1),:);
v2 = p(e(:,3),:) - p(e(:,1),:);
v3 = p(e(:,4),:) - p(e(:,1),:);
v4 = p(e(:,3),:) - p(e(:,2),:);
v5 = p(e(:,4),:) - p(e(:,2),:);
 
n1 = cross(v2, v1);
n2 = cross(v1, v3);
n3 = cross(v3, v2);
n4 = cross(v4, v5);

di_angles(:,1) = vector_vector_angle(n1, n2);
di_angles(:,2) = vector_vector_angle(n1, n3);
di_angles(:,3) = vector_vector_angle(n2, n3);
di_angles(:,4) = vector_vector_angle(n1, n4);
di_angles(:,5) = vector_vector_angle(n2, n4);
di_angles(:,6) = vector_vector_angle(n3, n4);

di_angles = pi - di_angles;

  
function angle = vector_vector_angle(u, v)

uvdot = dot(u,v,2);
unorm = sqrt(sum(abs(u).^2,2));
vnorm = sqrt(sum(abs(v).^2,2));
angle = acos(min(max(uvdot./(unorm.*vnorm), -1.), 1.));
