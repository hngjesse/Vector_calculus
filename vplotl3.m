function h = vplotl3(X, Y, Z, U, V, W, varargin)

% ================= Input parsing =================
p = inputParser;
p.addParameter('Scale', 1, @(x) isnumeric(x) && isscalar(x));
p.addParameter('LineWidth', 1.2, @(x) isnumeric(x));
p.addParameter('Color', 'k');   % single color
p.addParameter('ArrowHeadFrac', 0.25, @(x) isnumeric(x) && isscalar(x));
p.addParameter('ArrowHeadAngle', 20, @(x) isnumeric(x) && isscalar(x)); % degrees
p.addParameter('Parent', gca);
p.parse(varargin{:});

userScale = p.Results.Scale;
lw   = p.Results.LineWidth;
col  = p.Results.Color;
ahf  = p.Results.ArrowHeadFrac;
aha  = deg2rad(p.Results.ArrowHeadAngle);
ax   = p.Results.Parent;

hold(ax, 'on')
view(ax, 3)
grid(ax, 'on')

% ================= Autoscale base =================
dx = min(diff(unique(X(:))));
dy = min(diff(unique(Y(:))));
dz = min(diff(unique(Z(:))));
baseScale = min([dx dy dz]);

% ================= Magnitude =================
mag = hypot(hypot(U, V), W);
mag_max = max(mag(:));

zeroMask = mag == 0;

% ================= SCALE BY MAGNITUDE =================
% Max arrow length = baseScale * userScale
scale = userScale * baseScale / max(mag_max, eps);

U = U * scale;
V = V * scale;
W = W * scale;

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

    % Base & tip
    x0 = X(i); y0 = Y(i); z0 = Z(i);
    x1 = x0 + U(i); y1 = y0 + V(i); z1 = z0 + W(i);

    % Shaft
    hl(i) = plot3(ax, [x0 x1], [y0 y1], [z0 z1], ...
        'Color', col, 'LineWidth', lw);

    % Arrowhead
    L = hypot(hypot(U(i), V(i)), W(i));
    h_cone = ahf * L;
    r_cone = h_cone * tan(aha);

    CX = r_cone * coneX;
    CY = r_cone * coneY;
    CZ = h_cone * coneZ;

    % Rotation (Rodrigues)
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

    % Rotate & translate
    pts = R * [CX(:)'; CY(:)'; CZ(:)'];
    CXr = reshape(pts(1,:) + x1, size(CX));
    CYr = reshape(pts(2,:) + y1, size(CY));
    CZr = reshape(pts(3,:) + z1, size(CZ));

    % Draw arrowhead
    hs(i) = surf(ax, CXr, CYr, CZr, ...
        'FaceColor', col, 'EdgeColor', 'none');
end

% ================= Axes =================
axis(ax, 'equal')
axis(ax, 'tight')

xlabel(ax,'$x$','Interpreter','latex')
ylabel(ax,'$y$','Interpreter','latex')
zlabel(ax,'$z$','Interpreter','latex')

% ================= Output =================
h.lines = hl;
h.heads = hs;
h.axes  = ax;

end