clear
clc

% Parameters
R = 2;                 % disk radius
N = 100;               % resolution

% Create disk using polar coordinates
r = linspace(0, R, N);
theta = linspace(0, 2*pi, N);
[Rg, Tg] = meshgrid(r, theta);

X = Rg .* cos(Tg);
Y = Rg .* sin(Tg);
Z = zeros(size(X));

% Plot
figure;
fontsize(27,"points")
surf(X, Y, Z, 'FaceAlpha', 0.5, 'EdgeColor', 'none'); % semi-transparent disk
hold on;

% Draw boundary circle (clean edge)
t = linspace(0, 2*pi, 200);
plot3(R*cos(t), R*sin(t), zeros(size(t)), 'b', 'LineWidth', 2);

% Point above center
plot3(0, 0, 3, 'ro', 'MarkerFaceColor', 'r');

% Dotted line (axis)
plot3([0 0], [0 0], [0 3], 'k--', 'LineWidth', 1.5);
% Dotted line (radius)
plot3([0 -1], [0 -1.7], [0 0], 'k--', 'LineWidth', 1.5);

% Labels
xlabel('x');
ylabel('y');
zlabel('z');
grid on;

text(0, -0.5, 0, '$R$', 'Interpreter','latex', 'FontSize',27);
text(0, 0, 1.5, '$z$', 'Interpreter','latex', 'FontSize',27);

axis equal;
xlim([-2.5 2.5])
ylim([-2.5 2.5])
zlim([0 4])

camproj perspective
view(3);