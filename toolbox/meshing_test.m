function result = meshing_test()
% function result = meshing_test()
% Performs mesh creation, forward solution, reconstruction and mesh
% optimization on variety of mesh types.
% result:
% .passed cell array of 0 and 1 for fail and pass
% .message cell array of exceptions if errors occured
% .testname cell array containing name of the test
% 
% for example if a test passes then:
% result.message{idx} is empty and result.passed{idx} == 1
% otherwise:
% result.message{idx} would be something similar to:
%   identifier: 'MATLAB:FileIO:InvalidFid'
%   message: 'Invalid file identifier.  Use fopen to generate a valid file identifier.'
%   cause: {0x1 cell}
%   stack: [6x1 struct]
% and
% result.passed{idx} == 0
% 
% Written by Hamid Ghadyani, 2011
% hamidreza.ghadyani@dartmouth.edu
% Updated on Aug 2012
% 

foo = which('nirfast');
if isempty(foo)
    error(' Can''t find nirfast main script.')
end
foo = regexp(fileparts(foo),filesep,'split');
nirfastroot = fullfile(foo{1:end-1});
if ~ispc
    nirfastroot = [filesep nirfastroot];
end

if ~exist([tempdir filesep 'nirfast'],'dir')
    mkdir([tempdir filesep 'nirfast']);
end

%% Stnd circle; 
testname = 'Stnd circle';
test_no = 1;
try
    sizevar.xc=0;
    sizevar.yc=0;
    sizevar.r=35;
    sizevar.dist=0.875;
    create_mesh(fullfile(tempdir,'nirfast','Circle-stnd-mesh'),'Circle',sizevar,'stnd');
    clear sizevar
    mesh_tmp = load_mesh(fullfile(tempdir,'nirfast','Circle-stnd-mesh'));
    mesh_tmp.link =[ 1 1 1; 1 2 1; 1 3 1; 2 1 1; 2 2 1; 2 3 1;];
    mesh_tmp.source.coord =[-29.8697 20.5606;-19.0075 30.065];
    mesh_tmp.source.num = (1:size([-29.8697 20.5606;-19.0075 30.065],1))';
    mesh_tmp.source.fwhm = zeros(size([-29.8697 20.5606;-19.0075 30.065],1),1);
    mesh_tmp.source.fixed =0;
    mesh_tmp.source.distributed =0;
    mesh_tmp.meas.coord =[30.2603 -17.845;27.1568 22.6942;-34.7189 -7.1768];
    mesh_tmp.meas.num = (1:size([30.2603 -17.845;27.1568 22.6942;-34.7189 -7.1768],1))';
    mesh_tmp.meas.fixed =0;
    mesh_tmp = minband_opt(mesh_tmp);
    save_mesh(mesh_tmp,fullfile(tempdir,'nirfast','Circle-stnd-mesh'));
    clear mesh_tmp
    mesh = load_mesh(fullfile(tempdir,'nirfast','Circle-stnd-mesh'));
    mesh_data = femdata(mesh,100);
    plotimage(mesh,log(mesh_data.phi(:,1))); pause(0.2);
    plot_data(mesh_data);
catch err
    result.passed{test_no} = 0;
    result.message{test_no}.identifier = err.identifier;
    result.message{test_no}.message = err.message;
    result.message{test_no}.cause = err.cause;
    result.message{test_no}.stack = err.stack;
    result.testname{test_no} = testname;
end
if ~exist('err','var')
    result.passed{test_no} = 1;
    result.message{test_no} = [];
    result.testname{test_no} = testname;
