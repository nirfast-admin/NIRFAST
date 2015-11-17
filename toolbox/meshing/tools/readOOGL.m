function [t p]=readOOGL(fn)
% Reads the triangulated surface from a .oogl file
% 
% Written by:
%   Hamid Ghadyani Sep 2010
fn=add_extension(fn,'.oogl');
fid = OpenFile(fn,'rt');

s = fgetl(fid);
n = sscanf(s,'%*s%d %d %d');
np=n(1); nt=n(2);

p = textscan(fid,'%f %f %f',np);
t = textscan(fid,'3 %d %d %d',nt);

p = cell2mat(p);
t = cell2mat(t);
t = t + 1;

fclose(fid);
