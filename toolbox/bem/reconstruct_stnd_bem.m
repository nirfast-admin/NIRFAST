function [fwd_mesh,pj_error] = reconstruct_stnd_bem(fwd_mesh,...
                                                frequency,...
                                                data_fn,...
                                                iteration,...
                                                lambda,...
                                                output_fn,...
                                                filter_n)

% [fwd_mesh,pj_error] = reconstruct_stnd_bem(fwd_mesh,...
%                                        frequency,...
%                                        data_fn,...
%                                        iteration,...
%                                        lambda,...
%                                        output_fn,...
%                                        filter_n)
%                                            
% Reconstruction program for standard bem meshes
%
% fwd_mesh is the input mesh (variable or filename)
% frequency is the modulation frequency (MHz)
% data_fn is the boundary data (variable or filename)
% iteration is the max number of iterations
% lambda is the initial regularization value
% output_fn is the root output filename
% filter_n is the number of mean filters



tic;

if frequency < 0
    errordlg('Frequency must be nonnegative','NIRFAST Error');
    error('Frequency must be nonnegative');
end

%****************************************
% If not a workspace variable, load mesh
if ischar(fwd_mesh)== 1
  fwd_mesh = load_mesh(fwd_mesh);
end

if ~strcmp(fwd_mesh.type,'stnd_bem')
    errordlg('Mesh type is incorrect','NIRFAST Error');
    error('Mesh type is incorrect');
end

% read data - This is the calibrated experimental data or simulated data
anom = load_data(data_fn);

if ~isfield(anom,'paa')
    errordlg('Data not found or not properly formatted','NIRFAST Error');
    error('Data not found or not properly formatted');
end