end
clear err mesh sizevar mesh_tmp mesh_data; close all
%% fluor slab; 
testname = 'fluor slab';
test_no = 2;
try
    sizevar.xc=0;
    sizevar.yc=0;
    sizevar.zc=0;
    sizevar.width=200;
    sizevar.height=200;
    sizevar.depth=200;
    sizevar.dist=15;
    create_mesh(fullfile(tempdir,'nirfast','Slab-fluor-mesh'),'Slab',sizevar,'fluor');
    clear sizevar
    mesh_tmp = load_mesh(fullfile(tempdir,'nirfast','Slab-fluor-mesh'));
    mesh_tmp.link =[ 1 1 1; 1 2 1; 1 3 1; 1 4 1; 2 1 1; 2 2 1; 2 3 1; 2 4 1; 3 1 1; 3 2 1; 3 3 1; 3 4 1; 4 1 1; 4 2 1; 4 3 1; 4 4 1;];
    mesh_tmp.source.coord =[-100 35.214 -15.0422;-100 -4.6986 -17.1072;-54.5059 -100 -2.2618;43.4336 -100 -14.735];
    mesh_tmp.source.num = (1:size([-100 35.214 -15.0422;-100 -4.6986 -17.1072;-54.5059 -100 -2.2618;43.4336 -100 -14.735],1))';
    mesh_tmp.source.fwhm = zeros(size([-100 35.214 -15.0422;-100 -4.6986 -17.1072;-54.5059 -100 -2.2618;43.4336 -100 -14.735],1),1);
    mesh_tmp.source.fixed =0;
    mesh_tmp.source.distributed =0;
    mesh_tmp.meas.coord =[-77.6771 23.8849 96;-54.627 -28.2329 96;21.6316 -55.0849 96;46.1414 16.1083 96];
    mesh_tmp.meas.num = (1:size([-77.6771 23.8849 96;-54.627 -28.2329 96;21.6316 -55.0849 96;46.1414 16.1083 96],1))';
    mesh_tmp.meas.fixed =0;
    mesh_tmp = minband_opt(mesh_tmp);
    save_mesh(mesh_tmp,fullfile(tempdir,'nirfast','Slab-fluor-mesh'));
    clear mesh_tmp
    mesh = load_mesh(fullfile(tempdir,'nirfast','Slab-fluor-mesh'));
    mesh_data = femdata(mesh,0);
    plot_data(mesh_data);
catch err
    result.passed{test_no} = 0;
    result.message{test_no}.identifier = err.identifier;
    result.message{test_no}.message = err.message;
    result.message{test_no}.cause = err.cause;
    result.message{test_no}.stack = err.stack;
    result.testname{test_no} = testname;
end
if ~exist('err','var')
    result.passed{test_no} = 1;
    result.message{test_no} = [];
    result.testname{test_no} = testname;
end
clear err mesh sizevar mesh_tmp mesh_data; close all
%% spn cylinder; 
testname = 'spn cylinder';
test_no = 3;
try
    sizevar.xc=0;
    sizevar.yc=0;
    sizevar.zc=0;
    sizevar.r=50;
    sizevar.height=80;
    sizevar.dist=4;
    create_mesh(fullfile(tempdir,'nirfast','Cylinder-stnd_spn-mesh'),'Cylinder',sizevar,'stnd_spn');
    clear sizevar
    mesh_tmp = load_mesh(fullfile(tempdir,'nirfast','Cylinder-stnd_spn-mesh'));
    mesh_tmp.link =[ 1 1 1; 1 2 1; 1 3 1; 2 1 1; 2 2 1; 2 3 1; 3 1 1; 3 2 1; 3 3 1; 4 1 1; 4 2 1; 4 3 1;];
    mesh_tmp.source.coord =[-47.4087 -15.8675 1.8794;-36.4819 -34.1897 0.23843;-9.5539 -49.0733 2.5349;2.9935 -49.9091 17.4818];
    mesh_tmp.source.num = (1:size([-47.4087 -15.8675 1.8794;-36.4819 -34.1897 0.23843;-9.5539 -49.0733 2.5349;2.9935 -49.9091 17.4818],1))';
    mesh_tmp.source.fwhm = zeros(size([-47.4087 -15.8675 1.8794;-36.4819 -34.1897 0.23843;-9.5539 -49.0733 2.5349;2.9935 -49.9091 17.4818],1),1);
    mesh_tmp.source.fixed =0;
    mesh_tmp.source.distributed =0;
    mesh_tmp.meas.coord =[-37.4107 -20.3876 38.75;-14.1736 -16.6681 38.75;18.5119 -12.9489 38.75];
    mesh_tmp.meas.num = (1:size([-37.4107 -20.3876 38.75;-14.1736 -16.6681 38.75;18.5119 -12.9489 38.75],1))';
    mesh_tmp.meas.fixed =0;
    mesh_tmp = minband_opt(mesh_tmp);
    save_mesh(mesh_tmp,fullfile(tempdir,'nirfast','Cylinder-stnd_spn-mesh'));
    clear mesh_tmp
    mesh = load_mesh(fullfile(tempdir,'nirfast','Cylinder-stnd_spn-mesh'));
    mesh_data = femdata_sp5(mesh,100);
    plot_data(mesh_data);
catch err
    result.passed{test_no} = 0;
    result.message{test_no}.identifier = err.identifier;
    result.message{test_no}.message = err.message;
    result.message{test_no}.cause = err.cause;
    result.message{test_no}.stack = err.stack;
    result.testname{test_no} = testname;
end
if ~exist('err','var')
    result.passed{test_no} = 1;
    result.message{test_no} = [];
    result.testname{test_no} = testname;
