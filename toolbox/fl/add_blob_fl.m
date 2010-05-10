function mesh = add_blob_fl(mesh, blob)

% mesh = add_blob_fl(mesh, blob)
%
% Adds circular (2D) and spherical (3D) fluorescence 
% anomalies to the mesh.
%
% mesh is the mesh variable or filename.
% blob contains the anomaly info.
% blob should have the following format:
%
% blob.x - x position
% blob.y - y position
% blob.z - z position (optional)
% blob.r - radius
% blob.muax - absorption coefficient at excitation
% blob.musx - scatter coefficient at excitation
% blob.muam - absorption coefficient at emission
% blob.musm - scatter coefficient at emission
% blob.muaf - absorption of fluorophore
% blob.eta - quantum yield of fluorophore
% blob.tau - lifetime of fluorophore
% blob.ri - refractive index
% blob.region - region number



% If not a workspace variable, load mesh
if ischar(mesh)== 1
  mesh = load_mesh(mesh);
end


if (isfield(blob, 'x') == 0)
    errordlg('No x coordinate was given for the anomaly','NIRFAST Error');
    error('No x coordinate was given for the anomaly');
end
if (isfield(blob, 'y') == 0)
    errordlg('No y coordinate was given for the anomaly','NIRFAST Error');
    error('No y coordinate was given for the anomaly');
end
if (isfield(blob, 'z') == 0 || mesh.dimension == 2)
    blob.z = 0;
end
if (isfield(blob, 'r') == 0)
    errordlg('No radius was given for the anomaly','NIRFAST Error');
    error('No radius was given for the anomaly');
end
dist = distance(mesh.nodes(:,1:3),ones(length(mesh.bndvtx),1),[blob.x blob.y blob.z]);
if isfield(blob, 'muax') && isfield(blob, 'musx')
    kappax = 1./(3*(blob.muax+blob.musx));
    mesh.kappax(find(dist<=blob.r)) = kappax;
end
if isfield(blob, 'muam') && isfield(blob, 'musm')
    kappam = 1./(3*(blob.muam+blob.musm));
    mesh.kappam(find(dist<=blob.r)) = kappam;
end
if isfield(blob, 'muax')
    mesh.muax(find(dist<=blob.r)) = blob.muax;
end
if isfield(blob, 'musx')
    mesh.musx(find(dist<=blob.r)) = blob.musx;
end
if isfield(blob, 'ri')
    mesh.ri(find(dist<=blob.r)) = blob.ri;
     mesh.c(find(dist<=blob.r))=(3e11/blob.ri);
end
if isfield(blob, 'muam')
    mesh.muam(find(dist<=blob.r)) = blob.muam;
end
if isfield(blob, 'musm')
    mesh.musm(find(dist<=blob.r)) = blob.musm;
end
if isfield(blob, 'muaf')
    mesh.muaf(find(dist<=blob.r)) = blob.muaf;
end
if isfield(blob, 'tau')
    mesh.tau(find(dist<=blob.r)) = blob.tau;
end
if isfield(blob, 'eta')
    mesh.eta(find(dist<=blob.r)) = blob.eta;
end
if (isfield(blob, 'region') ~= 0)
    mesh.region(find(dist<=blob.r)) = blob.region;
end
disp(['Number of nodes modified = ' ...
  num2str(length(find(dist<=blob.r)))]);
