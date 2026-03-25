function h = vplot_grad(X, Y, f, varargin)
% VPLOT_GRAD: 2D scalar contour + gradient vector field with shared colorbar
%
% INPUTS:
%   X, Y : meshgrid coordinates
%   f    : scalar field defined on (X,Y)
%
% NAME-VALUE PAIRS:
%   'Scale'          : gradient arrow scaling factor (default 1)
%   'LineWidth'      : arrow shaft line width (default 1.2)
%   'Colormap'       : colormap for scalar + |grad f| (default parula)
%   'Levels'         : number of contour levels (default 20)
%   'ArrowHeadFrac'  : arrowhead length fraction (default 0.4)
%   'ArrowHeadAngle' : arrowhead opening angle (rad, default pi/6)
%   'ArrowHeadLineWidth' : arrowhead edge width (default 0.8)
%   'EdgeAlpha'      : transparency of arrows (0–1, default 1)
%   'ShowShaft'      : true/false, draw arrow shafts (default true)
%   'Parent'         : axes handle (default gca)
%   'ColorbarLabel'  : colorbar label string

% -------- Input parsing --------
p = inputParser;
p.addParameter('Scale', 1, @(x) isnumeric(x) && isscalar(x));
p.addParameter('LineWidth', 1.2, @(x) isnumeric(x));
p.addParameter('Colormap', parula(256));
p.addParameter('Levels', 20, @(x) isnumeric(x) && isscalar(x));
p.addParameter('ArrowHeadFrac', 0.4, @(x) isnumeric(x) && isscalar(x));
p.addParameter('ArrowHeadAngle', pi/6, @(x) isnumeric(x) && isscalar(x));
p.addParameter('ArrowHeadLineWidth', 0.8, @(x) isnumeric(x));
p.addParameter('EdgeAlpha', 1, @(x) isnumeric(x) && isscalar(x) && x>=0 && x<=1);
p.addParameter('Parent', gca);
p.addParameter('ColorbarLabel', 'Shared scale (f + |\nabla f|)', @ischar);
p.addParameter('RotatedGrad', false, @(x) islogical(x) || isnumeric(x));
p.parse(varargin{:});

scale     = p.Results.Scale;
lw        = p.Results.LineWidth;
cmap      = p.Results.Colormap;
nLvl      = p.Results.Levels;
ahf       = p.Results.ArrowHeadFrac;
aha       = p.Results.ArrowHeadAngle;
ahlw      = p.Results.ArrowHeadLineWidth;
edgeAlpha = p.Results.EdgeAlpha;
useRot = logical(p.Results.RotatedGrad);

ax        = p.Results.Parent;
cbLabel   = p.Results.ColorbarLabel;

hold(ax,'on')

% -------- Compute gradient --------
[dfdx, dfdy] = gradient(f, ...
    mean(diff(unique(X(:)))), ...
    mean(diff(unique(Y(:)))));

if useRot
    % Rotated gradient: ∇^⊥ f = (-∂f/∂y, ∂f/∂x)
    Gx = -dfdy;
    Gy =  dfdx;
else
    % Standard gradient
    Gx = dfdx;
    Gy = dfdy;
end

mag = hypot(Gx, Gy);

% -------- Shared color limits --------
cmin = min([f(:); mag(:)]);
cmax = max([f(:); mag(:)]);

% -------- Scalar field as filled contour --------
hc = contourf(ax, X, Y, f, nLvl, 'LineColor','none');

% -------- Autoscale arrows --------
dx = min(diff(unique(X(:))));
dy = min(diff(unique(Y(:))));
baseScale = min(dx, dy);

zeroMask = mag == 0;
mag_safe = mag;
mag_safe(zeroMask) = 1;

U = (Gx ./ mag_safe) * baseScale * scale;
V = (Gy ./ mag_safe) * baseScale * scale;

% -------- Colormap & limits --------
colormap(ax, cmap)
clim(ax, [cmin cmax])

idx = round((mag - min(mag(:))) / (max(mag(:)) - min(mag(:))) ...
      * (size(cmap,1)-1)) + 1;
idx = max(1, min(idx, size(cmap,1)));

% -------- Plot gradient vectors --------
n = numel(X);
hl = gobjects(n,1);
hp = gobjects(n,1);

for i = 1:n
    if zeroMask(i), continue, end

    x0 = X(i); y0 = Y(i);
    x1 = x0 + U(i);
    y1 = y0 + V(i);

    % -------- Shaft --------
    hl(i) = patch(ax, [x0 x1], [y0 y1], mag(i), ...
            'FaceColor','flat', ...
            'EdgeAlpha', edgeAlpha, ...
            'LineWidth', lw);

    % -------- Arrowhead --------
    L = hypot(U(i), V(i));
    ah = ahf * L;
    theta = atan2(V(i), U(i));

    ahx = [x1-ah*cos(theta-aha), x1, x1-ah*cos(theta+aha)];
    ahy = [y1-ah*sin(theta-aha), y1, y1-ah*sin(theta+aha)];

    hp(i) = patch(ax, ahx, ahy, mag(i), ...
        'FaceColor','flat', ...
        'EdgeAlpha', edgeAlpha, ...
        'LineWidth', ahlw);
end

% -------- Colorbar --------
cb = colorbar(ax);
cb.Label.String = cbLabel;
cb.Label.Interpreter = 'latex';

% -------- Axes formatting --------
axis(ax,'equal','tight')
box(ax,'off')
xlabel(ax,'$x$','Interpreter','latex')
ylabel(ax,'$y$','Interpreter','latex')

% -------- Outputs --------
h.axes     = ax;
h.colorbar = cb;
h.contour  = hc;
h.lines    = hl;
h.heads    = hp;

end
