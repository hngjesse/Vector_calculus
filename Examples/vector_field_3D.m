clear
clc



x = linspace(-pi, pi, 10);
[X, Y, Z] = meshgrid(x, x, x);
U = -cos(Y);
V = X;
W = Z;


figure
vplot3(X,Y,Z,U,V,W,'Scale',0.5,'Colormap',parula(256))
fontsize(27,"points")
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
zlabel('$z$','Interpreter','latex')
cb = colorbar;
ylabel(cb,'$\mathbf{v}(x,y)$','Interpreter','latex')
xlim([-pi pi])
ylim([-pi pi])
zlim([-pi pi])
pbaspect([1 1 1])
box off
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', 'XColor', 'k', 'YColor', 'k', 'TickDir', 'out')