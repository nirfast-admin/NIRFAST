function ret = getfullpath(fn)
% adds current working directory to fn if it already does not have an
% absolute path

[junk1 fn1 ext] = fileparts(fn);

if isempty(junk1)
    ret = fullfile(pwd,[fn1 ext]);
else
    ret = fn;
end
