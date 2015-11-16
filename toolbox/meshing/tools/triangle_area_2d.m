function area = triangle_area_2d (p1,p2,p3)
% area = triangle_area_2d (p1,p2,p3)
% triangle_area_2d computes the area of a 2D triangle



area = 0.5E+00 * abs ( ...
    ( p1(:,1) .* ( p2(:,2) - p3(:,2) ) + p2(:,1) .* ( p3(:,2) - p1(:,2) ) + p3(:,1) .* ( p1(:,2) - p2(:,2) ) ) );

