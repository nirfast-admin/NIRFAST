function [mask info] = GetImageStack(filename,param)
% Tries to read all the 2D image files whose file name is 'filename' plus
% an incremental numbering. Also it can read an image stack from Meta
% It returns a 3D matrix of 'int16' type.
% If param.pad is non-zero, it will add zero padding to four sides of each
% 2D image.

pad = 0;
info=[];
medfilter = 0;
if nargin==2
    if isfield(param,'pad') && param.pad ~= 0
        pad = 1;
    end
    if isfield(param,'medfilter') && param.medfilter ~= 0
        medfilter = 1;
    end
end
[path fnprefix num_flag myext startn endn] = GetFilenameNumbering(filename);
if num_flag==-1 && ~strcmpi(myext,'.mha') && ~strcmpi(myext,'.mhd')
    errordlg('You need more than one 2D mask to create a surface','Meshing Error');
    error('You need more than one 2D mask to create a surface');
end

maskloc = fullfile(path,fnprefix);

if num_flag~=-1 && ~strcmpi(myext,'.mha') && ~strcmpi(myext,'.mhd')
    foo = dir([maskloc '*' myext]);
    if isempty(foo)
        errordlg({'Can not find BMP files:';[fnprefix '*' myext]},'Meshing Error');
        error(['Can not find BMP files: ' fnprefix '*' myext]);
    end

    a = imread([maskloc num2str(num_flag) myext]);
    if ndims(a)==3
        a=rgb2gray(a);
    end
    [nrow ncol]=size(a);
    if pad == 1
        % Add a zero padding to all XY dimensions
        mask = zeros(nrow+2,ncol+2,endn-startn+1,'uint16');
    else
        mask = zeros(nrow, ncol, endn-startn+1,'uint16');
    end

    fprintf('\n  Creating a mask stack from input images...');
    for i=1:(endn-startn+1)
        c = num_flag + i - 1;
        a = imread([maskloc num2str(c) myext]);
        if ndims(a)==3
            a=rgb2gray(a);
        end
        if medfilter == 1
            a = medfilt2(a,[5 5]);
        end
        if pad == 1
            mask(2:end-1,2:end-1,i) = a; % flipdim(a,1);
        else
            mask(:,:,i) = a; % flipdim(a,1);
        end
    end
    fprintf(' done.\n');
    info.NumberOfDimensions = 3;
    info.Dimensions = [nrow ncol endn-startn+1];
else
    info = mha_read_header(filename);
    mask = mha_read_volume(info);
end


