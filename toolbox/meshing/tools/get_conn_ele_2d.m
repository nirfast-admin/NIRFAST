function conn_ele=get_conn_ele_2d(t)
% returns a list of elements which share each node:
% [e1 e4]
% [e3 e5]
% [e4 e5]
ne=size(t,1);
%assuming that 2d bdy is a closed one therefore number of points is the
%same as number of elements
conn_ele=zeros(ne,2); 
for i=1:ne
    n1=t(i,1); n2=t(i,2);
    if (conn_ele(n1,1)==0)
        conn_ele(n1,1)=i;
    elseif (conn_ele(n1,2)==0)
        conn_ele(n1,2)=i;
    else
        display('Node connectivity list is not right. Exiting.');
        break;
    end
    if (conn_ele(n2,1)==0)
        conn_ele(n2,1)=i;
    elseif (conn_ele(n2,2)==0)
        conn_ele(n2,2)=i;
    else
        display('Node connectivity list is not right. Exiting.');
        break;
    end
end