end
clear err mesh sizevar mesh_tmp mesh_data; close all
%% 2D mask2mesh spec; 
testname = '2D mask2mesh spec';
test_no = 4;
try
    mask2mesh_2D(fullfile(nirfastroot,'meshes/meshing examples/Masks/3026_42.bmp'),0.5,1,1.5,fullfile(tempdir,'nirfast','spec-2D'),'spec');
    mesh_tmp = load_mesh(fullfile(tempdir,'nirfast','spec-2D'));
    mesh_tmp.link =[ 1 1 1; 1 2 1; 1 3 1; 2 1 1; 2 2 1; 2 3 1; 3 1 1; 3 2 1; 3 3 1;];
    mesh_tmp.source.coord =[55.3041 174.8513;54.5642 152.1622;84.1588 185.0861];
    mesh_tmp.source.num = (1:size([55.3041 174.8513;54.5642 152.1622;84.1588 185.0861],1))';
    mesh_tmp.source.fwhm = zeros(size([55.3041 174.8513;54.5642 152.1622;84.1588 185.0861],1),1);
    mesh_tmp.source.fixed =0;
    mesh_tmp.source.distributed =0;
    mesh_tmp.meas.coord =[100.0658 144.5169;104.3817 149.4494;110.4239 156.4781];
    mesh_tmp.meas.num = (1:size([100.0658 144.5169;104.3817 149.4494;110.4239 156.4781],1))';
    mesh_tmp.meas.fixed =0;
    mesh_tmp = minband_opt(mesh_tmp);
    save_mesh(mesh_tmp,fullfile(tempdir,'nirfast','spec-2D'));
    clear mesh_tmp
    mesh = load_mesh(fullfile(tempdir,'nirfast','spec-2D'));
    set_chromophores(fullfile(tempdir,'nirfast','spec-2D'),{'HbO';'deoxyHb';'Water';},[661 735 740 780]);
    mesh = load_mesh(fullfile(tempdir,'nirfast','spec-2D'));
    val.sa=1;
    val.sp=1;
    val.HbO=0.04;
    val.deoxyHb=0.02;
    val.Water=0.7;
    mesh = set_mesh(mesh,228,val);
    mesh_data = femdata(mesh,100);
    plot_data(mesh_data);
    plotmesh(mesh,1);
catch err
    result.passed{test_no} = 0;
    result.message{test_no}.identifier = err.identifier;
    result.message{test_no}.message = err.message;
    result.message{test_no}.cause = err.cause;
    result.message{test_no}.stack = err.stack;
    result.testname{test_no} = testname;
end
if ~exist('err','var')
    result.passed{test_no} = 1;
    result.message{test_no} = [];
    result.testname{test_no} = testname;
end
clear err mesh sizevar mesh_tmp mesh_data; close all
%% 3D mask2mesh stnd; 
testname = '3D mask2mesh stnd';
test_no = 5;
try
    MMC(fullfile(nirfastroot,'meshes/meshing examples/Masks/3026_1.bmp'),1,1,6,fullfile(tempdir,'nirfast','temp_node_ele'));
    checkerboard3dmm_wrapper(fullfile(tempdir,'nirfast','temp_node_ele.ele'),fullfile(tempdir,'nirfast','stnd-mesh'),'stnd',6);
    mesh_tmp = load_mesh(fullfile(tempdir,'nirfast','stnd-mesh'));
    mesh_tmp.link =[ 1 1 1; 1 2 1; 1 3 1; 1 4 1; 1 5 1; 2 1 1; 2 2 1; 2 3 1; 2 4 1; 2 5 1;];
    mesh_tmp.source.coord =[208.5242 329.5629 58.4758;165.7567 318.1635 113.1206];
    mesh_tmp.source.num = (1:size([208.5242 329.5629 58.4758;165.7567 318.1635 113.1206],1))';
    mesh_tmp.source.fwhm = zeros(size([208.5242 329.5629 58.4758;165.7567 318.1635 113.1206],1),1);
    mesh_tmp.source.fixed =0;
    mesh_tmp.source.distributed =0;
    mesh_tmp.meas.coord =[140.2255 324.5516 9.5251;126.2599 321.356 20.7401;107.7511 324.8719 45.2489;94.0493 318.6427 58.9507;83.9054 311.4279 75.0946];
    mesh_tmp.meas.num = (1:size([140.2255 324.5516 9.5251;126.2599 321.356 20.7401;107.7511 324.8719 45.2489;94.0493 318.6427 58.9507;83.9054 311.4279 75.0946],1))';
    mesh_tmp.meas.fixed =0;
    mesh_tmp = minband_opt(mesh_tmp);
    save_mesh(mesh_tmp,fullfile(tempdir,'nirfast','stnd-mesh'));
    clear mesh_tmp
    mesh = load_mesh(fullfile(tempdir,'nirfast','stnd-mesh'));
    val.mua=0.03;
    val.mus=1;
    mesh = set_mesh(mesh,228,val);
    mesh_data = femdata(mesh,100);
    plotimage(mesh,log(mesh_data.phi(:,1))); pause(0.2);
    plotimage(mesh,log(mesh_data.phi(:,2))); pause(0.2);
    plot_data(mesh_data);
    plotmesh(mesh,1);
