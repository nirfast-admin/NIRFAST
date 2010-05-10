function [elem, points] = read_abaqus_inp_3D(mesh_fn)
% Reads abaqus mesh files exported by Mimics V.13
% 
% Written by Hamid Ghadyani, Apr 2010
% The old version which is very slow is now called read_abaqus_inp_line
% 

if(nargin~=1)
    [fname,pname]=uigetfile('*.inp','Please pick the inp file');
else
    pname = [];
	fname=mesh_fn;
end
[fid st]=OpenFile([pname fname],'r');
if st~=0, error(' '); end

% read header junk
for i=1:4, fgetl(fid); end
% read node coordinates
data=textscan(fid,' %u64, %.12f, %.12f, %.12f%*[^\n]');
points = [data{2} data{3} data{4}];

% read head junk
fgetl(fid);

% read element list
data=textscan(fid,' %u64, %u64, %u64, %u64, %u64%*[^\n]');
elem  = double([data{2} data{3} data{4} data{5}]);

fclose(fid);
