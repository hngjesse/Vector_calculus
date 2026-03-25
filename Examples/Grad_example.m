% Create grid
[x, y] = meshgrid(linspace(-pi, pi, 20));

% Scalar field
f = sin(x) .* cos(y);


figure
vplot_grad(x,y,f, ...
    'Scale',0.9, ...
    'Colormap',parula, ...
    'ArrowHeadFrac',0.45, ...
    'ArrowHeadAngle',pi/7, ...
    'LineWidth', 1,...
    'EdgeAlpha', 0.5);

fontsize(27,"points")
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
cb = colorbar;
ylabel(cb,'$\nabla f$','Interpreter','latex')
xlim([-pi pi])
ylim([-pi pi])

pbaspect([1 1 1])
box off
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', 'XColor', 'k', 'YColor', 'k', 'TickDir', 'out')