catch err
    result.passed{test_no} = 0;
    result.message{test_no}.identifier = err.identifier;
    result.message{test_no}.message = err.message;
    result.message{test_no}.cause = err.cause;
    result.message{test_no}.stack = err.stack;
    result.testname{test_no} = testname;
end
if ~exist('err','var')
    result.passed{test_no} = 1;
    result.message{test_no} = [];
    result.testname{test_no} = testname;
end
clear err mesh sizevar mesh_tmp mesh_data; close all
%% 3D mask2mesh stnd bem; 
testname = '3D mask2mesh stnd bem';
test_no = 6;
try
    MMC(fullfile(nirfastroot,'meshes/meshing examples/Masks/3026_1.bmp'),1,1,5,fullfile(tempdir,'nirfast','temp_node_ele'));
    surf2nirfast_bem(fullfile(tempdir,'nirfast','temp_node_ele.ele'),fullfile(tempdir,'nirfast','stnd_bem-mesh'),'stnd_bem');
    mesh_tmp = load_mesh(fullfile(tempdir,'nirfast','stnd_bem-mesh'));
    mesh_tmp.link =[ 1 1 1; 1 2 1; 2 1 1; 2 2 1; 3 1 1; 3 2 1;];
    mesh_tmp.source.coord =[101.1685 317.6274 127.7284;134.0744 316.5744 130.9256;184.3546 296.3043 93.1454];
    mesh_tmp.source.num = (1:size([101.1685 317.6274 127.7284;134.0744 316.5744 130.9256;184.3546 296.3043 93.1454],1))';
    mesh_tmp.source.fwhm = zeros(size([101.1685 317.6274 127.7284;134.0744 316.5744 130.9256;184.3546 296.3043 93.1454],1),1);
    mesh_tmp.source.fixed =0;
    mesh_tmp.source.distributed =0;
    mesh_tmp.meas.coord =[100.5019 282.5 55.238;134.2514 282.5 33.2218];
    mesh_tmp.meas.num = (1:size([100.5019 282.5 55.238;134.2514 282.5 33.2218],1))';
    mesh_tmp.meas.fixed =0;
    mesh_tmp = minband_opt(mesh_tmp);
    save_mesh(mesh_tmp,fullfile(tempdir,'nirfast','stnd_bem-mesh'));
    clear mesh_tmp
    mesh = load_mesh(fullfile(tempdir,'nirfast','stnd_bem-mesh'));
    mesh_data = bemdata_stnd(mesh,100);
    plot_data(mesh_data);
    figure;trisurf(mesh.elements,mesh.nodes(:,1),mesh.nodes(:,2),mesh.nodes(:,3),log(mesh_data.phi(:,3)))
    shading interp
    axis equal
catch err
    result.passed{test_no} = 0;
    result.message{test_no}.identifier = err.identifier;
    result.message{test_no}.message = err.message;
    result.message{test_no}.cause = err.cause;
    result.message{test_no}.stack = err.stack;
    result.testname{test_no} = testname;
end
if ~exist('err','var')
    result.passed{test_no} = 1;
    result.message{test_no} = [];
    result.testname{test_no} = testname;
