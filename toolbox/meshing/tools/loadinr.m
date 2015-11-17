% Copyright (c) 2008 INRIA - Asclepios Project. All rights reserved.
function [A,h]=loadinr(name,slice)
%Load INR format image
%   [A,H] = LOADINR(NAME,SLICE)
%   Input arguments:
%     NAME        filename
%     SLICE       slice numbers, optional, [first slice ,last slice]
%
%   Output arguments:
%     A           image
%     H           header info, image size type etc. [optional]
%
%   Read all slices of image if slice parameter is not given, otherwise
%   read slice SLICE.
%   Specify slice='header' to read only the header, A will be empty.
%
%   Examples
%       A = loadinr('test.inr');        % loads complete image
%       A = loadinr('test.inr',5);      % only loads slice 5 
%       A = loadinr('test.inr',[5:10]); % loads slices 5 to 10 
%       [A,h] = loadinr('test.inr');    % reads image matrix A, 
%    and return information in header in structure h
% 
%   See also WRITEINR, VIEW3D

%   Jonathan Stoeckel & Guillaume Flandin
%   EPIDAURE Project - INRIA Sophia Antipolis - France
%   $Id: loadinr.m,v 1.8 2005/06/07 13:39:49 ocommowi Exp $
%   $Log: loadinr.m,v $
%   Revision 1.8  2005/06/07 13:39:49  ocommowi
%   Vectorial interlaced image format supported
%
%   Revision 1.7  2004/10/08 16:50:27  ocommowi
%   Olivier Commowick
%   Correction bug dans Matlab7
%
%   Revision 1.6  2003/08/20 10:55:45  gflandin
%   slices option in writeinr and cleaning
%
%   Revision 1.5  2003/07/31 07:27:54  gflandin
%   Modified header only option: slice => header
%
%   Revision 1.4  2003/06/02 13:21:37  gflandin
%   Extract Analyze headers using spm_hread
%
%   Revision 1.3  2003/05/27 11:36:40  gflandin
%   Update description
%
%   Revision 1.2  2003/02/27 15:00:39  gflandin
%   Help text, typos
%
%   Revision 1.1.1.1  2003/02/19 17:31:41  jstoecke
%   New image matlab toolbox
%
%   Revision 1.2  2002/07/08 12:15:45  jstoecke
%   Added log
%   

Version ='1.4B';

error(nargchk(1,2,nargin));

%- if input is already an image then no loading is needed
if isnumeric(name)
    A = name;
    return
end

%- check if file exists
if ~exist(name,'file')
    %- check for gz
    if exist([name '.gz'],'file')
        name=[name '.gz'];
    else
        error('[LoadInr] Image file does not exist');
    end
end

%- check for compressed image
if strcmp(name(end-2:end),'.gz')
    h.compressed='gz';
    r_name=[tempname '.inr'];
    %fprintf('Decompressing to %s\n',r_name);
    unix(['gunzip -c ' name ' > ' r_name]);
else
    h.compressed='none';
    r_name=name;
end

%- check for analyze or minc image
if strcmp(r_name(end-3:end),'.img')||strcmp(r_name(end-3:end),'.hdr')...
        ||strcmp(r_name(end-3:end),'.mnc')
    if nargin > 1
        %error('[LoadInr] Option not supported for analyse images');
		%- to come soon...
        h=[];
    end
	[dim, vox, scale, type, offset, origin, descrip] = spm_hread(r_name);
	[pathstr, name, ext] = fileparts(r_name);
	h = struct('xdim',dim(1),...
			   'ydim',dim(2),...
			   'zdim',dim(3),...
			   'vdim',1,...
			   'vx',vox(1),...
			   'vy',vox(2),...
			   'vz',vox(3),...
			   'scale',scale,...
			   'mtype',spm_type(type),...
			   'name',r_name,...
			   'path',pathstr,...
			   'shortname',[name ext]);
    A = spm_read_vols(spm_vol(r_name));
    return
end

