function flag = canwrite(loc)

% flag = canwrite(loc)
%
% determines if there is write access to the directory
%
% loc is a location on the computer. If no loc is given,
%   the current Matlab directory will be checked
% flag is the result (1 if there is write access, 0 otherwise)

if nargin == 0 || isempty(loc)
    loc = pwd;
end

k1 = findstr(loc,'/');
k2 = findstr(loc,'\');

if isempty(k1) && isempty(k2)
    loc = pwd;
end

loc = fileparts(loc);

testDir = 'temp_nirfast_dircheck';

if exist(loc, 'dir') == 7
    flag = mkdir(loc, testDir);
    if flag == 1
        junk = rmdir(fullfile(loc, testDir));
    end
else
    % loc doesn't exist
    flag = 0;
end