end
clear err mesh sizevar mesh_tmp mesh_data; close all
%% 3D mask2mesh spect bem; 
testname = '3D mask2mesh spect bem';
test_no = 7;
try
    MMC(fullfile(nirfastroot,'meshes/meshing examples/Masks/3026_2.bmp'),1,1,5,fullfile(tempdir,'nirfast','temp_node_ele'));
    surf2nirfast_bem(fullfile(tempdir,'nirfast','temp_node_ele.ele'),fullfile(tempdir,'nirfast','spec_bem-mesh'),'spec_bem');
    mesh_tmp = load_mesh(fullfile(tempdir,'nirfast','spec_bem-mesh'));
    mesh_tmp.link =[ 1 1 1; 1 2 1; 2 1 1; 2 2 1;];
    mesh_tmp.source.coord =[107.2232 329.4735 122.069;161.6671 375.8329 61.7013];
    mesh_tmp.source.num = (1:size([107.2232 329.4735 122.069;161.6671 375.8329 61.7013],1))';
    mesh_tmp.source.fwhm = zeros(size([107.2232 329.4735 122.069;161.6671 375.8329 61.7013],1),1);
    mesh_tmp.source.fixed =0;
    mesh_tmp.source.distributed =0;
    mesh_tmp.meas.coord =[227.249 305.251 34.2625;207.5 321.6451 62.0035];
    mesh_tmp.meas.num = (1:size([227.249 305.251 34.2625;207.5 321.6451 62.0035],1))';
    mesh_tmp.meas.fixed =0;
    mesh_tmp = minband_opt(mesh_tmp);
    save_mesh(mesh_tmp,fullfile(tempdir,'nirfast','spec_bem-mesh'));
    clear mesh_tmp
    mesh = load_mesh(fullfile(tempdir,'nirfast','spec_bem-mesh'));
    set_chromophores(fullfile(tempdir,'nirfast','spec_bem-mesh'),{'HbO';'Water';},[661 735 761]);
    mesh = load_mesh(fullfile(tempdir,'nirfast','spec_bem-mesh'));
    mesh_data = bemdata_spectral(mesh,100);
    plot_data(mesh_data);
catch err
    result.passed{test_no} = 0;
    result.message{test_no}.identifier = err.identifier;
    result.message{test_no}.message = err.message;
    result.message{test_no}.cause = err.cause;
    result.message{test_no}.stack = err.stack;
    result.testname{test_no} = testname;
end
if ~exist('err','var')
    result.passed{test_no} = 1;
    result.message{test_no} = [];
    result.testname{test_no} = testname;
end
clear err mesh sizevar mesh_tmp mesh_data; close all
%% 3D surface to stnd; 
testname = '3D surface to stnd';
test_no = 8;
try
    checkerboard3dmm_wrapper(fullfile(nirfastroot,'meshes/meshing examples/3026_1.inp'),fullfile(tempdir,'nirfast','nirfast-stnd'),'stnd',[],1);
    mesh_tmp = load_mesh(fullfile(tempdir,'nirfast','nirfast-stnd'));
    mesh_tmp.link =[ 1 1 1; 1 2 1; 2 1 1; 2 2 1;];
    mesh_tmp.source.coord =[68.2153 116.1036 -47.1224;94.4929 74.4493 -50.3807];
    mesh_tmp.source.num = (1:size([68.2153 116.1036 -47.1224;94.4929 74.4493 -50.3807],1))';
    mesh_tmp.source.fwhm = zeros(size([68.2153 116.1036 -47.1224;94.4929 74.4493 -50.3807],1),1);
    mesh_tmp.source.fixed =0;
    mesh_tmp.source.distributed =0;
    mesh_tmp.meas.coord =[57.4719 112.5783 2.9866;98.6913 117.3636 -98.7295];
    mesh_tmp.meas.num = (1:size([57.4719 112.5783 2.9866;98.6913 117.3636 -98.7295],1))';
    mesh_tmp.meas.fixed =0;
    mesh_tmp = minband_opt(mesh_tmp);
    save_mesh(mesh_tmp,fullfile(tempdir,'nirfast','nirfast-stnd'));
    clear mesh_tmp
    mesh = load_mesh(fullfile(tempdir,'nirfast','nirfast-stnd'));
    val.mua=0.04;
    val.mus=1;
    mesh = set_mesh(mesh,0,val);
    val.mua=0.010031;
    val.mus=1.5;
    mesh = set_mesh(mesh,4,val);
    mesh_data = femdata(mesh,100);
    plotimage(mesh,log(mesh_data.phi(:,1))); pause(0.2);
    plotimage(mesh,log(mesh_data.phi(:,2))); pause(0.2);
    plot_data(mesh_data);
catch err
    result.passed{test_no} = 0;
    result.message{test_no}.identifier = err.identifier;
    result.message{test_no}.message = err.message;
    result.message{test_no}.cause = err.cause;
    result.message{test_no}.stack = err.stack;
    result.testname{test_no} = testname;
end
if ~exist('err','var')
    result.passed{test_no} = 1;
    result.message{test_no} = [];
    result.testname{test_no} = testname;
