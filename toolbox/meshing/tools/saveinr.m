function saveinr(vol,fname,stackInfo,write_row_major)
% saveinr(vol,fname)
%
% savesmf: save a surface mesh to INR Format
% write_row_major: if true we'll write in row-major fashion otherwise in
% default col-major
% 
% author: fangq (fangq<at> nmr.mgh.harvard.edu)
% date: 2009/01/04
%
% modified: Hamid Ghadyani hameed <at> dartmouth.edu
% date: 2010/11/08
%       added support to read stack info from Dicom headers
%       added support for row/col major writing
% 
% parameters:
%      vol: input, a binary volume
%      fname: output file name
%

fname = add_extension(fname,'.inr');
fid=fopen(fname,'wb');
if(fid==-1)
   error(' Can''t write file: %s',fname);
end

if(islogical(vol) || isa(vol,'uint8'))
   btype='unsigned fixed';
   dtype='uint8';
   bitlen=8;
elseif(isa(vol,'uint16'))
   btype='unsigned fixed';
   dtype='uint16';
   bitlen=16;	
elseif(isa(vol,'float'))
   btype='float';
   dtype='float';
   bitlen=32;
elseif(isa(vol,'double'))
   btype='float';
   dtype='double';
   bitlen=64;
else
   error('volume format not supported');
end
if nargin>=3
    xpixelsize= stackInfo.PixelSpacing(1);
    ypixelsize= stackInfo.PixelSpacing(2);
    zpixelsize = stackInfo.SliceThickness;
else
    xpixelsize = 1;
    ypixelsize = 1;
    zpixelsize = 1;
end
if nargin >= 4 && write_row_major
    for i=1:size(vol,3)
        out(:,:,i) = (vol(:,:,i))';
    end
%     vol = permute(vol,[2 1 3]);
    vol = out;
end
header=sprintf(['#INRIMAGE-4#{\nXDIM=%d\nYDIM=%d\nZDIM=%d\nVDIM=1\nTYPE=%s\n' ...
  'PIXSIZE=%d bits\nSCALE=2**0\nCPU=decm\nVX=%f\nVY=%f\nVZ=%f\n#GEOMETRY=CARTESIAN\n'],size(vol),btype,bitlen,...
  xpixelsize,ypixelsize,zpixelsize);
header=[header char(10*ones(1,256-4-length(header))) '##}' char(10)];

fwrite(fid,header,'char');
fwrite(fid,vol,dtype);
fclose(fid);
fprintf('  Saved the image stack to: %s\n',fname);
