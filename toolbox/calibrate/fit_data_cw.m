function [mua,mus,lnI_offset,fem_data] = fit_data_cw(mesh,data,iteration)
                                                           
% [mua,mus,lnI_offset,fem_data] = fit_data(mesh,...
%                                   data,iteration)
%
% fits data to a given model to give initial guesses for
% reconstruction as well as data offsets
%
% mesh is the input mesh (variable)
% data is the boundary data (variable)
% iteration is the number of iterations for fitting
% outputs are the intial guesses


frequency = 0;
if size(data,2) > 1
    data = data(:,1);
end

% calculate the source / detector distance for each measurement
k = 1;
datanum = 0;
[ns,junk]=size(mesh.source.coord);
for i = 1 : ns
  for j = 1 : length(mesh.link(i,:))
      datanum = datanum + 1;
      if isnan(data(datanum,1))
          mesh.link(i,j) = 0;
      end
      if mesh.link(i,j) ~= 0
          jj = mesh.link(i,j);
          dist(k,1) = sqrt(sum((mesh.source.coord(i,:) - ...
                    mesh.meas.coord(jj,:)).^2));
          k = k+1;
      else
        data(datanum,1) = NaN;
      end
  end
end

% % convert log amplitude into amplitude
% data(:,1) = exp(data(:,1));

% Set lnrI, lnr and phase!
[j,k] = size(data(:,1));
[j2,k2] = size(dist);

% deal with NaNs
dist_orig = dist;
ind = find(isnan(data(:,1))==1);
ind = setdiff(1:size(data,1),ind);
data = data(ind,:);

lnrI = log(data(:,1).*dist);
lnI = log(data(:,1));

figure;
subplot(1,2,1);
plot(dist,lnrI,'.')
ylabel('lnrI');
xlabel('Source / Detector distance');
drawnow
pause(0.001)

% Calculate the coeff of a polynomial fit of distance vs. lnrI
m1 = polyfit(dist,lnrI,1); m1 = m1(1);

% fit data using an analytical model
% based on Pogue paper
omega = 2*pi*frequency*1e6;
c=(3e11./mean(mesh.ri));

mua = 0.01; mus = mean(mesh.mus); kappa = 1/(3*(mua+mus));

for i = 1 : 25
  f1 = ((mua^2 + (omega/c)^2) / (kappa^2))^0.25;
  alpha = -f1*cos(0.5*atan2(omega/c,mua));
  
  mua = mua + 0.0001; 
  kappa = 1/(3*(mua+mus));
  f1 = ((mua^2 + (omega/c)^2) / (kappa^2))^0.25;
  alpha1 = -f1*cos(0.5*atan2(omega/c,mua));
  mua = mua - 0.0001;   
  
  da = (alpha-alpha1)/0.0001;
  mua = mua - (m1-alpha)/da;
  mua = abs(mua);
  kappa = 1/(3*(mua+mus));
end

disp('Global values calculated from Analytical fit');
disp(['Absorption = ' num2str(mua) ' mm-1']);
disp('============================================');

% Set the global values onto mesh.
mesh.mua(:) = mua;
mesh.kappa = 1./(3*(mesh.mua+mesh.mus));

% Fit for mua and mus using FEM
dist = dist_orig;
jj = 0;
while jj ~= iteration
  [fem_data]=femdata(mesh,frequency);
  fem_data = fem_data.paa;
    
  femlnrI = log(fem_data(:,1).*dist);
  
  alpha0 = polyfit(dist,femlnrI,1); alpha0 = alpha0(1);
  
  mesh.mua(:) = mesh.mua(:)+0.0001;
  mesh.kappa = 1./(3*(mesh.mua+mesh.mus));
  
  [fem_data]=femdata(mesh,frequency);
  fem_data = fem_data.paa;
  
  femlnrI = log(fem_data(:,1).*dist);
  
  alpha1 = polyfit(dist,femlnrI,1); alpha1 = alpha1(1);
  
  mesh.mua(:) = mesh.mua(:)-0.0001;
  mesh.kappa = 1./(3*(mesh.mua+mesh.mus));
  
  da = (alpha0-alpha1)/0.0001;
  
  mesh.mua(:) = mesh.mua(:) - (m1-alpha0)/da;
  mesh.kappa = 1./(3*(mesh.mua+mesh.mus));
  
  err_a = abs(mean(mesh.mua)-mua)./mua;
  
  if ((err_a < 0.001))
    jj = iteration;
  else
    jj = jj + 1;
  end
  
  mua = mean(mesh.mua);
  mus = mean(mesh.mus);
  if mua < 0 || mus < 0
    errordlg('Negative mua or mus was calculated. This may be caused by bad/noisy data.','NIRFAST Error');
    error('Negative mua or mus was calculated. This may be caused by bad/noisy data.');
  end
  disp('Global values calculated from Numerical fit');
  disp(['Iteration ' num2str(jj) ' of ' num2str(iteration)]);
  disp(['Absorption = ' num2str(mua) ' mm-1 with error of ' num2str(err_a)]);
  disp('-------------------------------------------------');
end

% Calculate data based on these global values
[fem_data]=femdata(mesh,frequency);
fem_data = fem_data.paa;


% Arrange data to calculate offset
femlnI = log(fem_data(:,1));

% Find offset
% make sure any original NaNs are present
lnI = log(data(:,1));

% Set offset based on particular source / detector
% we do this because data is not symmetrical!
[n,m]=size(mesh.link);
lnI_offset_tmp = spalloc(n,m,n*m);
k = 1;
for i = 1 : n
  for j = 1 : m
    if mesh.link(i,j) ~= 0
      jj = mesh.link(i,j);
      lnI_offset_tmp(i,jj) = lnI(k)-femlnI(k);
      k = k + 1;
    end
  end
end

lnI_offset = zeros(size(femlnI));
k = 1;
for i = 1 : n
  for j = 1 : m
    if mesh.link(i,j) ~= 0
      temp = lnI_offset_tmp(i,:);
      temp(isnan(temp)) = [];
      lnI_offset(k) = mean(temp);
      k = k + 1;
    end
  end
end

subplot(1,2,2);
plot(lnI,'k');
hold on
plot(femlnI+lnI_offset,'r--');
axis tight;
xlabel('log Amplitude');
legend('original','Calibrated');

% restore NaNs to data
fem_datatmp = fem_data;
lnI_offsettmp = lnI_offset;
fem_data = [];
lnI_offset = [];
datanum = 0;
for i = 1 : n
  for j = 1 : m
      if mesh.link(i,j) ~= 0
          datanum = datanum + 1;
          fem_data = [fem_data; fem_datatmp(datanum,:)];
          lnI_offset = [lnI_offset; lnI_offsettmp(datanum)];
      else
          fem_data = [fem_data; NaN NaN];
          lnI_offset = [lnI_offset; NaN];
      end
  end
end
