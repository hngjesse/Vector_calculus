[x, y] = meshgrid(linspace(-pi, pi, 20));

V = 0.5*(x.^2 + y.^2);



figure
vplot_grad(x,y,V, ...
    'Scale',0.7, ...
    'Colormap',parula, ...
    'ArrowHeadFrac',0.4, ...
    'ArrowHeadAngle',pi/8, ...
    'LineWidth', 1,...
    'EdgeAlpha', 0.5);

fontsize(27,"points")
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
cb = colorbar;
ylabel(cb,'$\nabla\cdot v$','Interpreter','latex')
xlim([-pi pi])
ylim([-pi pi])

pbaspect([1 1 1])
box off
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', 'XColor', 'k', 'YColor', 'k', 'TickDir', 'out')