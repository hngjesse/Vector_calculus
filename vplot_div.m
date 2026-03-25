function h = vplot_div(X, Y, U, V, varargin)
% VPLOT_DIV: 2D vector field + divergence with shared colorbar
% Arrow shafts and heads colored by magnitude with adjustable edge transparency.
% Can optionally hide arrow shafts.

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
p.addParameter('ColorbarLabel', 'Shared scale (divergence + |v|)', @ischar);
p.parse(varargin{:});

scale  = p.Results.Scale;
lw     = p.Results.LineWidth;
cmap   = p.Results.Colormap;
nLvl   = p.Results.Levels;
ahf    = p.Results.ArrowHeadFrac;
aha    = p.Results.ArrowHeadAngle;
ahlw   = p.Results.ArrowHeadLineWidth;
ax     = p.Results.Parent;
cbLabel = p.Results.ColorbarLabel;
edgeAlpha = p.Results.EdgeAlpha;

hold(ax, 'on')

% -------- Compute fields --------
div = divergence(X, Y, U, V);
mag = hypot(U, V);

% -------- Global color limits for shared colorbar --------
cmin = min([mag(:); div(:)]);
cmax = max([mag(:); div(:)]);

% -------- Divergence as filled contour --------
hc = contourf(ax, X, Y, div, nLvl, 'LineColor', 'none');

% -------- Normalize vectors and autoscale --------
dx = min(diff(unique(X(:))));
dy = min(diff(unique(Y(:))));
baseScale = min(dx, dy);

zeroMask = mag == 0;
mag_safe = mag;
mag_safe(zeroMask) = 1;  % avoid division by zero

Uu = U ./ mag_safe;
Vu = V ./ mag_safe;

Uplot = Uu * baseScale * scale;
Vplot = Vu * baseScale * scale;

% -------- Color mapping --------
colormap(ax, cmap)
clim(ax, [cmin cmax])

idx = round((mag - min(mag(:))) / (max(mag(:)) - min(mag(:))) * (size(cmap,1)-1)) + 1;
idx = max(1, min(idx, size(cmap,1)));

% -------- Plot vectors --------
n = numel(X);
hl = gobjects(n,1);
hp = gobjects(n,1);

for i = 1:n
    if zeroMask(i), continue, end

    x0 = X(i); y0 = Y(i);
    x1 = x0 + Uplot(i);
    y1 = y0 + Vplot(i);

    c = cmap(idx(i),:);

    % -------- Arrow shaft --------

    hl(i) = patch(ax, [x0 x1], [y0 y1], mag(i), ...
            'FaceColor', 'flat', 'EdgeAlpha', edgeAlpha, 'LineWidth', lw);


    % -------- Arrowhead --------
    L = hypot(Uplot(i), Vplot(i));
    ah = ahf * L;
    theta = atan2(Vplot(i), Uplot(i));

    ahx = [x1 - ah*cos(theta - aha), x1, x1 - ah*cos(theta + aha)];
    ahy = [y1 - ah*sin(theta - aha), y1, y1 - ah*sin(theta + aha)];

    hp(i) = patch(ax, ahx, ahy, mag(i), ...
        'FaceColor', 'flat', 'EdgeAlpha', edgeAlpha, 'LineWidth', ahlw);
end

% -------- Colorbar --------
cb = colorbar(ax);
cb.Label.String = cbLabel;
cb.Label.Interpreter = 'latex';

% -------- Axes formatting --------
axis(ax, 'equal', 'tight')
box(ax, 'off')
xlabel(ax,'$x$','Interpreter','latex')
ylabel(ax,'$y$','Interpreter','latex')

% -------- Output handles --------
h.axes     = ax;
h.colorbar = cb;
h.contour  = hc;
h.lines    = hl;
h.heads    = hp;

end
