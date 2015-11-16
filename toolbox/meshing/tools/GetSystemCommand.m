function systemcommand = GetSystemCommand(command_name)
% systemcommand = GetSystemCommand(command_name)
% Determines the platform that matlab is running and calls the appropriate
% executable file using following convention:
% command_name-mac.exe  For Mac
% command_name-linux.exe  For Linux
% command_name.exe For Windows
% 
% If command_name is not found an empty string will be returned.
% 
% Note that systemcommand my contain spaces so the calling functin should
% enclose it using double quotes.

os=computer;
systemcommand=[];
command_name=add_extension(command_name,'.exe');
[command_name ext]=remove_extension(command_name);

if ~isempty(strfind(os,'PCWIN')) % Windows
    if strcmpi(os,'PCWIN64')
        suff='64';
    else
        suff='';
    end
    systemcommand = which([command_name suff '.exe']);
elseif ~isempty(strfind(os,'MAC')) % Mac OS
    if strcmpi(os,'MACI64')
        suff='64';
    else
        suff='';
    end
    systemcommand = which([command_name '-mac' suff '.exe']);
    if isempty(systemcommand) % Try to find a Universal binary
        systemcommand = which([command_name '-mac.exe']);
    end
elseif ~isempty(strfind(os,'GLNX')) % Linux
    if strcmpi(os,'GLNXA64')
        suff='64';
    else
        suff='';
    end
    systemcommand = which([command_name '-linux' suff '.exe']);
else
    fprintf('\n\tCan not establish your platform!\n');
    error('\t%s will not be executed\n\n', command_name);
end
if isempty(systemcommand)
    error('Could not find ''%s'' !', command_name);
end


