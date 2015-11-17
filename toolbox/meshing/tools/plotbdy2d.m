function plotbdy2d(t,p,color,linewidth)
% plotbdy2d(t,p,color,linewidth)

if nargin==2
	color = 'red';
	linewidth=2;
elseif nargin==3
	linewidth=2;
elseif nargin~=4
	error('plotbdy2d: need at least two input arguments');
end

np=size(p,1);
ne=size(t,1);
hold on;
axis equal;
for i=1:ne
    n1=t(i,1);n2=t(i,2);
    x=[p(n1,1) p(n2,1)];
    y=[p(n1,2) p(n2,2)];
    line(x,y,'Color',color,'LineWidth',linewidth);
    plot(x,y,'o');
end
hold off;
