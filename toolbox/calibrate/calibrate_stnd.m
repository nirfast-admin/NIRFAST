function [data,mesh] = calibrate_stnd(homog_data,...
                   anom_data,...
                   mesh_homog,...
                   mesh_anom,...
        		   frequency,...
        		   iteration)

% [data,mesh] = calibrate(homog_data,...
%                   anom_data,...
%                   mesh_homog,...
%                   mesh_anom,...
%        		   frequency,...
%        		   iteration)
%
% Calibrates standard data, using homogeneous data measured on phantom
% and the anomaly data
%
% homog_data is the homogeneous data (filename or variable)
% anom_data is the anomaly data (filename or variable)
% mesh_homog is the homogeneous mesh (filename or variable)
% mesh_anom is the anomaly mesh (filename or variable)
% frequency is the modulation frequency (MHz)
% iteration is the number of iterations for fitting
% data is the calibrated data
% mesh is the calibrated mesh with initial guesses



% error checking
if frequency < 0
    errordlg('Frequency must be nonnegative','NIRFAST Error');
    error('Frequency must be nonnegative');
end

% If not a workspace variable, load meshes
if ischar(mesh_homog)== 1
  mesh_homog = load_mesh(mesh_homog);
end

if ischar(mesh_anom)== 1
  mesh_anom = load_mesh(mesh_anom);
end

mesh = mesh_anom;

% load anomaly data
paa_anom   = load_data(anom_data);
if ~isfield(paa_anom,'paa')
    errordlg('Data not found or not properly formatted','NIRFAST Error');
    error('Data not found or not properly formatted');
end
paa_anom = paa_anom.paa;

% set phase in radians
[j,k] = size(paa_anom);
for i=1:2:k
paa_anom(find(paa_anom(:,i+1)<0),i+1) = ...
    paa_anom(find(paa_anom(:,i+1)<0),i+1) + (360);
paa_anom(find(paa_anom(:,i+1)>(360)),i+1) = ...
    paa_anom(find(paa_anom(:,i+1)>(360)),i+1) - (360);
end

% load homogeneous data
paa_homog = load_data(homog_data);
paa_homog = paa_homog.paa;

% set phase in radians
[j,k] = size(paa_homog);
for i=1:2:k
paa_homog(find(paa_homog(:,i+1)<0),i+1) = ...
    paa_homog(find(paa_homog(:,i+1)<0),i+1) + (360);
paa_homog(find(paa_homog(:,i+1)>(360)),i+1) = ...
    paa_homog(find(paa_homog(:,i+1)>(360)),i+1) - (360);
end


    
% Calculate global mua and mus plus offsets for phantom data
[mua_h,mus_h,lnI_h,phase_h,data_h_fem] = fit_data(mesh_homog,...
                                                  paa_homog,...
                                                  frequency,...
                                                  iteration);

% Calculate global mua and mus plus offsets for patient data
[mua_a,mus_a,lnI_a,phase_a,data_a_fem] = fit_data(mesh_anom,...
                                                  paa_anom,...
                                                  frequency,...
                                                  iteration);

% calculate offsets between modeled homogeneous and measured
% homogenous and using these calibrate data
data_h_fem(:,1) = log(data_h_fem(:,1));
data_a_fem(:,1) = log(data_a_fem(:,1));
paa_anom(:,1) = log(paa_anom(:,1));
paa_homog(:,1) = log(paa_homog(:,1));
paa_anomtmp = paa_anom;
paa_homogtmp = paa_homog;


paa_cal = paa_anom - ((paa_homog - data_h_fem));
paa_cal(:,1) = paa_cal(:,1) - (lnI_a-lnI_h);
paa_cal(:,2) = paa_cal(:,2) - (phase_a-phase_h);
paa_cal(:,1) = exp(paa_cal(:,1));

% calibrated data out
data.paa = paa_cal;

% set mesh values for global calculated patient values
mesh.mua(:) = mua_a;
mesh.mus(:) = mus_a;
mesh.kappa = 1./(3*(mesh.mua+mesh.mus));
    