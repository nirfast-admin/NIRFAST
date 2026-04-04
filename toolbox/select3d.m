function [pout, vout, viout, facevout, faceiout] = select3d(obj)
%SELECT3D 3-D point selection compatible with modern MATLAB
%   P = SELECT3D() returns the 3-D point on the current axes
%   intersected by the mouse click.  The implementation mirrors the
%   behaviour of the legacy SELECT3D utility shipped with older MATLAB
%   releases but avoids using internal graphics properties that are no
%   longer available in recent versions.
%
%   [P, V, VI, FACEV, FACEI] additionally return the closest vertex and
%   face information for patch and surface objects.  Line objects return
%   the nearest vertex.
%
%   This function is self contained so that NIRFAST does not rely on
%   MATLAB''s own SELECT3D which has changed across releases.

if nargin < 1
    obj = gco;
end

if isempty(obj) || ~ishandle(obj) || numel(obj) ~= 1
    error('Input argument must be a valid graphics handle');
end

switch get(obj,'Type')
    case 'figure'
        fig = obj;
        ax = get(fig,'CurrentAxes');
        currobj = get(fig,'CurrentObject');
        if isempty(ax) || ~strcmp(get(currobj,'Parent'),'axes')
            pout=[]; vout=[]; viout=[]; facevout=[]; faceiout=[]; return;
        end
    case 'axes'
        ax = obj;
        fig = ancestor(ax,'figure');
        currobj = get(fig,'CurrentObject');
        if ~isequal(ax,ancestor(currobj,'axes'))
            pout=[]; vout=[]; viout=[]; facevout=[]; faceiout=[]; return;
        end
    otherwise
        ax = ancestor(obj,'axes');
        fig = ancestor(ax,'figure');
        currobj = obj;
        if isempty(ax)
            pout=[]; vout=[]; viout=[]; facevout=[]; faceiout=[]; return;
        end
end

obj_type = get(currobj,'Type');

switch obj_type
    case 'surface'
        % Use triangulation to simplify intersection tests
        fv = surf2patch(currobj,'triangles');
        vertices = fv.vertices;
        faces = fv.faces;
    case 'patch'
        vertices = get(currobj,'Vertices');
        faces = get(currobj,'Faces');
        if size(faces,2) > 3 || any(isnan(faces(:)))
            faces = local_triangulate(faces);
        end
    case 'line'
        xdata = get(currobj,'XData');
        ydata = get(currobj,'YData');
        zdata = get(currobj,'ZData');
        vertices = [xdata(:), ydata(:), zdata(:)];
        faces = [];
    otherwise
        pout=[]; vout=[]; viout=[]; facevout=[]; faceiout=[]; return;
end

% add zero z for 2-D data
if size(vertices,2)==2
    vertices(:,3) = 0;
    if strcmp(obj_type,'line')
        zdata = zeros(size(xdata));
    end
end

cp = get(ax,'CurrentPoint');
ray_origin = cp(1,:);
ray_dir = cp(2,:) - cp(1,:);

if strcmp(obj_type,'line')
    % closest vertex in 2-D projection
    verts2d = vertices(:,1:2);
    pt2d = ray_origin(1:2);
    d2 = sum((verts2d - pt2d).^2,2);
    [~, idx] = min(d2);
    pout = [];
    vout = vertices(idx,:).';
    viout = idx;
    facevout = [];
    faceiout = [];
    return;
end

hit = false;
best_t = Inf;
best_face = 0;
best_uv = [0 0];

for i=1:size(faces,1)
    tri = vertices(faces(i,:),:);
    [intersects, tval, uval, vval] = local_rayTri(ray_origin, ray_dir, tri);
    if intersects && tval < best_t
        hit = true;
        best_t = tval;
        best_face = i;
        best_uv = [uval vval];
    end
end

if ~hit
    pout=[]; vout=[]; viout=[]; facevout=[]; faceiout=[]; return;
end

pout = (ray_origin + best_t * ray_dir).';

if nargout > 1
    facevout = vertices(faces(best_face,:),:).';
    faceiout = best_face;
    verts = vertices(faces(best_face,:),:);
    % choose vertex closest to intersection
    [~,v_idx] = min(sum(bsxfun(@minus,verts,pout.').^2,2));
    vout = verts(v_idx,:).';
    viout = faces(best_face,v_idx);
end

end

function [hit, t, u, v] = local_rayTri(orig, dir, tri)
%MOLLERTRUMBORE Ray/triangle intersection
epsilon = 1e-12;
edge1 = tri(2,:) - tri(1,:);
edge2 = tri(3,:) - tri(1,:);
h = cross(dir, edge2);
a = dot(edge1, h);
if abs(a) < epsilon
    hit = false; t = Inf; u=0; v=0; return;
end
f = 1.0 / a;
s = orig - tri(1,:);
u = f * dot(s, h);
if u < 0.0 || u > 1.0
    hit = false; t = Inf; v = 0; return;
end
q = cross(s, edge1);
v = f * dot(dir, q);
if v < 0.0 || (u + v) > 1.0
    hit = false; t = Inf; return;
end
t = f * dot(edge2, q);
if t > epsilon
    hit = true;
else
    hit = false; t = Inf;
end
end

function faces_tri = local_triangulate(faces)
%LOCAL_TRIANGULATE Convert polygon faces to triangles
faces_tri = [];
for i = 1:size(faces,1)
    idx = faces(i,:);
    idx = idx(~isnan(idx));
    if numel(idx) < 3
        continue;
    end
    for k = 2:(numel(idx)-1)
        faces_tri(end+1,:) = [idx(1) idx(k) idx(k+1)]; %#ok<AGROW>
    end
end
end
