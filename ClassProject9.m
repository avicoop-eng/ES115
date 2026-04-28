%% PROBLEM 5.31:
% Create x and y vectors from -5 to +5 with spacing of 0.5.
% Use meshgrid to map x and y onto 2D arrays X and Y.
% Calculate Z = sin(sqrt(X^2 + Y^2))
% a. mesh plot
% b. surf plot (single input vs three inputs)
% c. interpolated shading with different colormaps
% d. contour plot with clabel labels
% e. combination surface and contour plot

x = -5:0.5:5;
y = -5:0.5:5;
[X, Y] = meshgrid(x, y);
Z = sin(sqrt(X.^2 + Y.^2));

% a. Mesh plot
figure;
mesh(X, Y, Z);
title('Mesh Plot of Z');
xlabel('X'); ylabel('Y'); zlabel('Z');

% b. Surf plot
figure;
surf(Z);
title('Surf - Single Input');

figure;
surf(X, Y, Z);
title('Surf - Three Inputs');

% c. Interpolated shading
figure;
surf(X, Y, Z);
shading interp;
colormap jet;
title('Interpolated Shading - jet colormap');

% d. Contour with labels
figure;
C = contour(X, Y, Z);
clabel(C);
title('Contour Plot');
xlabel('X'); ylabel('Y');

% e. Surface + contour combo
figure;
surfc(X, Y, Z);
title('Surface + Contour');
xlabel('X'); ylabel('Y'); zlabel('Z');