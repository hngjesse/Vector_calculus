function h = vplot(X, Y, U, V, varargin)

% -------- Input parsing --------
p = inputParser;
p.addParameter('Scale', 1, @(x) isnumeric(x) && isscalar(x));
p.addParameter('LineWidth', 1.2, @(x) isnumeric(x));
p.addParameter('Colormap', cool(256));
p.addParameter('ArrowHeadFrac', 0.4, @(x) isnumeric(x) && isscalar(x));
p.addParameter('ArrowHeadAngle', pi/6, @(x) isnumeric(x) && isscalar(x));
p.addParameter('Colorbar', true, @(x) islogical(x) || isnumeric(x));
p.addParameter('Parent', gca);
p.parse(varargin{:});

userScale = p.Results.Scale;
lw   = p.Results.LineWidth;
cmap = p.Results.Colormap;
ahf  = p.Results.ArrowHeadFrac;
aha  = p.Results.ArrowHeadAngle;
showCB = logical(p.Results.Colorbar);
ax   = p.Results.Parent;

hold(ax, 'on')

% -------- Infer grid spacing (autoscale base) --------
dx = min(diff(unique(X(:))));
dy = min(diff(unique(Y(:))));
baseScale = min(dx, dy);

scale = userScale * baseScale;

% -------- Vector magnitude --------
mag = hypot(U, V);

% -------- Zero-magnitude handling --------
zeroMask = mag == 0;
mag_safe = mag;
mag_safe(zeroMask) = 1;   % prevent division by zero

% -------- Normalize vectors --------
Uu = U ./ mag_safe;
Vu = V ./ mag_safe;

U = Uu * scale;
V = Vu * scale;

% -------- Color mapping --------
mag_min = min(mag(:));
mag_max = max(mag(:));

colormap(ax, cmap)
clim(ax, [mag_min mag_max])

idx = round((mag - mag_min) / (mag_max - mag_min) * (size(cmap,1)-1)) + 1;
idx = max(1, min(idx, size(cmap,1)));

% -------- Plot arrows --------
n = numel(X);
hl = gobjects(n,1);
hp = gobjects(n,1);

for i = 1:n
    if zeroMask(i)
        continue   % skip zero-length vectors
    end

    x0 = X(i); y0 = Y(i);
    x1 = x0 + U(i); y1 = y0 + V(i);
    c  = cmap(idx(i),:);

    % Arrow shaft
    hl(i) = line(ax, [x0 x1], [y0 y1], ...
        'Color', c, 'LineWidth', lw);

    % Arrowhead (scaled with arrow length)
    L = hypot(U(i), V(i));
    ah = ahf * L;

    theta = atan2(V(i), U(i));
    ahx = [x1 - ah*cos(theta - aha), x1, ...
           x1 - ah*cos(theta + aha)];
    ahy = [y1 - ah*sin(theta - aha), y1, ...
           y1 - ah*sin(theta + aha)];

    hp(i) = patch(ax, ahx, ahy, c, 'EdgeColor','none');
end

% -------- Colorbar --------
if showCB
    h.colorbar = colorbar(ax);
else
    h.colorbar = [];
end

xlabel(ax,'$x$','Interpreter','latex')
ylabel(ax,'$y$','Interpreter','latex')

axis(ax,'equal')   % ensure correct arrow geometry

% -------- Output handles --------
h.lines = hl;
h.heads = hp;
h.axes  = ax;

end
