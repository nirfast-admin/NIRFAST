function domex_nirfast()
% Routine to compile the meshing mex files in a batch.
% Should only be run on a machine that has mex set up properly.
% It should be called whenever meshing mex C/C++ files are updated.
% A normal use is unlikely to run this script!
% Written by Hamid Ghadyani June, 2010


% Find the folder where meshing mex files reside
meshing_mex = fileparts(which('nirfast'));
cd(meshing_mex);
cd('../toolbox/mex/meshing_mex')
os=computer;
if isunix
    if ~isempty(strfind(os,'MAC')) % Mac
        mex -v -DOSX -I./meshlib tag_checkerboard3d_mex.cpp meshlib/CStopWatch.cpp
        mex -v -I./meshlib             surface_relations_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp meshlib/polyhedron2BSP.cpp meshlib/CPoint.cpp meshlib/CVector.cpp meshlib/Plane3D.cpp meshlib/BSPNode.cpp meshlib/MeshIO.cpp meshlib/FileOperation.cpp meshlib/CPolygon.cpp meshlib/predicates.cpp meshlib/CStopWatch.cpp
        mex -v pnpoly_mex.cpp
        mex -v        -I./meshlib orient_surface_mex.cpp meshlib/vector.cpp meshlib/geomath.cpp isinvolume_randRay.cpp
        mex -v -I./meshlib involume_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
        mex -v         -I./meshlib intersect_ray_shell_mex.cpp ./meshlib/vector.cpp ./meshlib/geomath.cpp
        mex -v extract_ind_regions_mex.cpp
        mex -v -I./meshlib         PointInPolyhedron_mex.cpp meshlib/polyhedron2BSP.cpp meshlib/CPoint.cpp meshlib/CVector.cpp meshlib/Plane3D.cpp meshlib/BSPNode.cpp meshlib/MeshIO.cpp meshlib/FileOperation.cpp meshlib/CPolygon.cpp meshlib/predicates.cpp meshlib/CStopWatch.cpp
        mex -v -I./meshlib GetListOfConnTri2Tri_mex.cpp meshlib/vector.cpp
        mex -v -I./meshlib get_ray_shell_intersections.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
        mex -v -I./meshlib expand_bdybuffer_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
    elseif ~isempty(strfind(os,'GLNX')) % Linux
        mex -v -Dlinux -I./meshlib tag_checkerboard3d_mex.cpp meshlib/CStopWatch.cpp
        mex -v -DLINUX -I./meshlib surface_relations_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp meshlib/polyhedron2BSP.cpp meshlib/CPoint.cpp meshlib/CVector.cpp meshlib/Plane3D.cpp meshlib/BSPNode.cpp meshlib/MeshIO.cpp meshlib/FileOperation.cpp meshlib/CPolygon.cpp meshlib/predicates.cpp meshlib/CStopWatch.cpp
        mex -v pnpoly_mex.cpp
        mex -v -DLINUX -I./meshlib orient_surface_mex.cpp meshlib/vector.cpp meshlib/geomath.cpp isinvolume_randRay.cpp
        mex -v -I./meshlib involume_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
        mex -v -DLINUX -I./meshlib intersect_ray_shell_mex.cpp ./meshlib/vector.cpp ./meshlib/geomath.cpp
        mex -v extract_ind_regions_mex.cpp
        mex -v -DLINUX -I./meshlib PointInPolyhedron_mex.cpp meshlib/polyhedron2BSP.cpp meshlib/CPoint.cpp meshlib/CVector.cpp meshlib/Plane3D.cpp meshlib/BSPNode.cpp meshlib/MeshIO.cpp meshlib/FileOperation.cpp meshlib/CPolygon.cpp meshlib/predicates.cpp meshlib/CStopWatch.cpp
        mex -v -I./meshlib GetListOfConnTri2Tri_mex.cpp meshlib/vector.cpp
        mex -v -I./meshlib get_ray_shell_intersections.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
        mex -v -I./meshlib expand_bdybuffer_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
    end
    
else % PC
    mex -v -DWIN32 -I./meshlib tag_checkerboard3d_mex.cpp meshlib/CStopWatch.cpp
    mex -v -DCPU86 -DWIN32 -I./meshlib surface_relations_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp meshlib/polyhedron2BSP.cpp meshlib/CPoint.cpp meshlib/CVector.cpp meshlib/Plane3D.cpp meshlib/BSPNode.cpp meshlib/MeshIO.cpp meshlib/FileOperation.cpp meshlib/CPolygon.cpp meshlib/predicates.cpp meshlib/CStopWatch.cpp
    mex -v pnpoly_mex.cpp
    mex -v -DWIN32 -DCPU86 -I./meshlib orient_surface_mex.cpp meshlib/vector.cpp meshlib/geomath.cpp isinvolume_randRay.cpp
    mex -v -DWIN32 -DCPU86 -I./meshlib involume_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
    mex -v -DWIN32 -DCPU86 -I./meshlib intersect_ray_shell_mex.cpp ./meshlib/vector.cpp ./meshlib/geomath.cpp
    mex -v extract_ind_regions_mex.cpp
    mex -v -DCPU86 -DWIN32 -I./meshlib PointInPolyhedron_mex.cpp meshlib/polyhedron2BSP.cpp meshlib/CPoint.cpp meshlib/CVector.cpp meshlib/Plane3D.cpp meshlib/BSPNode.cpp meshlib/MeshIO.cpp meshlib/FileOperation.cpp meshlib/CPolygon.cpp meshlib/predicates.cpp meshlib/CStopWatch.cpp
    mex -v -DWIN32 -DCPU86 -I./meshlib GetListOfConnTri2Tri_mex.cpp meshlib/vector.cpp
    mex -v -DWIN32 -I./meshlib get_ray_shell_intersections.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
    mex -v -DWIN32 -I./meshlib expand_bdybuffer_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
end

