function h = vplot3(X, Y, Z, U, V, W, varargin)

% ================= Input parsing =================
p = inputParser;
p.addParameter('Scale', 1, @(x) isnumeric(x) && isscalar(x));
p.addParameter('LineWidth', 1.2, @(x) isnumeric(x));
p.addParameter('Colormap', turbo(256));
p.addParameter('ArrowHeadFrac', 0.25, @(x) isnumeric(x));
p.addParameter('ArrowHeadAngle', 20, @(x) isnumeric(x)); % degrees
p.addParameter('Colorbar', true, @(x) islogical(x) || isnumeric(x));
p.addParameter('Mode','color', @(x) ischar(x) || isstring(x)); % <-- ONLY THIS
p.addParameter('Parent', gca);
p.parse(varargin{:});

userScale = p.Results.Scale;
lw   = p.Results.LineWidth;
cmap = p.Results.Colormap;
ahf  = p.Results.ArrowHeadFrac;
aha  = deg2rad(p.Results.ArrowHeadAngle);
showCB = logical(p.Results.Colorbar);
mode = lower(p.Results.Mode);
ax   = p.Results.Parent;

hold(ax, 'on')
view(ax, 3)
grid(ax, 'on')

% ================= Autoscale =================
dx = min(diff(unique(X(:))));
dy = min(diff(unique(Y(:))));
dz = min(diff(unique(Z(:))));
baseScale = min([dx dy dz]);

scale = userScale * baseScale;

% ================= Magnitude =================
mag = hypot(hypot(U, V), W);
mag_max = max(mag(:));
mag_min = min(mag(:));

zeroMask = mag == 0;

% ================= Mode handling =================
if strcmp(mode,'color')
    % normalize direction only
    mag_safe = mag;
    mag_safe(zeroMask) = 1;

    U = U ./ mag_safe * scale;
    V = V ./ mag_safe * scale;
    W = W ./ mag_safe * scale;

elseif strcmp(mode,'length')
    % length represents magnitude
    U = U * (scale / max(mag_max, eps));
    V = V * (scale / max(mag_max, eps));
    W = W * (scale / max(mag_max, eps));

else
    error('Mode must be "color" or "length"');
end

% ================= Color mapping =================
colormap(ax, cmap)
clim(ax, [mag_min mag_max])

idx = round((mag - mag_min) / (mag_max - mag_min + eps) * (size(cmap,1)-1)) + 1;
idx = max(1, min(idx, size(cmap,1)));

% ================= Cone template =================
nTheta = 32;
[coneX, coneY, coneZ] = cylinder([1 0], nTheta);

z_axis = [0;0;1];

% ================= Plot =================
n = numel(X);
hl = gobjects(n,1);
hs = gobjects(n,1);

for i = 1:n

    if zeroMask(i)
        continue
    end

    x0 = X(i); y0 = Y(i); z0 = Z(i);
    x1 = x0 + U(i); y1 = y0 + V(i); z1 = z0 + W(i);

    % Color logic
    if strcmp(mode,'length')
        c = [0 0 1]; % fixed color
    else
        c = cmap(idx(i),:);
    end

    % Shaft
    hl(i) = plot3(ax, [x0 x1], [y0 y1], [z0 z1], ...
        'Color', c, 'LineWidth', lw);

    % Arrowhead
    L = hypot(hypot(U(i), V(i)), W(i));
    h_cone = ahf * L;
    r_cone = h_cone * tan(aha);

    CX = r_cone * coneX;
    CY = r_cone * coneY;
    CZ = h_cone * coneZ;

    % Rotation
    v = [U(i); V(i); W(i)] / L;

    if norm(cross(z_axis, v)) < 1e-8
        R = eye(3);
    else
        k = cross(z_axis, v);
        s = norm(k);
        c0 = dot(z_axis, v);
        K = [0 -k(3) k(2); k(3) 0 -k(1); -k(2) k(1) 0];
        R = eye(3) + K + K^2 * ((1 - c0)/(s^2));
    end

    pts = R * [CX(:)'; CY(:)'; CZ(:)'];
    CXr = reshape(pts(1,:) + x1, size(CX));
    CYr = reshape(pts(2,:) + y1, size(CY));
    CZr = reshape(pts(3,:) + z1, size(CZ));

    hs(i) = surf(ax, CXr, CYr, CZr, ...
        'FaceColor', c, 'EdgeColor', 'none');
end

% ================= Axes =================
axis(ax, 'equal')
axis(ax, 'tight')

if showCB && strcmp(mode,'color')
    h.colorbar = colorbar(ax);
else
    h.colorbar = [];
end

xlabel(ax,'$x$','Interpreter','latex')
ylabel(ax,'$y$','Interpreter','latex')
zlabel(ax,'$z$','Interpreter','latex')

% ================= Output =================
h.lines = hl;
h.heads = hs;
h.axes  = ax;

end