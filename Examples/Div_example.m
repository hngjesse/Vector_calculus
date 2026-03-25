% Create grid
[x, y] = meshgrid(linspace(-pi, pi, 20));

% Vector field

vx = sin(x + y);
vy = cos(x - y);



figure
vplot_div(x,y,vx,vy, ...
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
ylabel(cb,'$\nabla\cdot v$','Interpreter','latex')
xlim([-pi pi])
ylim([-pi pi])

pbaspect([1 1 1])
box off                      
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', 'XColor', 'k', 'YColor', 'k', 'TickDir', 'out')  