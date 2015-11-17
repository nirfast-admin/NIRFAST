function IsEqual=IsEqual(a, b, tiny)
dim = size(a);
if dim(1)~=1 && dim(2) ~= 1
    disp('IsEqual expects vectors as its arguments');
end
% IsEqual = zeros(size(a));
flags = abs(a-b) < tiny;
IsEqual = flags;
% 
%     IsEqual=0;
% 	if (abs(a-b) < tiny)
%         IsEqual=1;
%     elseif(abs(a-b) >= tiny)
%         IsEqual=0;
%     end

