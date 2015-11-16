function writeVTK(fn,e,p,varargin)
% Writes a surface or tetrahedral mesh to vtk legacy format.
% If 'sol_data' is specified as optional argument, then
% 'sol_data' is considered nodal values (typically solutions of FEM model) that will
% be written to vtk file. See writenodelm_vtk_mesh for more details.
% 
% Written by:
%     Hamid Ghadyani, 2012
% 

if size(e,2)==3
    writenodelm_surface_vtk(fn,e,p)
elseif size(e,2)>=4
    writenodelm_solidmesh_vtk(fn,e,p,varargin)
else
    error('Can not handle this type of mesh')
end
