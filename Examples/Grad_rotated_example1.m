% Grid
[x, y] = meshgrid(linspace(-pi, pi, 20));

% Stream function (incompressible flow)
psi = sin(x).*sin(y) ...
    + 0.4*sin(2*x + 0.7*y) ...
    + 0.3*cos(1.3*x - 2*y);



figure
vplot_grad(x,y,psi, ...
    'Scale',0.9, ...
    'Colormap',parula, ...
    'ArrowHeadFrac',0.45, ...
    'ArrowHeadAngle',pi/7, ...
    'LineWidth', 1,...
    'EdgeAlpha', 0.5,...
    'RotatedGrad', true);

fontsize(27,"points")
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
cb = colorbar;
ylabel(cb,'$\nabla^\perp \psi$','Interpreter','latex')
xlim([-pi pi])
ylim([-pi pi])

pbaspect([1 1 1])
box off
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', 'XColor', 'k', 'YColor', 'k', 'TickDir', 'out')