anom = anom.paa;
anom(:,1) = log(anom(:,1)); %take log of amplitude
anom(:,2) = anom(:,2)/180.0*pi; % phase is in radians and not degrees
anom(anom(:,2)<0,2) = anom(anom(:,2)<0,2) + (2*pi);
anom(anom(:,2)>(2*pi),2) = anom(anom(:,2)>(2*pi),2) - (2*pi);
% find NaN in data
ind = unique([find(isnan(anom(:,1))==1); find(isnan(anom(:,2))==1)]);
% set mesh linkfile not to calculate NaN pairs:
link = fwd_mesh.link';
link(ind) = 0;
fwd_mesh.link = link';
clear link
% remove NaN from data
ind = setdiff(1:size(anom,1),ind);
anom = anom(ind,:);
clear ind;
anom = reshape(anom',length(anom)*2,1); 

% Initiate projection error
pj_error=zeros(1,iteration);

% Initiate log file
fid_log = fopen([output_fn '.log'],'w');
fprintf(fid_log,'Forward Mesh   = %s\n',fwd_mesh.name);
fprintf(fid_log,'Frequency      = %f MHz\n',frequency);
if ischar(data_fn) ~= 0
    fprintf(fid_log,'Data File      = %s\n',data_fn);
end
if isstruct(lambda)
    fprintf(fid_log,'Initial Regularization  = %d\n',lambda.value);
else
    fprintf(fid_log,'Initial Regularization  = %d\n',lambda);
end
fprintf(fid_log,'Filter         = %d\n',filter_n);
fprintf(fid_log,'Output Files   = %s_mua.sol\n',output_fn);
fprintf(fid_log,'               = %s_mus.sol\n',output_fn);


% start non-linear itertaion image reconstruction part
for it = 1 : iteration
  
  % Calculate jacobian
  [J,data]=jacobian_stnd_bem(fwd_mesh,frequency);

  % Read reference data calculated by initial -current- guess
  clear ref;
  ref = data.paa;
  ref = reshape(ref',length(ref)*2,1);
  
  if length(anom) ~= length(ref)
      errordlg('Data size is incorrect','NIRFAST Error');
      error('Data size is incorrect');
  end
  data_diff = (anom-ref);

  % PJ error
  pj_error(it) = sum(abs(data_diff.^2));
 
  disp('---------------------------------');
  disp(['Iteration Number          = ' num2str(it)]);
  disp(['Projection error          = ' num2str(pj_error(it))]);

  fprintf(fid_log,'---------------------------------\n');
  fprintf(fid_log,'Iteration Number          = %d\n',it);
  fprintf(fid_log,'Projection error          = %f\n',pj_error(it));
  
  if it ~= 1
    p = (pj_error(it-1)-pj_error(it))*100/pj_error(it-1);
    fprintf('Projection error change   = %f %%\n', p);
    fprintf(fid_log,'Projection error change   = %.12g %%\n',p);
    if p <= 2 || (pj_error(it) < (10^-18)) % stopping criteria is currently set at 2% decrease change
      disp('---------------------------------');
      disp('STOPPING CRITERIA REACHED');
      fprintf(fid_log,'---------------------------------\n');
      fprintf(fid_log,'STOPPING CRITERIA REACHED\n');
     break
    end
  end
  
  % Normalize Jacobian
  J = J*diag([fwd_mesh.mua;fwd_mesh.kappa]);
  
  % Add regularization, which decreases at each iteration
  if it ~= 1
    lambda = lambda/10^0.25;
  end
  
  % build hessian
  Hess = (J'*J);

  reg = lambda*max(diag(Hess));
  fprintf(fid_log,'Regularization            = %f\n',reg);
  disp(['Regularization           = ' num2str(reg)]);
  Hess = Hess + reg*eye(length(Hess));
  data_diff = J'*data_diff;
 
  % Calculate update
  foo = (Hess\data_diff);
  delta_mua = foo(1:end/2).*fwd_mesh.mua;
  delta_kappa = foo(end/2+1:end).*fwd_mesh.kappa;

  % Update values
  fwd_mesh.mua = fwd_mesh.mua + delta_mua;
  fwd_mesh.kappa = fwd_mesh.kappa + delta_kappa;
  fwd_mesh.mus = (1./(3.*fwd_mesh.kappa)) - fwd_mesh.mua;
  
  clear foo Hess Hess_norm tmp data_diff G
  
  % We dont like -ve mua or mus! so if this happens, terminate
  if (any(fwd_mesh.mua<0) || any(fwd_mesh.mus<0))
    disp('---------------------------------');
    disp('-ve mua or mus calculated...not saving solution');
    fprintf(fid_log,'---------------------------------\n');
    fprintf(fid_log,'STOPPING CRITERIA REACHED\n');
    break
  end
  
  % Filtering if needed!
  if filter_n > 1
    fwd_mesh = mean_filter(fwd_mesh,abs(filter_n));
  elseif filter_n < 0
    fwd_mesh = median_filter(fwd_mesh,abs(filter_n));
  end

  if it == 1
    fid = fopen([output_fn '_mua.sol'],'w');
  else
    fid = fopen([output_fn '_mua.sol'],'a');
  end
  fprintf(fid,'solution %g ',it);
  fprintf(fid,'-size=%g ',length(fwd_mesh.nodes));
  fprintf(fid,'-components=1 ');
  fprintf(fid,'-type=nodal\n');
  fprintf(fid,'%f ',fwd_mesh.mua);
  fprintf(fid,'\n');
  fclose(fid);
  
  if it == 1
    fid = fopen([output_fn '_mus.sol'],'w');
  else
    fid = fopen([output_fn '_mus.sol'],'a');
  end
  fprintf(fid,'solution %g ',it);
  fprintf(fid,'-size=%g ',length(fwd_mesh.nodes));
  fprintf(fid,'-components=1 ');
  fprintf(fid,'-type=nodal\n');
  fprintf(fid,'%f ',fwd_mesh.mus);
  fprintf(fid,'\n');
  fclose(fid);
end

% close log file!
time = toc;
fprintf(fid_log,'Computation TimeRegularization = %f\n',time);
fclose(fid_log);
