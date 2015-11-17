function MyAssert(st,Msg)

if st
    return
else
    disp(sprintf('\n\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'))
    disp(sprintf('\n\n\tAn Assertion Has Failed!'))
    disp(sprintf('  You have the chance to debug your code or\n'))
    if nargin>1
        disp(sprintf('\n%s\n',Msg))
    end
    disp(sprintf('type the command ''return'' and press the Return key to continue!\n\n'));
    keyboard
    disp(' ')
end