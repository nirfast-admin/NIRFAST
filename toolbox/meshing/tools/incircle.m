function [pc r]=incircle(tp1,tp2,tp3)
% Calculates the radius and center of inscribed circle of a triangle.
if size(tp1,2)==3
    dim=3;
elseif size(tp1,2)==2
    dim=2;
end
a=v_magn(tp2-tp3);
b=v_magn(tp3-tp1);
c=v_magn(tp1-tp2);
s=(a+b+c)/2;

pc = (repmat(a,1,dim).*tp1 + repmat(b,1,dim).*tp2 + repmat(c,1,dim).*tp3)./(2*repmat(s,1,dim));
r = sqrt((s-a).*(s-b).*(s-c)./s);