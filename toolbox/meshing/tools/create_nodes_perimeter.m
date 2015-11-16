function [tot_newbdye,tot_newbdyp]=create_nodes_perimeter(bdye,bdyp,dl)
% gets a 2d bdy and creates new nodes along that bdy which are located 'dl'
% apart each other along that bdy

idx=1;
tot_newbdyp=[];
tot_newbdye=[];
allnodes=unique([bdye(:,1);bdye(:,2)]);
twod = false;
if size(bdyp,2) == 2
    bdyp(:,3) = zeros(size(bdyp,1),1);
    twod = true;
end
while true
%     tail=bdye(idx,1);
%     startN=tail;
%     counter=0;
    clear c;
    [c extra_edges]=TailToHead(bdye,bdyp,allnodes,0,0,1,0);
%     while true
%         head=bdye(idx,2);
%         counter=counter+1;
%         c(counter,:)=bdye(idx,:);
%         idx=idx+1;
%         if head==startN
%             break;
%         end
%     end
    nodes=unique([c(:,1);c(:,2)]);
    cp=bdyp(nodes,1:2);
    [tf fooidx]=ismember(c(:,1:2),nodes);
    c(:,1:2) = fooidx;
    [newbdye,newbdyp]=create_nodes_perimeter_single_loop(c,cp,dl);
    if size(newbdye,1)<3
        bdye = extra_edges;
        if ~isempty(extra_edges)
            continue;
        else
            break
        end
    end
    newbdye(:,1:2)=newbdye(:,1:2)+size(tot_newbdyp,1);
    tot_newbdyp=[tot_newbdyp;newbdyp];
    tot_newbdye=[tot_newbdye;newbdye];

    bdye = extra_edges;
    
    if idx>=size(bdye,1) || isempty(bdye)
        break;
    end
end
tot_newbdye = uint32(tot_newbdye);
if twod
    tot_newbdyp = tot_newbdyp(:,1:2);
end


function [newbdye,newbdyp]=create_nodes_perimeter_single_loop(bdye,bdyp,dl)

mat1 = 0;
mat2 = 0;
if size(bdye,2)>=4
    mat1=bdye(1,3);
    mat2=bdye(1,4);
end
d=enorm0_2d(bdyp(bdye(:,1),1), bdyp(bdye(:,1),2), bdyp(bdye(:,2),1), bdyp(bdye(:,2),2));

perimeter=sum(d);
nsegments=floor(perimeter/dl);
if nsegments < 3
    fprintf('  Loop too short to create a triagnel! Returning the first and last nodes!\n');
    newbdye = [1 2];
    newbdyp = [bdyp(1,1:2); bdyp(end,1:2)];
    return
end

dl=dl+mod(perimeter,dl)/nsegments;

conn_ele=get_conn_ele_2d(bdye);
e1=conn_ele(1,1);
e2=conn_ele(1,2);
if (bdye(e1,1)==1)
    currentelement=e1;
elseif (bdye(e2,1)==1)
    currentelement=e2;
end
% elmsizes=enorm0_2d(bdyp(bdye(:,1),1), bdyp(bdye(:,1),2), bdyp(bdye(:,2),1), bdyp(bdye(:,2),2));
elmsizes=d;

tail=1;
newbdyp(1,:)=[bdyp(tail,1) bdyp(tail,2)];
newbdye(1,1)=tail;
x1=bdyp(tail,1); y1=bdyp(tail,2);
newpntcounter=2;newelmcounter=1;
residue=0;
startelement=currentelement;
flag=true;
while (flag==true)
    curesiz=elmsizes(currentelement);
    while (curesiz+residue>dl)
        [x0,y0,f,g]=line_exp2par_2d ( x1,y1,bdyp(bdye(currentelement,2),1), bdyp(bdye(currentelement,2),2));
        sqred=sqrt(f^2+g^2);
        xn=x0+f*(dl-residue)/sqred;
        yn=y0+g*(dl-residue)/sqred;
        newbdyp(newpntcounter,:)=[xn yn];
        newbdye(newelmcounter,2)=newpntcounter;
        tail=newpntcounter;
        x1=newbdyp(tail,1);y1=newbdyp(tail,2);
        newpntcounter=newpntcounter+1;
        newelmcounter=newelmcounter+1;
        newbdye(newelmcounter,1)=tail;
        curesiz=curesiz-(dl-residue);
        if (residue~=0)
            residue=0;
        end
    end
    residue=residue+curesiz;
    e1=conn_ele(bdye(currentelement,2),1);
    e2=conn_ele(bdye(currentelement,2),2);
    x1=bdyp(bdye(currentelement,2),1);
    y1=bdyp(bdye(currentelement,2),2);
    if (e1==currentelement)
        currentelement=e2;
    elseif(e2==currentelement)
        currentelement=e1;
    end
    if (currentelement==startelement)
        flag=false;
    end
end
if (size(newbdyp,1)<3)
    return
end
newbdye(newelmcounter,2)=1;
d=enorm0_2d(newbdyp(1,1),newbdyp(1,2),newbdyp(newpntcounter-1,1),newbdyp(newpntcounter-1,2));
% if (mod(perimeter,dl)>0.5*dl || residue<0.5*dl)

if (d<0.4*dl && size(newbdyp,1)>=4)
    newbdyp(newpntcounter-1,:)=[];
    newbdye(newelmcounter,:)=[];
    newbdye(newelmcounter-1,:)=[newpntcounter-2  1];
end

if size(bdye,2)>=4
newbdye(:,3) = ones(size(newbdye,1),1)*mat1;
newbdye(:,4) = ones(size(newbdye,1),1)*mat2;
end

    
        
        
    