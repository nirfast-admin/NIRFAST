function [J,data,mesh] = jacobian_spectral_cw(mesh,wv_array,mesh2)

% [J,data] = jacobian_spectral_cw(mesh,wv,mesh2)
%
% Used by jacobian and reconstruct!
% Calculates jacobian for a spectral mesh
% if specific wavelengths are specified, only those are used.
% if a reconstruction basis is given, interpolates jacobian onto that mesh
% 
% mesh is the input mesh (variable or filename)
% wv is optional wavelength array
% mesh2 is optional reconstruction basis (mesh variable)
% J is the Jacobian
% data is the calculated data


frequency = 0;

%% initialize parallel workers if toolbox is available
parallel = parallel_init();

%% load mesh
if ischar(mesh)== 1
  mesh = load_mesh(mesh);
end

%% error checking
if frequency < 0
    errordlg('Frequency must be nonnegative','NIRFAST Error');
    error('Frequency must be nonnegative');
end

if exist('wv_array') == 1
    %wv_array = sort(wv_array);
    % check to ensure wv_array wavelengths match the wavelength list fwd_mesh
    for i = 1:length(wv_array)
        tmp = find(mesh.wv == wv_array(i));
        if isempty(tmp)
            flag(i) = 0;
        else
            flag(i) = tmp(1);
        end
    end
    tmp = find(flag==0);
    if isempty(tmp) ~= 1
        for i = 1 : length(tmp)
            disp(['ERROR: wv_array contains ' num2str(wv_array(tmp(i))) ...
                'nm which is not present in ' mesh.name,'.excoef']);
        end
        return
    end
else
    wv_array = mesh.wv;
end

%% allocate/initialize variables
% get number of wavelengths
nwv = length(wv_array);

% get number of chromophores
[junk,m]=size(mesh.excoef);

if exist('mesh2') == 1
  nnodes = length(mesh2.nodes);
else
  nnodes = length(mesh.nodes);
end

% get total number of datapoints
ndata = length(find(mesh.link~=0));

% create a copy of original linkfile before modifying to ignore NaN
mesh.linkorig = mesh.link;
if exist('mesh2') == 1
    mesh2.linkorig = mesh2.link;
end

if exist('mesh2')
    mesh_basis = 1;
else
    mesh_basis = 0;
end

%% Calculate inputs for jacobian at each wavelength
mesh_J(1:nwv) = mesh;
if exist('mesh2')
    mesh2_J(1:nwv) = mesh2;
else
    mesh2_J(1:nwv) = mesh;
end
for i = 1:nwv
      % calculate absorption and scattering coefficients
      [mesh_J(i).mua,mesh_J(i).mus,mesh_J(i).kappa,E(i).val] = calc_mua_mus(mesh,wv_array(i));
      if exist('mesh2') == 1
          [mesh2_J(i).mua,mesh2_J(i).mus,mesh2_J(i).kappa, E(i).val] = calc_mua_mus(mesh2,wv_array(i));
      end

      % if sources are not fixed, move sources depending on mus
      if mesh_J(i).source.fixed == 0
        mus_eff = mesh_J(i).mus;
        [mesh_J(i)]=move_source(mesh_J(i),mus_eff,3);
        clear mus_eff
      end

      % set mesh linkfile not to calculate NaN pairs:
      if isfield(mesh,'ind')
          link = mesh.linkorig';
          eval(['ind = mesh.ind.l' num2str(wv_array(i)) ';']);
          link(ind) = 0;
          mesh_J(i).link = link';
          if exist('mesh2') == 1
            mesh2_J(i).link = link';
          end
      end
      clear link
end

%% Parallel Jacobian
if parallel
    
    parfor i = 1:nwv
        
        if mesh_basis
            [J_tmp(i),data_tmp(i)]=jacobian_stnd(mesh_J(i),frequency,mesh2_J(i));
        else
            [J_tmp(i),data_tmp(i)]=jacobian_stnd(mesh_J(i),frequency);
        end
        
    end
    
%% Serial Jacobian
else   
    
    for i = 1:nwv
        
        if mesh_basis
            [J_tmp(i),data_tmp(i)]=jacobian_stnd(mesh_J(i),frequency,mesh2_J(i));
        else
            [J_tmp(i),data_tmp(i)]=jacobian_stnd(mesh_J(i),frequency);
        end
        
    end

end

%% Assign outputs
data.paa = zeros(ndata,nwv*2);
data.wv = wv_array;
J = [];
J_small = zeros(ndata,nnodes*m);
for i = 1:nwv
    data_tmp(i).paa(end+1:ndata,:) = NaN;
    data.paa(:,i*2-1:i*2) = data_tmp(i).paa;
    
    J_mua = J_tmp(i).complete;
    %J_kappa = J_tmp(i).complete(:,1:nnodes);

    % NaN pad for equal length jacobians
    J_mua(end+1:ndata,:) = NaN;
    %J_kappa(end+1:ndata*2,:) = NaN;

    for j = 1:m
      J_small(:,(j-1)*nnodes+1:(j)*nnodes) = E(i).val(j).*(J_mua);
    end
    
    J = [J;J_small];
    J_tmp(i).complete = [];
    J_tmp(i).complex = [];
end

mesh.link = mesh.linkorig;
