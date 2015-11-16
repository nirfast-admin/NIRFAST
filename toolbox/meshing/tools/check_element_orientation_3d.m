function e = check_element_orientation_3d(e,p)
% Checks if the 3D tetrahedral elements are oriented in a positive way.
% If not, it re-orients them.
% Tetrahedron (pa, pb, pc, pd) is
%  positive if the point pd lies below the      
%  plane passing through pa, pb, and pc; "below" is defined so 
%  that pa, pb, and pc appear in counterclockwise order when   
%  viewed from above the plane.
% 
% Written by:
%   Hamid Ghadyani, 2012
% 
% This is part of nirfast project

if size(e,2) ~= 4
    error('check_element_orientation_3d expects a 3D mesh!')
end
if size(p,2) ~= 3 % add zero as z values
    error('check_element_orientation_3d expect 3D vertices')
end

pa = p(e(:,1),:);
pb = p(e(:,2),:);
pc = p(e(:,3),:);
pd = p(e(:,4),:);

st = orient3d_mex(pa, pb, pc, pd);

if ismac
    bf = st < 0;
elseif isunix
    bf = st < 0;
else
    bf = st < 0;
end

e(bf,[1 2]) = e(bf,[2 1]);
