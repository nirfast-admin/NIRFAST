function [e p] = image2mesh_cgal(fn,param,outfn)
% Tries to read stack of 2D images (with file name 'fn') and create a
% tetrahedral mesh using CGAL library. It returns the mesh in 'e' and 'p',
% tetrahedral elements and node coordinates.
% 
% param.pad : add padding to 4 sides of each 2D image
% param.medfilter : apply a median filter to iron out speckle noises of images
% param.xpixelsize = x pixel size
% param.ypixelsize = y pixel size
% param.zpixelsize = z pixel size
% 
% subdomain label (defined above)
% param.facet_angle = minimum angle of triangles on surface of mesh (25)
% param.facet_size = controls size of triangles on surface of mesh
% param.facet_distance = controls how accurate the surface mesh mimics the
%                        actual model
% param.cell_radius_edge = controls the quality of tetrahedrons
% param.cell_size = controls the general size of tetrahedrons
% 
% param.special_subdomain_label = label ID (grayscale value) of subdomain
%                    that user wants to have a different tetrahedron size
% param.special_subdomain_size = size of tetrahedron for the special
% 
% param.Offset = a 1x3 vector that contains the offset vector that should
%    be applied to node coordinates (useful for stack of 2D images in .bmp
%    format)
% 
% outfn: (optional) specifies the prefix for .ele/.node that the resulting
%        mesh will be written into
% 
% Written by:
%   Hamid Ghadyani May 2011

if nargin==0
    [fn, pathname] = uigetfile( ...
    {'*.bmp;*.jpg;*.tif;*.gif;*.mha','Image Files';
   '*.*',  'All Files (*.*)'}, ...
   'Pick a file');
    if isequal(fn,0)
        error(sprintf('\nYou need to select an image file!'));
    end
    fn = fullfile(pathname,fn);
    param.xpixelsize = 0.703;
    param.ypixelsize = 0.703;
    param.zpixelsize = 1.5;
    param.pad = 0;
    param.medfilter = 0;
end

param.medfilter = 0;
if isfield(param,'medfilter') && param.medfilter==1
    param.medfilter = 1;
end
[mask info] = GetImageStack(fn,param);
mask = uint16(mask);

if isfield(info,'Offset')
    param.Offset = info.Offset;
end
    
if isfield(info,'PixelDimensions')
    param.PixelSpacing(1) = info.PixelDimensions(1);
    param.PixelSpacing(2) = info.PixelDimensions(2);
    param.SliceThickness  = info.PixelDimensions(3);
elseif isfield(param,'xpixelsize')
    param.PixelSpacing(1) = param.xpixelsize;
    if isfield(param,'ypixelsize'), param.PixelSpacing(2) = param.ypixelsize; end
    if isfield(param,'zpixelsize'), param.SliceThickness  = param.zpixelsize; end
else
    error('No pixel dimension information is provided!');
end
[e p] = RunCGALMeshGenerator(mask,param);
if nargin<3
    outfn=[fn '-tetmesh'];
end
outfn = add_extension(outfn,'.ele');
writenodelm_nod_elm(outfn,e,p,[],1);

