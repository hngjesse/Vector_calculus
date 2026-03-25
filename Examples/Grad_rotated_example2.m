% Grid

[x, y] = meshgrid(linspace(-pi, pi, 20));


% Vorticity field
omega = sin(1.3*x).*cos(0.9*y) ...
      + 0.6*cos(2.2*x + y);


figure
vplot_grad(x,y,omega, ...
    'Scale',0.7, ...
    'Colormap',parula, ...
    'ArrowHeadFrac',0.7, ...
    'ArrowHeadAngle',pi/20, ...
    'LineWidth', 1,...
    'EdgeAlpha', 0.5,...
    'RotatedGrad', true);

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