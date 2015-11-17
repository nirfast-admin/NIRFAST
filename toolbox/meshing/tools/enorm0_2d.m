function d = enorm0_2d ( x0, y0, x1, y1 )
%calculates normal distance between two points

d = sqrt ( ( x1 - x0 ).^2 + ( y1 - y0 ).^2 );
