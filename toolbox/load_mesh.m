function mesh = load_mesh(fn)

% mesh = load_mesh(fn)
%
% Loads meshes from specified root name fn
% Must contain *.nodes, *. elem, *.param
% Optional *.source, *.meas, *.link, *.region, *.excoeff
% Mesh can be either:
%               Standard 'stnd'
%               Fluorescence 'fluor'
%               Spectral 'spec'
%               Standard SPN 'stnd_spn'
%               Standard BEM 'stnd_bem'
%               Fluorescence BEM 'fluor_bem'
%               Spectral BEM 'spec_bem'
% 
% fn is the filename of the mesh (with no extension)



% Set mesh name
mesh.name = fn;


%% Read mesh nodes
if exist([fn '.node']) == 0
  errordlg('.node file is not present','NIRFAST Error');
  error('.node file is not present');
elseif exist([fn '.node']) == 2
    mesh.nodes = load(strcat(fn, '.node'));
  mesh.bndvtx = mesh.nodes(:,1); %sets 1 if boundary node, 0 if internal
  mesh.nodes = mesh.nodes(:,2:end);
end


%% Read appriopriate mesh parameters

if exist([fn '.param']) == 0
  errordlg('.param file is not present','NIRFAST Error');
  error('.param file is not present');
  
  % Loading up mesh parameters from fn.param
elseif exist([fn '.param']) == 2
  
  param = importdata([fn '.param']);
  
  % Convert from Version 1
  if isfield(param,'textdata') == 0
    [junk,pa] = size(param);
    % Convert old standard
    if pa == 3
      p.data = param;
      p.textdata = cellstr('stnd');
      % Convert old Fluorescence
    elseif pa == 8
      p.data = param;
      p.textdata = cellstr('fluor');
    else
      errordlg('.param file is incorrectly formatted','NIRFAST Error');
        error('.param file is incorrectly formatted');
    end
    clear param; param = p;
    clear pa junk p
  end
  
  if isfield(param,'textdata') == 1
    % Load standard Nirfast Mesh
    if strcmp(param.textdata(1,1),'stnd') == 1
      mesh.type = 'stnd';
      param = param.data;
      mesh.mua = param(:,1);
      mesh.kappa = param(:,2);
      mesh.ri = param(:,3);
      mesh.mus = ((1./mesh.kappa)./3)-mesh.mua;
      
    % Load standard Fluorfast Mesh
    elseif strcmp(param.textdata(1,1),'fluor') == 1
      mesh.type = 'fluor';
      param = param.data;
      mesh.muax = param(:,1);
      mesh.kappax = param(:,2);
      mesh.musx = ((1./mesh.kappax)./3)-mesh.muax;
      mesh.ri = param(:,3);
      mesh.muam = param(:,4);
      mesh.kappam = param(:,5);
      mesh.musm = ((1./mesh.kappam)./3)-mesh.muam;
      mesh.muaf =  param(:,6);
      mesh.eta =  param(:,7);
      mesh.tau =  param(:,8);
      clear param
      
    % Load standard SPN Mesh
    elseif strcmp(param.textdata(1,1),'stnd_spn') == 1
      mesh.type = 'stnd_spn';
      param = param.data;
      mesh.mua = param(:,1);
      mesh.mus = param(:,2);
      mesh.kappa = 1/(3*(mesh.mua+mesh.mus));
      mesh.kappa = mesh.kappa';
      mesh.g=param(:,3);
      mesh.ri = param(:,4);
      
    % Load standard BEM Mesh
    elseif strcmp(param.textdata(1,1),'stnd_bem') == 1
      mesh.type = 'stnd_bem';
      param = param.data;
      mesh.mua = param(:,1);
      mesh.kappa = param(:,2);
      mesh.ri = param(:,3);
      mesh.mus = ((1./mesh.kappa)./3)-mesh.mua;
      
      % Load fluorescence BEM mesh
    elseif strcmp(param.textdata(1,1),'fluor_bem') == 1
      mesh.type = 'fluor_bem';
      param = param.data;
      mesh.muax = param(:,1);
      mesh.kappax = param(:,2);
      mesh.musx = ((1./mesh.kappax)./3)-mesh.muax;
      mesh.ri = param(:,3);
      mesh.muam = param(:,4);
      mesh.kappam = param(:,5);
      mesh.musm = ((1./mesh.kappam)./3)-mesh.muam;
      mesh.muaf =  param(:,6);
      mesh.eta =  param(:,7);
      mesh.tau =  param(:,8);
      clear param
      
    % Load spectral Mesh (or spectral BEM)
    elseif strcmp(param.textdata(1,1),'spec') || strcmp(param.textdata(1,1),'spec_bem')
      if strcmp(param.textdata(1,1),'spec')
        mesh.type = 'spec';
      elseif strcmp(param.textdata(1,1),'spec_bem')
          mesh.type = 'spec_bem';
      end
      mesh.chromscattlist = param.textdata(2:end,1);
      % Get Scatter Amplitude
      ind = find(strcmpi(mesh.chromscattlist,'S-Amplitude'));
      if isempty(ind)
        disp('Scatter Amplitude not present in *.param file')
        errordlg('S-Amplitude not present in *.param file','NIRFAST Error');
        error('S-Amplitude not present in *.param file');
      else
	mesh.sa = param.data(:,ind);
      end
      % Get Scatter Power
      ind = find(strcmpi(mesh.chromscattlist,'S-Power'));
      if isempty(ind)
	errordlg('S-Power not present in *.param file','NIRFAST Error');
        error('S-Power not present in *.param file');
      else
	mesh.sp = param.data(:,ind);
      end
      % Get Chromophore concentrations
      mesh.conc = [];
      k = 1;
      for i = 1 : length(mesh.chromscattlist)
	if strcmpi(mesh.chromscattlist(i),'S-Amplitude') == 0 & ...
	   strcmpi(mesh.chromscattlist(i),'S-Power') == 0
	  mesh.conc(:,k) = param.data(:,i);
	  k = k + 1;
	end
      end
      clear k
      
      % Get extintion coefficient values
      if exist([fn '.excoef']) ~= 0
	excoef = importdata([fn '.excoef']);
      else
	excoef = importdata('excoef.txt');
      end
      mesh.wv = excoef.data(:,1);
      k = 1;
      for i = 1 : length(mesh.chromscattlist)
	if strcmpi(mesh.chromscattlist(i),'S-Amplitude') == 0 & ...
	   strcmpi(mesh.chromscattlist(i),'S-Power') == 0
	  ind = find(strcmpi(excoef.textdata,mesh.chromscattlist(i,1)));
	  if isempty(ind)
	    errordlg(['The Chromophore ' char(mesh.chromscattlist(i,1)) ...
		  ' is not defined in extinction coefficient file'],'NIRFAST Error');
        error(['The Chromophore ' char(mesh.chromscattlist(i,1)) ...
		  ' is not defined in extinction coefficient file']);
	  else
	    mesh.excoef(:,k) = excoef.data(:,ind+1);
	    k = k + 1;
	  end
	end
      end
    end
  end
