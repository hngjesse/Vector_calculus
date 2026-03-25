clear
clc


% Example vector field
[X, Y] = meshgrid(linspace(-pi, pi, 20));
U = sin(Y);  % Example: circular flow
V = cos(X);



vplot(X,Y,U,V,'Scale',1,'Colormap',parula(256))

fontsize(27,"points")
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
cb = colorbar;
ylabel(cb,'$\mathbf{v}(x,y)$','Interpreter','latex')
xlim([-pi pi])
ylim([-pi pi])

pbaspect([1 1 1])
box off
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', 'XColor', 'k', 'YColor', 'k', 'TickDir', 'out')