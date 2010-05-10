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

if ischar(mesh)== 1
  mesh = load_mesh(mesh);
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

% allocate Jacobian size
J_mua_big = zeros(ndata*nwv,nnodes*m);
J_mua_temp = zeros(ndata,nnodes*m);
data.paa = [];
data.wv=[];

% for each wavelength
for i = 1:nwv
  disp(sprintf('Calculating data for: %g nm',(wv_array(i))))
  
  %****************************************************************
  % calculate absorption and scattering coefficients from concetrations and
  % scattering parameters a and b
  [mesh.mua,mesh.mus,mesh.kappa,E] = calc_mua_mus(mesh,wv_array(i));
  if exist('mesh2') == 1
      [mesh2.mua,mesh2.mus,mesh2.kappa, E] = calc_mua_mus(mesh2,wv_array(i));
  end
  
  % if sources are not fixed, move sources depending on mus
  if mesh.source.fixed == 0
    mus_eff = mesh.mus;
    [mesh]=move_source(mesh,mus_eff,3);
    clear mus_eff
  end
  
  % set mesh linkfile not to calculate NaN pairs:
  if isfield(mesh,'ind')
      link = mesh.linkorig';
      eval(['ind = mesh.ind.l' num2str(wv_array(i)) ';']);
      link(ind) = 0;
      mesh.link = link';
      if exist('mesh2') == 1
        mesh2.link = link';
      end
  end
  clear link
  
  %%calculating jacobian for absorption and scatter at each wavelength
  if exist('mesh2') == 1
      [J,data1,mesh]=jacobian_stnd(mesh,frequency,mesh2);
  else
      [J,data1,mesh]=jacobian_stnd(mesh,frequency);
  end
  J_mua = J.complete;
  %J_kappa = J.complete(:,1:nnodes);
  
  % make sure we have equal length jacobians to output, to do this we
  % will NaN pad
  J_mua(end+1:ndata,:) = NaN;
  %J_kappa(end+1:ndata*2,:) = NaN;
  
  for j = 1:m
    J_mua_temp(:,(j-1)*nnodes+1:(j)*nnodes) = ...
	[E(j).*(J_mua)];
  end
  J_mua_big(((i-1)*ndata)+1:i*ndata,:) = J_mua_temp;
  
  % make sure we have equal length data.paa files to output, to do this we
  % will NaN pad
  data1.paa(end+1:ndata,:) = NaN;
  data.paa = [data.paa data1.paa];
  data.wv = [data.wv wv_array(i)];
  clear ref J
end
clear J*_tmp mesh1.mua_big mesh1.mus_big mesh1.kappa_big *_factor

%%building new big jacobian for conc/scatter
J = [J_mua_big];
clear J_mua_big mesh_temp;

mesh.link = mesh.linkorig;