end


%% Read mesh element
if exist([fn '.elem']) == 0
  errordlg('.elem file is not present','NIRFAST Error');
        error('.elem file is not present');
elseif exist([fn '.elem']) == 2
  mesh.elements = load(strcat(fn, '.elem'));
  [junk,dim]=size(mesh.elements);
  if strcmp(mesh.type,'stnd_bem') || strcmp(mesh.type,'fluor_bem') || strcmp(mesh.type,'spec_bem')
    mesh.dimension = dim;
  else
    mesh.dimension = dim-1;
  end
  if mesh.dimension == 2
    mesh.nodes(:,3) = 0;
  end
end


%% Region file
if exist([fn '.region']) ~= 0
  mesh.region = load(strcat(fn, '.region'));
elseif exist([fn '.region']) ~= 2
  mesh.region = zeros(length(mesh.nodes),1);
end


%% fix surface orientation for bem meshes
if strcmp(mesh.type,'stnd_bem') || strcmp(mesh.type,'fluor_bem') || strcmp(mesh.type,'spec_bem')
    if ~isfield(mesh,'region')
        errordlg('.region file is not present, required for BEM','NIRFAST Error');
        error('.region file is not present, required for BEM');
    end
    mesh.elements(mesh.region(:,2)==0,:) = ...
        FixPatchOrientation(mesh.nodes,mesh.elements(mesh.region(:,2)==0,:));
    for regn=2:size(unique(mesh.region),1)-1
        mesh.elements(mesh.region(:,2)==regn,:) = ...
            FixPatchOrientation(mesh.nodes,mesh.elements(mesh.region(:,2)==regn,:));
    end
end


%% Load source locations
if exist([fn '.source']) == 0
  disp([fn '.source file is not present']);
elseif exist([fn '.source']) == 2
  source = importdata([fn '.source']);
  if isfield(source,'textdata') == 0
    mesh.source.fixed = 0;
    [ns,nc]=size(source);
    if nc == mesh.dimension
        mesh.source.fwhm = ones(ns,1).*0;
        mesh.source.coord = source;
    elseif nc == mesh.dimension+1
        mesh.source.fwhm = source(:,mesh.dimension+1);
        mesh.source.coord = source(:,1:mesh.dimension);
    end
    if strcmp(mesh.type,'stnd') == 1 || strcmp(mesh.type,'stnd_spn')
      mus_eff = mesh.mus;
    elseif strcmp(mesh.type,'stnd_bem') == 1
        mus_eff = mesh.mus(1);
    elseif strcmp(mesh.type,'fluor') || strcmp(mesh.type,'fluor_bem')
      mus_eff = mesh.musx;
    elseif strcmp(mesh.type,'spec') || strcmp(mesh.type,'spec_bem')
      [mua,mus] = calc_mua_mus(mesh,mesh.wv(1));
      mus_eff = mus;
      clear mua mus
    end
    disp('Moving Sources');
    [mesh]=move_source(mesh,mus_eff,3);
  elseif isfield(source,'textdata') == 1
    mesh.source.fixed = 1;
    [ns,nc]=size(source.data);
    if nc == mesh.dimension
        mesh.source.coord = source.data;
        mesh.source.fwhm = ones(ns,1).*0;
    elseif nc == mesh.dimension+1
        mesh.source.fwhm = source.data(:,mesh.dimension+1);
        mesh.source.coord = source.data(:,1:mesh.dimension);
    end
    disp('Fixed Sources');
    if mesh.dimension == 2
      [ind,int_func] = mytsearchn(mesh,mesh.source.coord(:,1:2));
    elseif mesh.dimension == 3
      [ind,int_func] = mytsearchn(mesh,mesh.source.coord);
    end
    if any(isnan(ind)) == 1
      errordlg('Source(s) outside the mesh; either move them manually or remove ''fixed'' from the source file','NIRFAST Warning');
    end
  end
  clear source mus_eff