end
clear err mesh sizevar mesh_tmp mesh_data; close all
%% 3D surface spect; 
testname = '3D surface spect';
test_no = 9;
try
    checkerboard3dmm_wrapper(fullfile(nirfastroot,'meshes/meshing examples/p1915_1.inp'),fullfile(tempdir,'nirfast','nirfast-spec'),'spec',[],0);
    mesh_tmp = load_mesh(fullfile(tempdir,'nirfast','nirfast-spec'));
    mesh_tmp.link =[ 1 1 1; 1 2 1; 2 1 1; 2 2 1; 3 1 1; 3 2 1; 4 1 1; 4 2 1;];
    mesh_tmp.source.coord =[59.6273 92.0259 -66.4127;68.2835 61.7979 -66.4136;92.7088 44.3394 -63.3741;79.7173 80.1593 -115.1197];
    mesh_tmp.source.num = (1:size([59.6273 92.0259 -66.4127;68.2835 61.7979 -66.4136;92.7088 44.3394 -63.3741;79.7173 80.1593 -115.1197],1))';
    mesh_tmp.source.fwhm = zeros(size([59.6273 92.0259 -66.4127;68.2835 61.7979 -66.4136;92.7088 44.3394 -63.3741;79.7173 80.1593 -115.1197],1),1);
    mesh_tmp.source.fixed =0;
    mesh_tmp.source.distributed =0;
    mesh_tmp.meas.coord =[95.3982 117.6826 -12.1879;116.4905 80.975 -12.1294];
    mesh_tmp.meas.num = (1:size([95.3982 117.6826 -12.1879;116.4905 80.975 -12.1294],1))';
    mesh_tmp.meas.fixed =0;
    mesh_tmp = minband_opt(mesh_tmp);
    save_mesh(mesh_tmp,fullfile(tempdir,'nirfast','nirfast-spec'));
    clear mesh_tmp
    mesh = load_mesh(fullfile(tempdir,'nirfast','nirfast-spec'));
    set_chromophores(fullfile(tempdir,'nirfast','nirfast-spec'),{'HbO';'deoxyHb';'Water';},[661 761]);
    mesh = load_mesh(fullfile(tempdir,'nirfast','nirfast-spec'));
    mesh_data = femdata(mesh,100);
    plot_data(mesh_data);
catch err
    result.passed{test_no} = 0;
    result.message{test_no}.identifier = err.identifier;
    result.message{test_no}.message = err.message;
    result.message{test_no}.cause = err.cause;
    result.message{test_no}.stack = err.stack;
    result.testname{test_no} = testname;
end
if ~exist('err','var')
    result.passed{test_no} = 1;
    result.message{test_no} = [];
    result.testname{test_no} = testname;
end
clear err mesh sizevar mesh_tmp mesh_data; close all
%% 3D surface BEM spect; 
testname = '3D surface BEM spect';
test_no = 10;
try
    surf2nirfast_bem(fullfile(nirfastroot,'meshes/meshing examples/3d_surface_1.inp'),fullfile(tempdir,'nirfast','nirfast-spec_bem'),'spec_bem');
    mesh_tmp = load_mesh(fullfile(tempdir,'nirfast','nirfast-spec_bem'));
    mesh_tmp.link =[ 1 1 1; 1 2 1; 1 3 1; 2 1 1; 2 2 1; 2 3 1; 3 1 1; 3 2 1; 3 3 1;];
    mesh_tmp.source.coord =[121.9469 74.2261 -5.6573;188.637 68.1573 17.9829;130.9424 158.1075 85.0576];
    mesh_tmp.source.num = (1:size([121.9469 74.2261 -5.6573;188.637 68.1573 17.9829;130.9424 158.1075 85.0576],1))';
    mesh_tmp.source.fwhm = zeros(size([121.9469 74.2261 -5.6573;188.637 68.1573 17.9829;130.9424 158.1075 85.0576],1),1);
    mesh_tmp.source.fixed =0;
    mesh_tmp.source.distributed =0;
    mesh_tmp.meas.coord =[118.2419 75.5363 -75.4916;152.7963 107.1562 -110.5871;167.9088 172.446 -110.6267];
    mesh_tmp.meas.num = (1:size([118.2419 75.5363 -75.4916;152.7963 107.1562 -110.5871;167.9088 172.446 -110.6267],1))';
    mesh_tmp.meas.fixed =0;
    mesh_tmp = minband_opt(mesh_tmp);
    save_mesh(mesh_tmp,fullfile(tempdir,'nirfast','nirfast-spec_bem'));
    clear mesh_tmp
    mesh = load_mesh(fullfile(tempdir,'nirfast','nirfast-spec_bem'));
    set_chromophores(fullfile(tempdir,'nirfast','nirfast-spec_bem'),{'HbO';'deoxyHb';'Water';},[661 761]);
    mesh = load_mesh(fullfile(tempdir,'nirfast','nirfast-spec_bem'));
    mesh_data = bemdata_spectral(mesh,100);
    plot_data(mesh_data);
