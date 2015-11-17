function [e p] = run_mmc(img,nrow,ncol,nslice,xypixelsize,zpixelsize,edgesize,outputdir,outputfn)

if ~canwrite(outputdir)
    outputdir = tempdir;
    disp(['No write access, writing here instead: ' [outputdir outputfn]]);
end
mypwd = pwd;
cd(outputdir);

props.dim = 3;
props.mysize = [nrow ncol nslice];
props.fov = [[ncol nrow]*xypixelsize zpixelsize*(nslice-1)];
props.interval = [xypixelsize xypixelsize zpixelsize];
props.orient = 'axis';
props.datatype = 'WORD';
props.endian = 'ieee-le';

mmcfn = 'mmc_imgstack';
m3ctempfn = 'm3cinput.txt';
WriteSPRHeaderInfo(mmcfn,props);

fid = fopen([mmcfn '.sdt'],'wb');
for i=1:nslice
    count = fwrite(fid,(img(:,:,i))','int16');
    assert(count==nrow*ncol);
end



fclose(fid);
%% Run M3C
% set up the input file to M3C
fid = fopen(m3ctempfn,'wt');
fprintf(fid,'%s\n',outputdir);
fprintf(fid,'%s\n',mmcfn);
fprintf(fid,'0\n'); % Specify slice range ?
fprintf(fid,'1\n'); % Cap the output surface ?
fprintf(fid,'1\n'); % Linearize the surface ?
fprintf(fid,'0\n'); % Center the surface ?
% X-Y and Z spacing
xyspacing = round(edgesize/xypixelsize);
zspacing  = round(edgesize/ zpixelsize);
if xyspacing==0, xyspacing=1; end
if zspacing==0,  zspacing=1; end
fprintf(fid,'%d\n%d\n',xyspacing,zspacing);
fprintf(fid,'%s\n',outputfn);
fclose(fid);

systemcommand=GetSystemCommand('m3c');
m3c_cmd=['! "' systemcommand '" < ' m3ctempfn ' > ' tempdir 'm3cjunk.txt'];

fprintf('\n----> Running Marching Cube, please wait...');
eval(m3c_cmd);
fprintf(' done. <----\n\n');

%% Read in the generated surface file and call checkerboard3d
[e p] = read_nod_elm([outputfn '_tetgen'],1);
movefile([outputfn '_tetgen.node'],fullfile(outputdir,[outputfn '.node']));
movefile([outputfn '_tetgen.ele'],fullfile(outputdir,[outputfn '.ele']));

%% Delete extra files
delfiles = {'tmp.elm','tmp.nod','mc_layer.elm','mc_layer.nod','layer.nod',...
             'm3cinput.txt',[mmcfn '.sdt'],[mmcfn '.spr'],...
             [outputfn '_nod.dat'],[outputfn '_elm.dat'],...
             [outputfn '_*.vtk']};
for i=1:length(delfiles)
    delete(delfiles{i});
end

cd(mypwd);