fid = fopen(r_name,'r');
if (fid > 0)
  
  %- allocate buffer
  [header,count]=fread(fid,256,'char');
  header=char(header)';
  if(count~=256)
    error('[LoadInr] Fatal image read problem (%s).',name)
  end
  if(~strcmp(header(1:12),'#INRIMAGE-4#'))
    error('[LoadInr] Unknown image type (%s).',name)
  end
  h.version=header(2:11);

  while isempty(strfind(header,'##}'))
    [head,count]=fread(fid,256,'char');
    if(count~=256)
      error('[LoadInr] Fatal image read problem (%s).',name)
    end
    header=[header char(head)'];
  end
  
  % x dimension
  pos=strfind(header,'XDIM=');
  if(isempty(pos)||size(pos,2)~=1)
    error('[LoadInr] Invalid header XDIM (%s).',name);
  end
  pos_=find(0+header(pos:end)==10);
  h.xdim=str2num(header(pos+5:pos_(1)-2+pos));
  if isempty(h.xdim)
    error('[LoadInr] Invalid XDIM (%s).',name);
  end
  
  % y dimension
  pos=strfind(header,'YDIM=');
  if(isempty(pos)||size(pos,2)~=1)
    error('[LoadInr] Invalid header YDIM (%s).',name);
  end
  pos_=find(0+header(pos:end)==10);
  h.ydim=str2num(header(pos+5:pos_(1)-2+pos));
  if isempty(h.ydim)
    error('[LoadInr] Invalid YDIM (%s).',name);
  end 
  
  % z dimension
  pos=strfind(header,'ZDIM=');
  if(isempty(pos)||size(pos,2)~=1)
    error('[LoadInr] Invalid header ZDIM (%s).',name);
  end
  pos_=find(0+header(pos:end)==10);
  h.zdim=str2num(header(pos+5:pos_(1)-2+pos));
  if isempty(h.zdim)
    error('[LoadInr] Invalid ZDIM (%s).',name);
  end 
  
  % v dimension
  pos=strfind(header,'VDIM=');
  if(isempty(pos)||size(pos,2)~=1)
    error('[LoadInr] Invalid header VDIM (%s).',name);
  end
  pos_=find(0+header(pos:end)==10);
  h.vdim=str2num(header(pos+5:pos_(1)-2+pos));
  if isempty(h.vdim)
    error('[LoadInr] Invalid VDIM (%s).',name);
  end
%  if h.vdim~=1
%    error(sprintf('[LoadInr] Only scalar images supported (%s).',name)); 
%  end
  
  % image type
  pos=strfind(header,'TYPE=');
  if(isempty(pos)||size(pos,2)~=1)
    error('[LoadInr] Invalid header TYPE (%s).',name);
  end
  pos_=find(0+header(pos:end)==10);
  h.type=(header(pos+5:pos_(1)-2+pos));
  if isempty(h.type)
    error('[LoadInr] Invalid TYPE (%s).',name);
  end 
  switch h.type
  case 'unsigned fixed'
    ty = 'uint';
  case 'float'
    ty= 'float';
  case 'signed fixed'
    ty= 'int';
  otherwise
    error('[LoadInr] Unknown image type (%s).',name); 
  end
  
  
  % number of bits
  pos=strfind(header,'PIXSIZE=');
  if(isempty(pos)||size(pos,2)~=1)
    error('[LoadInr] Invalid header PIXSIZE (%s).',name);
  end
  pos_=find(0+header(pos:end)==32);
  h.pixsize=(header(pos+8:pos_(1)-2+pos));
  if isempty(h.pixsize)
    error('[LoadInr] Invalid PIXSIZE (%s).',name);
  end 
  ty=[ty h.pixsize];
  switch h.pixsize
  case '8'
    sy=1;
  case '16'
    sy=2;
  case '32'
    sy=4;
  case '64'
    sy=8;
  otherwise
    error('[LoadInr] Unknown number of bits (%s).',name);
  end
  h.pixbytesize=sy;
  h.mtype=ty;
  
  % cpu name
  pos=strfind(header,'CPU=');
  if(isempty(pos)||size(pos,2)~=1);
    error('[LoadInr] Invalid header CPU (%s).',name);
  end
  pos_=find(0+header(pos:end)==10);
  h.cpu=(header(pos+4:pos_(1)-2+pos));
  if isempty(h.cpu)
    error('[LoadInr] Invalid CPU (%s).',name);
  end 
  switch h.cpu
  case 'decm'
    m_format='ieee-le';
  case 'sun'
    m_format='ieee-be';
  otherwise
    error('[LoadInr] Unknown machine type (%s).',name);
  end
  
  % ***************************************
  % Extra fields, not needed to read image
  % ***************************************
  % x pixelsize
  pos=strfind(header,'VX=');
  if(length(pos)>1)
    error('[LoadInr] Invalid header VX (%s).',name);
  end
  if(~isempty(pos))
    pos_=find(0+header(pos:end)==10);
    h.vx=str2num(header(pos+3:pos_(1)-2+pos));
    if isempty(h.vx)
      error('[LoadInr] Invalid VX (%s).',name);
    end 
  end
  % y pixelsize
  pos=strfind(header,'VY=');
  if(length(pos)>1)
    error('[LoadInr] Invalid header VY (%s).',name);
  end
  if(~isempty(pos))
    pos_=find(0+header(pos:end)==10);
    h.vy=str2num(header(pos+3:pos_(1)-2+pos));
    if isempty(h.vy)
      error('[LoadInr] Invalid VY (%s).',name);
    end 
  end
  % z pixelsize
  pos=findstr(header,'VZ=');
  if(length(pos)>1)
    error(sprintf('[LoadInr] Invalid header VZ (%s).',name));
  end
  if(~isempty(pos))
    pos_=find(0+header(pos:end)==10);
    h.vz=str2num(header(pos+3:pos_(1)-2+pos));
    if isempty(h.vz)
      error(sprintf('[LoadInr] Invalid VZ (%s).',name));
    end 
  end
  % scale
  pos=findstr(header,'SCALE=');
  if(length(pos)>1)
    error(sprintf('[LoadInr] Invalid header SCALE (%s).',name));
  end
  if(~isempty(pos))
    pos_=find(0+header(pos:end)==10);
    h.scale=header(pos+6:pos_(1)-2+pos);
    if isempty(h.scale)
      error(sprintf('[LoadInr] Invalid SCALE (%s).',name));
    end 
  end
  
  % find commentlines
  com=[char(10) '#'];
  pos=findstr(header,com);
  % store comments in struct not yet implemented
  
  
  
  % Store name in header structure
  h.name=name;
  [h.path,h.shortname,h.ext] = fileparts(h.name);
  
  % save file position, close file, reopen in 
  % in specified machine mode
  fpos=ftell(fid);
  fclose(fid);
  % store image data offset (in bytes) in header structure
  h.offset=fpos;
  
  if(nargin>1)
    if(ischar(slice))
      switch slice
        %read header only
      case 'header'
        A=[];
        return
      otherwise
        error('[LoadInr] Invalid option');
      end
    end
  end
        
  
  fid=fopen(r_name,'r',m_format);
  
 
  % read only slice asked for
  if(nargin>1)
    if(h.vdim~=1)
      error('[LoadInr] Vectorial Slice loading not yet supported');
    end
    if(length(slice)>2)
      error('[LoadInr] Invalid slice specification, [start slice, end slice]');
    end
    if(length(slice)==1)
      slice(2)=slice(1);
    else
      if(slice(1)>slice(2))
        error('[LoadInr] Invalid slice order');
      end
    end
    if((slice(1)>0)&&(slice(2)<=h.zdim))
      fseek(fid,fpos+(h.xdim*h.ydim*h.pixbytesize*(slice(1)-1)),-1);
      [B,count]=fread(fid,h.xdim*h.ydim*(slice(2)-slice(1)+1),ty);
      % check if all bytes could be read
      if(count~=(h.xdim*h.ydim*(slice(2)-slice(1)+1)))
        error('[LoadInr] Image size problem');
      end
      A=reshape(B,h.xdim,h.ydim,slice(2)-slice(1)+1)';
    else
      error('[LoadInr] Invalid slice number')
    end
  else
    % read complete image
    fseek(fid,fpos,-1);
    s=h.xdim*h.ydim*h.zdim*h.vdim;
    [B,count]=fread(fid,s,ty);
    % check if all bytes could be read
    if(count~=s)
      error('[LoadInr] Image size problem');
    end
    if(h.vdim==1)
      A=reshape(B,h.xdim,h.ydim,h.zdim);
    else
      A=permute(reshape(B,h.vdim,h.xdim,h.ydim,h.zdim),[2,3,4,1]);
    end
    %A=permute(reshape(B,h.xdim,h.ydim,h.zdim),[2,1,3]);
  end
  fclose(fid);
else
  error('[LoadInr] Image ''%s'' could not be opened',name);
end

if strcmp(h.compressed,'gz')
    if ~strcmp(r_name,name)
        unix(['\rm -f ' r_name]);
    end
end