catch err
    result.passed{test_no} = 0;
    result.message{test_no}.identifier = err.identifier;
    result.message{test_no}.message = err.message;
    result.message{test_no}.cause = err.cause;
    result.message{test_no}.stack = err.stack;
    result.testname{test_no} = testname;
end
if ~exist('err','var')
    result.passed{test_no} = 1;
    result.message{test_no} = [];
    result.testname{test_no} = testname;
end
clear err mesh sizevar mesh_tmp mesh_data; close all
%% Simple Slab with Mesh Optimizer; 
testname = 'Simple Slab with Mesh Optimizer';
test_no = 11;
try
    sizevar.xc=0;
    sizevar.yc=0;
    sizevar.zc=0;
    sizevar.width=10;
    sizevar.height=10;
    sizevar.depth=10;
    sizevar.dist=3;
    create_mesh(fullfile(tempdir,'nirfast','Slab-stnd-mesh'),'Slab',sizevar,'stnd');
    clear mesh;
    foomesh = load_mesh(fullfile(tempdir,'nirfast','Slab-stnd-mesh'));
    foomesh.optimize_my_mesh = 1;
    opt_params.qualmeasure = 0;
    opt_params.facetsmooth = 0;
    opt_params.usequadrics = 0;
    opt_params.opt_params = [];

    [mesh.elements, mesh.nodes] = improve_mesh_use_stellar(foomesh.elements, foomesh.nodes, opt_params);
    clear foomesh;
    ffaces = boundfaces(mesh.nodes, mesh.elements, 0);
    mesh.bndvtx = zeros(size(mesh.nodes,1),1);
    mesh.bndvtx(unique(ffaces(:))) = 1;
    mesh = set_mesh_type(mesh, 'stnd');
    save_mesh(mesh, fullfile(tempdir,'nirfast','Slab-stnd-mesh'));
    mesh.optimize_my_mesh = 0;
    clear sizevar ffaces opt_params optimize_status
    mesh_tmp = load_mesh(fullfile(tempdir,'nirfast','Slab-stnd-mesh'));
    mesh_tmp.link =[ 1 1 1; 1 2 1; 1 3 1; 2 1 1; 2 2 1; 2 3 1; 3 1 1; 3 2 1; 3 3 1;];
    mesh_tmp.source.coord =[1.0017 -5 -1.2947;4 -2.5744 -0.79479;4 1.615 -1.5982];
    mesh_tmp.source.num = (1:size([1.0017 -5 -1.2947;4 -2.5744 -0.79479;4 1.615 -1.5982],1))';
    mesh_tmp.source.fwhm = zeros(size([1.0017 -5 -1.2947;4 -2.5744 -0.79479;4 1.615 -1.5982],1),1);
    mesh_tmp.source.fixed =0;
    mesh_tmp.source.distributed =0;
    mesh_tmp.meas.coord =[-5 1.4227 -1.2157;1.7812 4 -2.7832;-1.1962 -0.20615 4];
    mesh_tmp.meas.num = (1:size([-5 1.4227 -1.2157;1.7812 4 -2.7832;-1.1962 -0.20615 4],1))';
    mesh_tmp.meas.fixed =0;
    mesh_tmp = minband_opt(mesh_tmp);
    save_mesh(mesh_tmp,fullfile(tempdir,'nirfast','Slab-stnd-mesh'));
    clear mesh_tmp
    mesh = load_mesh(fullfile(tempdir,'nirfast','Slab-stnd-mesh'));
    mesh_data = femdata(mesh,100);
    plotimage(mesh,log(mesh_data.phi(:,1))); pause(0.2);
    plotimage(mesh,log(mesh_data.phi(:,2))); pause(0.2);
    plot_data(mesh_data);
catch err
    result.passed{test_no} = 0;
    result.message{test_no}.identifier = err.identifier;
    result.message{test_no}.message = err.message;
    result.message{test_no}.cause = err.cause;
    result.message{test_no}.stack = err.stack;
    result.testname{test_no} = testname;
end
if ~exist('err','var')
    result.passed{test_no} = 1;
    result.message{test_no} = [];
    result.testname{test_no} = testname;