end


%% Load detector locations
if exist([fn '.meas']) == 0
  disp([fn '.meas file is not present']);
elseif exist([fn '.meas']) == 2
  meas = importdata([fn '.meas']);
  if isfield(meas,'textdata') == 0
    mesh.meas.fixed = 0;
    mesh.meas.coord = meas;
    disp('Moving Detectors');
    [mesh]=move_detector(mesh);
    if mesh.dimension == 2
      [ind,int_func] = mytsearchn(mesh,mesh.meas.coord(:,1:2));
    elseif mesh.dimension == 3
      [ind,int_func] = mytsearchn(mesh,mesh.meas.coord);
    end
    if any(isnan(ind)) == 1
      errordlg('Detector(s) outside the mesh','NIRFAST Warning');
    else
      mesh.meas.int_func = [ind int_func];
    end
  elseif isfield(meas,'textdata') == 1
    mesh.meas.fixed = 1;
    mesh.meas.coord = meas.data;
    disp('Fixed Detectors');
    if mesh.dimension == 2
      [ind,int_func] = mytsearchn(mesh,mesh.meas.coord(:,1:2));
    elseif mesh.dimension == 3
      [ind,int_func] = mytsearchn(mesh,mesh.meas.coord);
    end
    if any(isnan(ind)) == 1
      errordlg('Detector(s) outside the mesh; either move them manually or remove ''fixed'' from the meas file','NIRFAST Warning');
    else
      mesh.meas.int_func = [ind int_func];
    end
  end
  clear meas
end


%% Load link list for source and detector
if exist([fn '.link']) == 0
  disp([fn '.link file is not present']);
elseif exist([fn '.link']) == 2

  % find max length of detectors for any given source
  fid = fopen([fn '.link']);
  max_length = [];
  k = 1;
  junk = fgetl(fid);
  while junk ~= -1
    junk = length(str2num(junk));
    max_length = max([max_length; junk]);
    k = k + 1;
    junk = fgetl(fid);
  end
  fclose(fid);
  k = k-1;
  
  % create a sparse, so if only some detectors are used for any
  % given source, we are memory efficient!
  mesh.link = sparse(k,max_length);
  fid = fopen([fn '.link']);
  for i = 1 : k
    junk = str2num(fgetl(fid));
    mesh.link(i,1:length(junk)) = junk;
  end
  fclose(fid);
  clear junk i k max_length
end


%% Load identidity list if exists for the internal RI boundary nodes
if exist([fn '.ident']) == 2
  mesh.ident = load(strcat(fn, '.ident'));
end


%% speed of light in medium
% If a spectral mesh, assume Refractive index = 1.33
if strcmp(mesh.type,'spec')
  mesh.ri = ones(length(mesh.nodes),1).*1.33;
elseif strcmp(mesh.type,'spec_bem')
    mesh.ri = ones(size(mesh.sa,1),1).*1.33;
end
mesh.c=(3e11./mesh.ri);

%% Set boundary coefficient using definition of A using the Fresenel's law:
if strcmp(mesh.type,'stnd_spn') ~= 1
    f=0.9;
    Ro=((mesh.ri-1).^2)./((mesh.ri+1).^2);
    thetac=asin(1./mesh.ri);
    cos_theta_c=abs(cos(asin(1./mesh.ri)));
    A=((2./(1-Ro)) - 1 + cos_theta_c.^3) ./ (1 - cos_theta_c.^2);
    mesh.ksi=1./(2*A);
end


%% area of each element
if ~strcmp(mesh.type,'stnd_bem') && ~strcmp(mesh.type,'fluor_bem') && ~strcmp(mesh.type,'spec_bem')
    if mesh.dimension == 2
      mesh.element_area = ele_area_c(mesh.nodes(:,1:2),...
                     mesh.elements);
      mesh.support = mesh_support(mesh.nodes(:,1:2),...
                      mesh.elements,...
                      mesh.element_area);
    elseif  mesh.dimension == 3
      mesh.element_area = ele_area_c(mesh.nodes,mesh.elements);
      mesh.support = mesh_support(mesh.nodes,...
                      mesh.elements,...
                      mesh.element_area);
    end
end
