function [path fnprefix num_flag ext startn endn] = GetFilenameNumbering(filename)
% Return the file path, its name without ending numberings and its
% extension:
% [path fn num_flag ext]
% num_flag is the smallest number that the fnprefix is prefixed to.

[path fname ext]=fileparts(filename);
idx = regexpi([fname ext],['[0-9]+' ext '\>']);

% File name starts with a number try to see if there are files like
% 3245_1.bmp, 3245_2.bmp, ...
if idx==1
    idx = regexpi([fname ext],['_[0-9]+' ext '\>']);
end

fnprefix = fname;
if ~isempty(idx) && idx
    fnprefix = fname(1:(idx(end)-1));
    foo = dir([fullfile(path,fnprefix) '*' ext]);
    foo = foo(1).name;
    idx = regexpi(foo,['[0-9]+' ext '\>']);
    num_flag = str2num(foo(idx:end-4));
else
    num_flag=-1;
end

startn=[]; endn = [];
if num_flag == -1, return, end
startn = num_flag;
idx = num_flag;
while true
    fn = [fullfile(path,fnprefix) num2str(idx) ext];
    foo = dir(fn);
    if isempty(foo)
        endn = idx - 1;
        break;
    end
    idx = idx + 1;
end
