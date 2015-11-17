function V = mha_read_volume(info)
% Function for reading the volume of a Insight Meta-Image (.mha, .mhd) file
% 
% volume = tk_read_volume(file-header)
%
% examples:
% 1: info = mha_read_header()
%    V = mha_read_volume(info);
%    imshow(squeeze(V(:,:,round(end/2))),[]);
%
% 2: V = mha_read_volume('test.mha');
% If you get errors regarding insufficient heap memory when running this
% routine, please consult this Mathworks article:
% http://www.mathworks.com/support/solutions/en/data/1-18I2C/index.html
% 
if(~isstruct(info)), info=mha_read_header(info); end

switch(lower(info.DataFile))
    case 'local'
    otherwise
    % Seperate file
    info.Filename=fullfile(fileparts(info.Filename),info.DataFile);
end
        
% Open file
switch(info.ByteOrder(1))
    case ('true')
        fid=fopen(info.Filename','rb','ieee-be');
    otherwise
        fid=fopen(info.Filename','rb','ieee-le');
end

switch(lower(info.DataFile))
    case 'local'
        % Skip header
        fseek(fid,info.HeaderSize,'bof');
    otherwise
        fseek(fid,0,'bof');
end

no_of_channels_per_voxel = 1;
if isfield(info,'ElementNumberOfChannels')
    no_of_channels_per_voxel = str2double(info.ElementNumberOfChannels);
end
if ~ismember(no_of_channels_per_voxel,[1 3 4])
    fprintf(' Your MHA/MHD image stack is not supported!\n');
    error(' Only 1, 3 or 4 channels per voxel are supported!');
end
datasize=prod(info.Dimensions)*info.BitDepth/8*no_of_channels_per_voxel;

switch(info.CompressedData(1))
    case 'f'
        % Read the Data
        switch(info.DataType)
            case 'char'
                 V = int8(fread(fid,datasize,'char')); 
            case 'uchar'
                V = uint8(fread(fid,datasize,'uchar')); 
            case 'short'
                V = int16(fread(fid,datasize,'short')); 
            case 'ushort'
                V = uint16(fread(fid,datasize,'ushort')); 
            case 'int'
                 V = int32(fread(fid,datasize,'int')); 
            case 'uint'
                 V = uint32(fread(fid,datasize,'uint')); 
            case 'float'
                 V = single(fread(fid,datasize,'float'));   
            case 'double'
                V = double(fread(fid,datasize,'double'));
        end
    case 't'
        switch(info.DataType)
            case 'char', DataType='int8';
            case 'uchar', DataType='uint8';
            case 'short', DataType='int16';
            case 'ushort', DataType='uint16';
            case 'int', DataType='int32';
            case 'uint', DataType='uint32';
            case 'float', DataType='single';
            case 'double', DataType='double';
        end
        Z  = fread(fid,inf,'uchar=>uint8');
        V = zlib_decompress(Z,DataType);

end
fclose(fid);
if no_of_channels_per_voxel == 1
    V = reshape(V,info.Dimensions);
else
    dimensions = [no_of_channels_per_voxel info.Dimensions(:)'];
    warning('nirfast:meshing:readStack','Converting color image to grayscale!');
%     out = zeros([dimensions(3) dimensions(2) dimensions(4)],DataType);
    V = reshape(V,dimensions);
    for i=1:info.Dimensions(3)
        foo = V(1:3,:,:,i);
        foo = permute(foo,[2 3 1]);
        foo = rgb2gray(foo);
%         foo = flipud(foo);
        out(:,:,i) = foo;
    end
    V = out;
end


function M = zlib_decompress(Z,DataType)
% function to inflate MHA files that have compression

if exist('inflate_zlib_mex','file') == 3 % unzipper mex exists
    M = typecast(inflate_zlib_mex(Z),DataType);
else
    import com.mathworks.mlwidgets.io.InterruptibleStreamCopier
    a=java.io.ByteArrayInputStream(Z);
    b=java.util.zip.InflaterInputStream(a);
    isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
    c = java.io.ByteArrayOutputStream;
    isc.copyStream(b,c);
    M=typecast(c.toByteArray,DataType);
end


