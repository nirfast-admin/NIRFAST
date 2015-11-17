function q = simpqual(p, t, type)
%SIMPQUAL Simplex quality.
%   Q=SIMPQUAL(P,T,TYPE)
%
%   TYPE can be
%  'Radius_Ratio' or 'Min_Sin_Dihedral'
%   Copyright (C) 2004-2006 Per-Olof Persson. See COPYRIGHT.TXT for details.
% 
% 
% Modified by Hamid Ghadyani, 2012, Dartmouth College
%  Add minimum sine of the dihedral angles quality measure
% 

if nargin<3
  qmeasure = 'Radius_Ratio';
elseif nargin >= 3
  if isnumeric(type)
    qmeasure = 'Radius_Ratio';
  else
    qmeasure = type;
  end
end
  
switch qmeasure
    case 'Radius_Ratio'
      switch size(p,2)
          case 1
            q  = ones(1,size(t,2));
           case 2
            a = sqrt(sum((p(t(:,2),:)-p(t(:,1),:)).^2,2));
            b = sqrt(sum((p(t(:,3),:)-p(t(:,1),:)).^2,2));
            c = sqrt(sum((p(t(:,3),:)-p(t(:,2),:)).^2,2));
            r = 1/2*sqrt((b+c-a).*(c+a-b).*(a+b-c)./(a+b+c));
            R = a.*b.*c./sqrt((a+b+c).*(b+c-a).*(c+a-b).*(a+b-c));
            q = 2*r./R;
           case 3
            d12 = p(t(:,2),:)-p(t(:,1),:);
            d13 = p(t(:,3),:)-p(t(:,1),:);
            d14 = p(t(:,4),:)-p(t(:,1),:);
            d23 = p(t(:,3),:)-p(t(:,2),:);
            d24 = p(t(:,4),:)-p(t(:,2),:);
            d34 = p(t(:,4),:)-p(t(:,3),:);
            v   = abs(dot(cross(d12,d13,2),d14,2))/6;
            s1  = sqrt(sum(cross(d12,d13,2).^2,2))/2;
            s2  = sqrt(sum(cross(d12,d14,2).^2,2))/2;
            s3  = sqrt(sum(cross(d13,d14,2).^2,2))/2;
            s4  = sqrt(sum(cross(d23,d24,2).^2,2))/2;
            p1  = sqrt(sum(d12.^2,2)).*sqrt(sum(d34.^2,2));
            p2  = sqrt(sum(d23.^2,2)).*sqrt(sum(d14.^2,2));
            p3  = sqrt(sum(d13.^2,2)).*sqrt(sum(d24.^2,2));
            q   = 216*v.^2./(s1+s2+s3+s4)./sqrt((p1+p2+p3).*(p1+p2-p3).* ...
                                            (p1+p3-p2).*(p2+p3-p1));
           otherwise
            error('Dimension not implemented.');
      end
    case 'Min_Sin_Dihedral'
      switch size(p,2)
          case 1
              q = ones(1,size(t,2));
          case 2
              error('Dimension not implemented yet!')
          case 3
              q = min(sin(get_tetrahedron_dihedrals(t,p)),[],2);
          otherwise
              error('Dimension not implemented.')
      end
    otherwise
        error('Incorrect type.');
end
