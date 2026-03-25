clear
clc
close all



%% --- Create arbitrary wavy surface ---
[x, y] = meshgrid(linspace(-2,2,20), linspace(-2,2,20));



% Wavy surface
z = 0.5*sin(x).*cos(y);

figure;

surf(x, y, z, ...
    'FaceAlpha', 0.6, ...
    'EdgeColor', [0.4 0.4 0.4], ...
    'LineWidth', 0.5);

shading faceted   % <-- IMPORTANT (keeps grid)
hold on;

%% --- Choose a point on surface ---
x0 = 0.5;
y0 = 0.5;
z0 = 0.5*sin(x0)*cos(y0);



plot3(x0, y0, z0, 'ro', 'MarkerFaceColor','r');

%% --- Compute normal vector ---
% Surface: z = f(x,y)
fx = 0.5*cos(x0)*cos(y0);      % ∂z/∂x
fy = -0.5*sin(x0)*sin(y0);     % ∂z/∂y

% Normal vector = (-fx, -fy, 1)
n = [-fx, -fy, 1];
n = n / norm(n);   % normalize

% Plot normal
quiver3(x0, y0, z0, n(1), n(2), n(3), 1, ...
    'k', 'LineWidth', 2);

%% --- Pillbox parameters ---
a = 0.3;   % radius
h = 0.8;   % height

%% --- Create cylinder along z-axis first ---
[XC, YC, ZC] = cylinder(a, 40);
ZC = h*(ZC - 0.5);   % center at 0

%% --- Rotate cylinder to align with normal ---
% Default axis = [0 0 1]
k = [0 0 1];

% Rotation axis
v = cross(k, n);
s = norm(v);
c = dot(k, n);

% Skew-symmetric matrix
vx = [  0   -v(3)  v(2);
      v(3)   0   -v(1);
     -v(2) v(1)   0 ];

% Rotation matrix (Rodrigues formula)
if s ~= 0
    R = eye(3) + vx + vx^2*((1-c)/(s^2));
else
    R = eye(3);
end

% Apply rotation
pts = R * [XC(:)'; YC(:)'; ZC(:)'];

XC_rot = reshape(pts(1,:), size(XC));
YC_rot = reshape(pts(2,:), size(YC));
ZC_rot = reshape(pts(3,:), size(ZC));

% Shift to surface point
XC_rot = XC_rot + x0;
YC_rot = YC_rot + y0;
ZC_rot = ZC_rot + z0;

% Plot pillbox surface
surf(XC_rot, YC_rot, ZC_rot, ...
    'FaceAlpha', 0.7, ...
    'EdgeColor', 'none');

%% --- Caps ---
theta = linspace(0,2*pi,50);
r = linspace(0,a,30);
[Theta, Rr] = meshgrid(theta, r);

Xcap = Rr .* cos(Theta);
Ycap = Rr .* sin(Theta);
Zcap = zeros(size(Xcap));

% Rotate caps
pts_cap = R * [Xcap(:)'; Ycap(:)'; Zcap(:)'];
Xcap = reshape(pts_cap(1,:), size(Xcap));
Ycap = reshape(pts_cap(2,:), size(Ycap));
Zcap = reshape(pts_cap(3,:), size(Zcap));

% Top and bottom centers
top_center = [x0, y0, z0] + (h/2)*n;
bot_center = [x0, y0, z0] - (h/2)*n;

% Plot caps
surf(Xcap + top_center(1), Ycap + top_center(2), Zcap + top_center(3), ...
    'FaceAlpha',0.7,'EdgeColor','none');

surf(Xcap + bot_center(1), Ycap + bot_center(2), Zcap + bot_center(3), ...
    'FaceAlpha',0.7,'EdgeColor','none');

%% --- Labels ---
xlabel('x'); ylabel('y'); zlabel('z');
grid on;
axis equal;

text(x0, y0, z0 + 1, '$\hat{n}$','Interpreter','latex','FontSize',18);
text(top_center(1), top_center(2), top_center(3)+0.2, '$S_+$','Interpreter','latex');
text(bot_center(1), bot_center(2), bot_center(3)-0.2, '$S_-$','Interpreter','latex');

view(3);
camproj perspective
camlight;
lighting gouraud;


%% --- INTERSECTION CURVE (TRUE 3D) ---

% Define function for surface
f = @(x,y) 0.5*sin(x).*cos(y);

% Build local orthonormal basis (tangent plane)
t1 = null(n)';   % gives 2 orthonormal tangent vectors
e1 = t1(1,:);
e2 = t1(2,:);

% Parametrize circle in tangent plane
theta_c = linspace(0, 2*pi, 200);

curve_pts = [];

for i = 1:length(theta_c)
    
    % Initial guess on tangent plane
    p0 = [x0, y0, z0] + a*(cos(theta_c(i))*e1 + sin(theta_c(i))*e2);
    
    % Project vertically onto actual surface
    x_guess = p0(1);
    y_guess = p0(2);
    z_guess = f(x_guess, y_guess);
    
    curve_pts = [curve_pts; x_guess, y_guess, z_guess];
end

% Plot intersection curve
plot3(curve_pts(:,1), curve_pts(:,2), curve_pts(:,3), ...
    'k', 'LineWidth', 2);