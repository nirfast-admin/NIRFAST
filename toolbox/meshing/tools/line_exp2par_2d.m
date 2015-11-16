function [x0,y0,f,g]=line_exp2par_2d ( x1, y1, x2, y2)
% !! LINE_EXP2PAR_2D converts a line from explicit to parametric form in 2D.

% !  Formula:
% !    The explicit form of a line in 2D is:
% !      (X1,Y1), (X2,Y2).
% !    The parametric form of a line in 2D is:
% !      X = X0 + F * T
% !      Y = Y0 + G * T

  x0 = x1;
  y0 = y1;

  f = x2 - x1;
  g = y2 - y1;

  norm = sqrt ( f .* f + g .* g );

  b=(norm~=0);
  temp=norm(b);
  if (size(temp)~=size(norm))
      display(' Error in line_exp2par_2d function, a line has zero length');
      return;
  end
  if ( norm ~= 0.0E+00 ) 
    f = f ./ norm;
    g = g ./ norm;
  end
