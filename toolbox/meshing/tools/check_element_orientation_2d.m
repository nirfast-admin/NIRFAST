function e = check_element_orientation_2d(e,p)
% Checks if the 2D triangular elements are oriented in a CCW fashion.
% If not, it re-orients them.
% Written by:
%   Hamid Ghadyani, 2012
% 
% This is part of nirfast project

if size(e,2) ~= 3
    error('check_element_orientation_2d expects a 2D triangular mesh!')
end
if size(p,2) == 2 % add zero as z values
    p(:,3) = zeros(size(p,1),1);
end

v1 = p(e(:,2),:)-p(e(:,1),:);
v2 = p(e(:,3),:)-p(e(:,1),:);
z = cross(v1,v2);

idx = z(:,3) < 0;
e(idx,[1 2]) = e(idx,[2 1]);
