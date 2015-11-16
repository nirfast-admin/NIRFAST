function area = triangle_area_3d (p1,p2,p3)
% !*******************************************************************************
% !
% !! TRIANGLE_AREA_3D computes the area of a triangle in 3D.

u=p3-p1; v=p2-p1;
normal=cross(u,v);
area = abs(0.5 * sqrt( sum(normal.^2,2) ));