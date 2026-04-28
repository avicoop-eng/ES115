%% Project 2: Bridge Deflection Model Comparison (Quadratic + Sensitivity)
% d(x) = ax^2 + bx + c
% x = position along beam (meters), d(x) = deflection (mm)

clc; clear; close all;

%% =========================================================
% TASK 1: Define Baseline Model Parameters (a, b, c)
% =========================================================
% Baseline Model 1: realistic parameters for a simply-supported beam
a1 = -0.5;   % curvature (negative = downward deflection)
b1 = 5;      % linear slope term
c1 = 0;      % baseline offset (mm) — zero deflection at x=0

% Model 2: change 'a' only (more flexible / less stiff beam)
a2 = -1.0;   % doubled curvature
b2 = b1;
c2 = c1;

% Model 3: change 'c' only (non-zero baseline offset)
a3 = a1;
b3 = b1;
c3 = 10;     % 10 mm baseline offset (e.g., pre-camber or settlement)

%% =========================================================
% TASK 2 & 3: Evaluate all three models on x = 0:0.25:10
% =========================================================
x = 0:0.25:10;   % position vector (meters)

d1 = a1*x.^2 + b1*x + c1;   % Baseline Model
d2 = a2*x.^2 + b2*x + c2;   % Model 2 (changed a)
d3 = a3*x.^2 + b3*x + c3;   % Model 3 (changed c)

%% =========================================================
% TASK 4: Plot all models on one figure with a legend
% =========================================================
figure('Name', 'Bridge Deflection Model Comparison', 'NumberTitle', 'off');
plot(x, d1, 'b-o', 'LineWidth', 2, 'MarkerSize', 4, 'DisplayName', ...
    sprintf('Model 1 (Baseline): a=%.1f, b=%.1f, c=%.1f', a1, b1, c1));
hold on;
plot(x, d2, 'r-s', 'LineWidth', 2, 'MarkerSize', 4, 'DisplayName', ...
    sprintf('Model 2 (a changed): a=%.1f, b=%.1f, c=%.1f', a2, b2, c2));
plot(x, d3, 'g-^', 'LineWidth', 2, 'MarkerSize', 4, 'DisplayName', ...
    sprintf('Model 3 (c changed): a=%.1f, b=%.1f, c=%.1f', a3, b3, c3));
hold off;

xlabel('Position along Beam, x (m)', 'FontSize', 12);
ylabel('Deflection, d(x) (mm)', 'FontSize', 12);
title('Bridge Deflection Model Comparison', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);
grid on;

%% =========================================================
% TASK 5: Find minimum (or maximum) deflection for each model
% =========================================================
fprintf('============================================================\n');
fprintf('  Bridge Deflection Model Comparison — Sensitivity Analysis\n');
fprintf('============================================================\n\n');

models    = {d1, d2, d3};
labels    = {'Model 1 (Baseline)', 'Model 2 (a changed)', 'Model 3 (c changed)'};
params    = {[a1,b1,c1], [a2,b2,c2], [a3,b3,c3]};

for i = 1:3
    d = models{i};
    
    [d_min, idx_min] = min(d);
    [d_max, idx_max] = max(d);
    
    fprintf('%s  |  a=%.1f, b=%.1f, c=%.1f\n', labels{i}, params{i}(1), params{i}(2), params{i}(3));
    fprintf('  Max Deflection : %8.4f mm  at x = %.2f m\n', d_max, x(idx_max));
    fprintf('  Min Deflection : %8.4f mm  at x = %.2f m\n', d_min, x(idx_min));
    fprintf('\n');
end

%% =========================================================
% OPTIONAL EXTENSION: Finite Difference Rate of Change
% =========================================================
% Using forward finite differences: d'(x) ≈ [d(x+h) - d(x)] / h
h  = 0.25;                        % step size (same as x spacing)
x_fd = x(1:end-1);               % x-values for finite difference

fd1 = diff(d1) / h;              % rate of change for Model 1
fd2 = diff(d2) / h;              % rate of change for Model 2
fd3 = diff(d3) / h;              % rate of change for Model 3

figure('Name', 'Rate of Change of Deflection (Finite Differences)', 'NumberTitle', 'off');
plot(x_fd, fd1, 'b-o', 'LineWidth', 2, 'MarkerSize', 4, 'DisplayName', 'Model 1 (Baseline)');
hold on;
plot(x_fd, fd2, 'r-s', 'LineWidth', 2, 'MarkerSize', 4, 'DisplayName', 'Model 2 (a changed)');
plot(x_fd, fd3, 'g-^', 'LineWidth', 2, 'MarkerSize', 4, 'DisplayName', 'Model 3 (c changed)');
yline(0, 'k--', 'LineWidth', 1.2);   % zero-rate reference line
hold off;

xlabel('Position along Beam, x (m)', 'FontSize', 12);
ylabel('Rate of Change of Deflection (mm/m)', 'FontSize', 12);
title('Finite Difference Approximation of Deflection Rate', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);
grid on;

fprintf('============================================================\n');
fprintf('  Finite Difference Results (sample at x = 5 m, index 21)\n');
fprintf('============================================================\n');
fprintf('  Model 1 rate at x≈5m : %.4f mm/m\n', fd1(21));
fprintf('  Model 2 rate at x≈5m : %.4f mm/m\n', fd2(21));
fprintf('  Model 3 rate at x≈5m : %.4f mm/m\n', fd3(21));