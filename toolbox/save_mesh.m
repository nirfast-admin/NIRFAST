function save_mesh(mesh,fn)

% save_mesh(mesh,fn)
%
% where mesh is the structured variable containing mesh information
% and fn is the filename to be saved
% Save mesh as seperate file of *.node, *.elem, *.param, etc
% Input mesh and filename to be saved.



% check if the user reversed the inputs
if ischar(mesh)
    temp = mesh;
    mesh = fn;
    fn = temp;
end

% saving fn.node file
mysave([fn '.node'],[mesh.bndvtx mesh.nodes]);

% saving fn.elem file
mysave([fn '.elem'],mesh.elements);

% saving fn.param file
if strcmp(mesh.type,'stnd') == 1
  data = [mesh.mua mesh.kappa mesh.ri];
elseif strcmp(mesh.type,'stnd_spn') == 1
  data = [mesh.mua mesh.mus mesh.g mesh.ri];
elseif strcmp(mesh.type,'stnd_bem') == 1
  data = [mesh.mua mesh.kappa mesh.ri];
elseif strcmp(mesh.type,'fluor') == 1
  data = [mesh.muax mesh.kappax mesh.ri mesh.muam ...
	  mesh.kappam mesh.muaf mesh.eta mesh.tau];
elseif strcmp(mesh.type,'spec') == 1
  data = [];
  for i = 1 : length(mesh.chromscattlist)
    if strcmpi(mesh.chromscattlist(i),'S-Amplitude') == 0 & ...
       strcmpi(mesh.chromscattlist(i),'S-Power') == 0
      data = [data mesh.conc(:,i)];
    end
  end
  data = [data mesh.sa mesh.sp];
end

[nrow,ncol]=size(data);
fid = fopen([fn '.param'],'w');
fprintf(fid,'%s\n',mesh.type);
if strcmp(mesh.type,'spec') == 1
  for i = 1 : length(mesh.chromscattlist)
    fprintf(fid,'%s\n',char(mesh.chromscattlist(i)));
  end
end
for i = 1 : nrow
  for j = 1 : ncol
    fprintf(fid,'%g ',data(i,j));
  end
  fprintf(fid,'\n',data(i,j));
end
fclose(fid);
clear data

% save extinction file for spec mesh type
if strcmp(mesh.type,'spec') == 1
  data = [mesh.wv mesh.excoef];
  [nrow,ncol]=size(data);
  fid = fopen([fn '.excoef'],'w');
  for i = 1 : length(mesh.chromscattlist)
    fprintf(fid,'%s\n',char(mesh.chromscattlist(i)));
  end
  for i = 1 : nrow
    for j = 1 : ncol
      fprintf(fid,'%g ',data(i,j));
    end
    fprintf(fid,'\n',data(i,j));
  end
  fclose(fid);
end

% saving fn.region file
if isfield(mesh,'region') == 1
  mysave([fn '.region'],mesh.region);
end

% saving fn.source file
if isfield(mesh,'source') == 1
    data = mesh.source.coord;
    [nrow,ncol]=size(data);
    fid = fopen([fn '.source'],'w');
    if mesh.source.fixed == 1
        fprintf(fid,'%s\n','fixed');
    end
    for i = 1 : nrow
        for j = 1 : ncol
            fprintf(fid,'%g ',data(i,j));
        end
        if isfield(mesh.source,'fwhm')
            fprintf(fid,'%g\n',mesh.source.fwhm(i));
        else
            fprintf(fid,'%g\n',0);
        end
    end
    fclose(fid);
    clear data
end

% saving fn.meas file
if isfield(mesh,'meas') == 1
    data = mesh.meas.coord;
    [nrow,ncol]=size(data);
    fid = fopen([fn '.meas'],'w');
    if mesh.meas.fixed == 1
        fprintf(fid,'%s\n','fixed');
    end
    for i = 1 : nrow
        for j = 1 : ncol
            fprintf(fid,'%g ',data(i,j));
        end
        fprintf(fid,'\n',data(i,j));
    end
    fclose(fid);
    clear data
end

% saving fn.link file
if isfield(mesh,'link') == 1
    mysave([fn '.link'],full(mesh.link));
end

% saving fn.ident file
if isfield(mesh,'ident') == 1
  mysave([fn '.ident'],mesh.ident);
end
