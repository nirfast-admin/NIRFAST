function p=RandomizeBoundaryPoints(p,llc,delta)
xmin=llc(1); ymin=llc(2); zmin=llc(3);
dx=delta(1); dy=delta(2); dz=delta(3);
global tiny
if isempty(tiny), tiny=1e-9; end
np=size(p,1);

while(true)
    xcheck = mod(p(:,1)-xmin,dx);
    % x dimension check
    xflag = IsEqual(xcheck,0,tiny) | IsEqual(dx-xcheck,0,tiny);
    f1= sum(xflag)~=0;
%         disp(['Xflag ' num2str(sum(xflag))]);
    if size(xflag,2)~=1 && size(xflag,1)==1, xflag=xflag'; end
    xflag = cat(2,xflag,xflag,xflag);
    p = p + xflag.*(5*tiny+(10*tiny-5*tiny)*rand(np,3));
    % y dimension check
    ycheck = mod(p(:,2)-ymin,dy);

    yflag = IsEqual(ycheck,0,tiny) | IsEqual(dy-ycheck,0,tiny);
    f2= sum(yflag)~=0;
%         disp(['yflag ' num2str(sum(yflag))]);
    if size(yflag,2)~=1 && size(yflag,1)==1, yflag=yflag'; end
    yflag = cat(2,yflag,yflag,yflag);
    p = p + yflag.*(5*tiny+(10*tiny-5*tiny)*rand(np,3));
    % z dimension check
    zcheck = mod(p(:,3)-zmin,dz);
    zflag = IsEqual(zcheck,0,tiny) | IsEqual(dz-zcheck,0,tiny);
    f3= sum(zflag)~=0;
%         disp(['zflag ' num2str(sum(zflag))]);
    if size(zflag,2)~=1 && size(zflag,1)==1, zflag=zflag'; end
    zflag = cat(2,zflag,zflag,zflag);
    p = p + zflag.*(5*tiny+(10*tiny-5*tiny)*rand(np,3));
    if f1 || f2 || f3
        continue;
    else
        break;
    end
end
