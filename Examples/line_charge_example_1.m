clear
clc

% Parameters
L = 2;                 % half-length (you can change this)
N = 200;               % number of points for smoothness

% Line charge coordinates
x = linspace(-L, L, N);
y = zeros(size(x));
z = zeros(size(x));


% Plot
figure;
fontsize(27,"points")
plot3(x, y, z, 'b', 'LineWidth', 3);
hold on;

% Mark endpoints
plot3(-L, 0, 0, 'ro', 'MarkerFaceColor', 'r');
plot3(L, 0, 0, 'ro', 'MarkerFaceColor', 'r');
plot3(0, 0, 3, 'ro', 'MarkerFaceColor', 'r');

plot3([0 0], [0 0], [0 3], 'k--', 'LineWidth', 1.5);

% Labels and formatting
xlabel('x');
ylabel('y');
zlabel('z');
grid on;

text(0,-0.3,0,'$2L$','Interpreter','latex', 'FontSize', 27,'Color','k');
text(0,0,1.5,'$z$','Interpreter','latex', 'FontSize', 27,'Color','k');

axis equal;
xlim([-2 2])
ylim([-2 2])
zlim([-0 4])
camproj perspective
view(3);