function [elem, points] = read_abaqus_inp(mesh_fn)
% Reads abaqus mesh files exported by Mimics V.13
% 
% Written by Hamid Ghadyani, Apr 2010
% The old version which is very slow is now called read_abaqus_inp_line
% 

% For compatibility reason with nirfast suit, we call the identical function whose
% name has an extra '3D' in it

[elem, points, surf_elem] = read_abaqus_inp_3D(mesh_fn);

if isempty(elem) % If reading a surface mesh
    elem = surf_elem;
end

