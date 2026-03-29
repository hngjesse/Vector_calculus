function h = vplotl(X, Y, U, V, varargin)

% -------- Input parsing --------
p = inputParser;
p.addParameter('Scale', 1, @(x) isnumeric(x) && isscalar(x));
p.addParameter('LineWidth', 1.2, @(x) isnumeric(x));
p.addParameter('Color', 'k');   % single color
p.addParameter('ArrowHeadFrac', 0.4, @(x) isnumeric(x) && isscalar(x));
p.addParameter('ArrowHeadAngle', pi/6, @(x) isnumeric(x) && isscalar(x));
p.addParameter('Parent', gca);
p.parse(varargin{:});

userScale = p.Results.Scale;
lw   = p.Results.LineWidth;
col  = p.Results.Color;
ahf  = p.Results.ArrowHeadFrac;
aha  = p.Results.ArrowHeadAngle;
ax   = p.Results.Parent;

hold(ax, 'on')

% -------- Infer grid spacing --------
dx = min(diff(unique(X(:))));
dy = min(diff(unique(Y(:))));
baseScale = min(dx, dy);

% -------- Vector magnitude --------
mag = hypot(U, V);
mag_max = max(mag(:));

% -------- Avoid division by zero --------
zeroMask = mag == 0;
mag_safe = mag;
mag_safe(zeroMask) = 1;

% -------- SCALE BY MAGNITUDE --------
% Max arrow length = baseScale * userScale
scale = userScale * baseScale / max(mag_max, eps);

U = U * scale;
V = V * scale;

% -------- Plot arrows --------
n = numel(X);
hl = gobjects(n,1);
hp = gobjects(n,1);

for i = 1:n
    if zeroMask(i)
        continue
    end

    x0 = X(i); y0 = Y(i);
    x1 = x0 + U(i); y1 = y0 + V(i);

    % Shaft
    hl(i) = line(ax, [x0 x1], [y0 y1], ...
        'Color', col, 'LineWidth', lw);

    % Arrowhead
    L = hypot(U(i), V(i));
    ah = ahf * L;

    theta = atan2(V(i), U(i));
    ahx = [x1 - ah*cos(theta - aha), x1, ...
           x1 - ah*cos(theta + aha)];
    ahy = [y1 - ah*sin(theta - aha), y1, ...
           y1 - ah*sin(theta + aha)];

    hp(i) = patch(ax, ahx, ahy, col, 'EdgeColor','none');
end

% -------- Axes --------
xlabel(ax,'$x$','Interpreter','latex')
ylabel(ax,'$y$','Interpreter','latex')

axis(ax,'equal')

% -------- Output --------
h.lines = hl;
h.heads = hp;
h.axes  = ax;

end