end
clear err mesh sizevar mesh_tmp mesh_data; close all
%% Simple Cylinder Spectral with anomoly; 
testname = 'Simple Cylinder Spectral with anomoly';
test_no = 12;
try
    sizevar.xc=0;
    sizevar.yc=0;
    sizevar.zc=0;
    sizevar.r=10;
    sizevar.height=25;
    sizevar.dist=2.4;
    create_mesh(fullfile(tempdir,'Cylinder-spec-mesh'),'Cylinder',sizevar,'spec');
    clear mesh;
    foomesh = load_mesh(fullfile(tempdir,'Cylinder-spec-mesh'));
    foomesh.optimize_my_mesh = 1;
    opt_params.qualmeasure = 0;
    opt_params.facetsmooth = 0;
    opt_params.usequadrics = 0;
    opt_params.opt_params = [];

    [mesh.elements, mesh.nodes] = improve_mesh_use_stellar(foomesh.elements, foomesh.nodes, opt_params);
    clear foomesh;
    ffaces = boundfaces(mesh.nodes, mesh.elements, 0);
    mesh.bndvtx = zeros(size(mesh.nodes,1),1);
    mesh.bndvtx(unique(ffaces(:))) = 1;
    mesh = set_mesh_type(mesh, 'spec');
    save_mesh(mesh,fullfile(tempdir,'Cylinder-spec-mesh'));
    mesh.optimize_my_mesh = 0;
    clear sizevar ffaces opt_params optimize_status
    mesh_tmp = load_mesh(fullfile(tempdir,'Cylinder-spec-mesh'));
    mesh_tmp.link =[ 1 1 1; 1 2 1; 1 3 1; 1 4 1; 2 1 1; 2 2 1; 2 3 1; 2 4 1; 3 1 1; 3 2 1; 3 3 1; 3 4 1; 4 1 1; 4 2 1; 4 3 1; 4 4 1;];
    mesh_tmp.source.coord =[-1.5405 -1.4855 11.5;-0.65198 -6.9872 11.5;1.1935 -9.9273 5.1039;-0.24781 -9.9271 -1.6531];
    mesh_tmp.source.num = (1:size([-1.5405 -1.4855 11.5;-0.65198 -6.9872 11.5;1.1935 -9.9273 5.1039;-0.24781 -9.9271 -1.6531],1))';
    mesh_tmp.source.fwhm = zeros(size([-1.5405 -1.4855 11.5;-0.65198 -6.9872 11.5;1.1935 -9.9273 5.1039;-0.24781 -9.9271 -1.6531],1),1);
    mesh_tmp.source.fixed =0;
    mesh_tmp.source.distributed =0;
    mesh_tmp.meas.coord =[5.8808 -8.0524 -3.4291;9.9691 -0.25421 -3.6332;7.5712 6.5065 -2.2674;9.0267 -3.8854 -10.7778];
    mesh_tmp.meas.num = (1:size([5.8808 -8.0524 -3.4291;9.9691 -0.25421 -3.6332;7.5712 6.5065 -2.2674;9.0267 -3.8854 -10.7778],1))';
    mesh_tmp.meas.fixed =0;
    mesh_tmp = minband_opt(mesh_tmp);
    save_mesh(mesh_tmp,fullfile(tempdir,'Cylinder-spec-mesh'));
    clear mesh_tmp
    mesh = load_mesh(fullfile(tempdir,'Cylinder-spec-mesh'));
    set_chromophores(fullfile(tempdir,'Cylinder-spec-mesh'),{'HbO';'deoxyHb';'Water';},[661 761]);
    mesh = load_mesh(fullfile(tempdir,'Cylinder-spec-mesh'));
    blob.x=0;
    blob.y=0;
    blob.r=5;
    blob.z=0;
    blob.region=1;
    blob.sa=1;
    blob.sp=1;
    blob.HbO=0.03;
    blob.deoxyHb=0.03;
    blob.Water=0.5;
    mesh_anom = add_blob(mesh,blob);
    save_mesh(mesh_anom,fullfile(tempdir,'nirfast','Cyl-multi'));
    val.sa=1.1;
    val.sp=1;
    val.HbO=0.010196;
    val.deoxyHb=0.010196;
    val.Water=0.40098;
    mesh_anom = set_mesh(mesh_anom,1,val);
    save_mesh(mesh_anom,fullfile(tempdir,'nirfast','Cyl-multi'));
    mesh_anom_data = femdata(mesh_anom,100,[661 761]);
    save_data(mesh_anom_data,fullfile(tempdir,'nirfast','Cyl-multi-data'));
    plot_data(mesh_anom_data);
catch err
    result.passed{test_no} = 0;
    result.message{test_no}.identifier = err.identifier;
    result.message{test_no}.message = err.message;
    result.message{test_no}.cause = err.cause;
    result.message{test_no}.stack = err.stack;
    result.testname{test_no} = testname;
end
if ~exist('err','var')
    result.passed{test_no} = 1;
    result.message{test_no} = [];
    result.testname{test_no} = testname;
end
clear err mesh sizevar mesh_tmp mesh_data; close all
