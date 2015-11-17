% Copyright (c) 2008 INRIA - Asclepios Project. All rights reserved.
function writeinr(inrfile,data,type,voxelsize,slices)
%Write down an image as an Inrimage file
%   WRITEINR(INRFILE, DATA, TYPE, VOXELSIZE, SLICES)
%   Input arguments:
%     INRFILE - filename
%     DATA    - data matrix
%     TYPE    - type of image
%                 'float_vec'
%                 'double_vec'
%                 'float32'
%                 'float64'
%                 'uint8'
%                 'int16'
%                 'uint16'
%
%   Optional arguments:
%     VOXELSIZE - three element array with voxel sizes e.g. [0.5 0.5 1.2]
%     SLICES    - slices indices to be written e.g. [5 10 15 20]
%                 data must be a [x y length(slices)] tridimensional array
%                 the inr file must still be present
%
%   Always writes images in little endian byte ordering (DEC)
%   
%   Example
%       writeinr('Image1',A,'float32');
%   creates Image1.inr with data in matrix A of type float32.
%
%   See also LOADINR, VIEW3D

%   Jonathan Stoeckel & Guillaume Flandin
%   EPIDAURE Project - INRIA Sophia Antipolis - France
%   $Id: writeinr.m,v 1.6 2005/07/28 13:50:02 ocommowi Exp $
%   $Log: writeinr.m,v $
%   Revision 1.6  2005/07/28 13:50:02  ocommowi
%   writeinr now supports writing of interlaced vector images
%
%   Revision 1.5  2003/08/20 10:55:45  gflandin
%   slices option in writeinr and cleaning
%

error(nargchk(3,5,nargin));

if isempty(strfind(inrfile,'.inr'))
	inrfile = [inrfile '.inr'];
end

dimx = size(data,1);
dimy = size(data,2);
dimz = size(data,3);
dimv = 1;
if (size(size(data),2) == 4)
  dimv = size(data,4);
end

if (dimv ~= 1)
  if ( strcmp(type,'float_vec')~=1 & strcmp(type,'double_vec')~=1 )
    error('[WriteInr] Image format is not supported');
  end
end

if nargin ~= 5
	% -- open file using little-endian byte ordering -- %
	fid = fopen(inrfile,'w','ieee-le');
	if fid == -1, 
		error(sprintf('[WriteInr] Cannot open %s.',inrfile));
	end
	
	% -- write header -- %
	fprintf( fid, '#INRIMAGE-4#{\n');
	fprintf( fid, 'XDIM=%d\n', dimx);
	fprintf( fid, 'YDIM=%d\n', dimy);
	fprintf( fid, 'ZDIM=%d\n', dimz);
	fprintf( fid, 'VDIM=%d\n', dimv); % data could be a cell array
	                               % to handle vectorial images
    
	switch lower(type)   
                case {'float32','single','float','float_vec'}
			fprintf( fid, 'TYPE=%s\n', 'float');
			fprintf( fid, 'PIXSIZE=%d bits\n', 32);
                        type = 'float';
		case {'float64','double','double_vec'}
			fprintf( fid, 'TYPE=%s\n', 'float');
			fprintf( fid, 'PIXSIZE=%d bits\n', 64);
                        type = 'double';
		case 'uint8'
			fprintf( fid, 'TYPE=%s\n', 'unsigned fixed');
			fprintf( fid, 'PIXSIZE=%d bits\n', 8);
			fprintf( fid, 'SCALE=2**0\n');
		case 'int16'
			fprintf( fid, 'TYPE=%s\n', 'signed fixed');
			fprintf( fid, 'PIXSIZE=%d bits\n', 16);
			fprintf( fid, 'SCALE=2**0\n');
		case 'uint16'
			fprintf( fid, 'TYPE=%s\n', 'unsigned fixed');
			fprintf( fid, 'PIXSIZE=%d bits\n', 16);
			fprintf( fid, 'SCALE=2**0\n');
		otherwise    
			error('[WriteInr] Image format is not supported');
	end
    
	fprintf( fid, 'CPU=decm\n');
	if nargin >= 4
		fprintf(fid,'VX=%f\n',voxelsize(1));
		fprintf(fid,'VY=%f\n',voxelsize(2));
		fprintf(fid,'VZ=%f\n',voxelsize(3));
	end

	fprintf( fid, '#*[H]*< 1>  \n\n\n\n');
	status = ftell( fid );
	if  status <  0 
		fclose(fid);
		error( '[WriteInr] Writing error.');
	end
    
	for i = status:251
		fprintf(fid,'\n');
	end
    
	fprintf( fid, '##}\n' );
    
        count = 0;
        if (dimv == 1)
          % -- write data -- %
          count = fwrite( fid, data, type);
        else
          data = permute(data,[4,1,2,3]);
          count = fwrite( fid, data, type);
        end
    
	if count < dimx*dimy*dimz*dimv
		error('[WriteInr] Could not write complete image.');
	end
	
	% -- close file -- %
	fclose(fid);
	
else
	% -- read header -- %
	if ~exist(fullfile(pwd,inrfile),'file')
		error('[WriteInr] Image must exist before writing slices.');
	end
	[E, h] = loadinr(inrfile,'header');
	switch h.cpu
		case 'decm'
			m_format='ieee-le';
		case 'sun'
			m_format='ieee-be';
		otherwise
			error(sprintf('[WriteInr] Unknown machine type (%s).',h.cpu));
	end
	if (h.xdim ~= size(data,1)) | ...
		 (h.ydim ~= size(data,2)) | ...
		 (length(slices) ~= size(data,3))
		error('[WriteInr] Invalid data size.');
	end
	if ~all(slices > 0) | ~all(slices <= h.zdim)
		error('[WriteInr] Slices do not fit volume.');
	end
	
	% -- open file -- %
	fid = fopen(inrfile, 'r+', m_format);
	if fid == -1, 
		error(sprintf('[WriteInr] Cannot open %s.',inrfile));
	end
	
	% -- write data -- %
	for i=1:length(slices)
		fseek(fid,h.offset+(h.xdim*h.ydim*h.pixbytesize*(slices(i)-1)),-1);
		count = fwrite(fid, data(:,:,i), h.mtype);
	
		if count < size(data,1) * size(data,2)
			error('[WriteInr] Could not write complete image.');
		end
	end
	
	% -- close file -- %
	fclose(fid);
end
