clear
clc

% Parameters
R = 2;                 % sphere radius
N = 100;               % resolution

% Create sphere using spherical coordinates
theta = linspace(0, pi, N);        % polar angle
phi = linspace(0, 2*pi, N);        % azimuthal angle
[Phi, Theta] = meshgrid(phi, theta);

X = R * sin(Theta) .* cos(Phi);
Y = R * sin(Theta) .* sin(Phi);
Z = R * cos(Theta);

% Plot
figure;
fontsize(27,"points")
surf(X, Y, Z, 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % transparent sphere
hold on;

% Draw equator (nice reference circle)
t = linspace(0, 2*pi, 200);
plot3(R*cos(t), R*sin(t), zeros(size(t)), 'b', 'LineWidth', 2);

% Point above center
plot3(0, 0, 3, 'ro', 'MarkerFaceColor', 'r');

% Dotted line (z-axis)
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
zlim([-2.5 4])   % <-- fix here

camproj perspective
view(3);

% Optional: nicer lighting
camlight;
lighting gouraud;