clear
clc

f = @(x,y) y.*x.^2 + x.*y.^2;

l = 2;
x = -l:0.01:l;
y = -l:0.01:l;

[X,Y] = meshgrid(linspace(-pi, pi, 20));

F = f(X,Y);


figure
contourf(X,Y,F,20, 'LineColor', 'none')
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