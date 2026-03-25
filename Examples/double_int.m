% Clear workspace
clear; clc; close all;

% x-range
x = linspace(0, 2, 500);

% Number of random control points
n_points = 6;

% Generate random control points for lower curve
x_ctrl = linspace(0, 2, n_points);
y_ctrl_lower = 0.5 + 0.2*[1 3 2 1 2 2];  % lower curve around 0.5

% Generate smooth lower curve using spline
y_lower = spline(x_ctrl, y_ctrl_lower, x);

% Generate random upper curve above the lower curve
y_ctrl_upper = y_lower( round(linspace(1, length(x), n_points)) ) + 0.3 + 0.2*[1 3 2 1 2 2];
y_upper = spline(x_ctrl, y_ctrl_upper, x);

% Create closed curve for filling
X = [x, fliplr(x)];
Y = [y_upper, fliplr(y_lower)];

% Plot
figure;


fill(X, Y, [0.8 0.8 1], 'LineWidth', 1.5); % filled region
hold on;
plot(x, y_upper, 'r', 'LineWidth', 2); % upper curve
plot(x, y_lower, 'g', 'LineWidth', 2); % lower curve
hold off;

fontsize(27,"points")
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')

xlim([-1 3])
ylim([0.5 2.2])

text(1.5,1.85,'$h(x)$','Interpreter','latex', 'FontSize', 27,'Color','k');
text(1.0,0.65,'$g(x)$','Interpreter','latex', 'FontSize', 27,'Color','k');

text(-0.7,1.1,'$x = a$','Interpreter','latex', 'FontSize', 27,'Color','k');
text(2,1.1,'$x = b$','Interpreter','latex', 'FontSize', 27,'Color','k');

text(1,1,'$R$','Interpreter','latex', 'FontSize', 27,'Color','k');

pbaspect([1 1 1])
box off


set(gca, 'XTickLabel', [], 'YTickLabel', [])