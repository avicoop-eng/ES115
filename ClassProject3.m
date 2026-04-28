%% Project 5: Two-Sensor Calibration and Agreement Check (Linear Fit + Error)
% Two sensors: y1 = m1*x + b1,  y2 = m2*x + b2
% Each sensor calibrated using two known points

clc; clear; close all;

%% =========================================================
% TASK 1: Choose calibration points & compute (m, b) for each sensor
% =========================================================
% Sensor 1 calibration points: (x, y) pairs from known measurements
% These simulate a slightly ideal sensor
S1_x = [0,  30];       % known input values
S1_y = [2,  62];       % sensor 1 output at those inputs

% Sensor 2 calibration points: slightly different (miscalibrated)
S2_x = [0,  30];       % same input range
S2_y = [5,  57];       % sensor 2 output — different slope & intercept

% --- Compute slope (m) and intercept (b) from two-point formula ---
% m = (y2 - y1) / (x2 - x1),   b = y1 - m*x1

m1 = (S1_y(2) - S1_y(1)) / (S1_x(2) - S1_x(1));
b1 = S1_y(1) - m1 * S1_x(1);

m2 = (S2_y(2) - S2_y(1)) / (S2_x(2) - S2_x(1));
b2 = S2_y(1) - m2 * S2_x(1);

fprintf('============================================================\n');
fprintf('  Two-Sensor Calibration and Agreement Check\n');
fprintf('============================================================\n\n');
fprintf('--- Calibration Results ---\n');
fprintf('  Sensor 1:  y1 = %.4f * x + %.4f\n', m1, b1);
fprintf('  Sensor 2:  y2 = %.4f * x + %.4f\n', m2, b2);
fprintf('\n');

%% =========================================================
% TASK 2: Evaluate both sensor models for x = 0:1:30
% =========================================================
x  = 0:1:30;

y1 = m1 .* x + b1;    % Sensor 1 output
y2 = m2 .* x + b2;    % Sensor 2 output

%% =========================================================
% TASK 3: Plot both sensor outputs on the same figure
% =========================================================
figure('Name', 'Sensor Outputs Comparison', 'NumberTitle', 'off');

plot(x, y1, 'b-o', 'LineWidth', 2, 'MarkerSize', 5, ...
    'DisplayName', sprintf('Sensor 1: y_1 = %.2fx + %.2f', m1, b1));
hold on;
plot(x, y2, 'r-s', 'LineWidth', 2, 'MarkerSize', 5, ...
    'DisplayName', sprintf('Sensor 2: y_2 = %.2fx + %.2f', m2, b2));

% Mark calibration points
plot(S1_x, S1_y, 'b*', 'MarkerSize', 12, 'LineWidth', 2, ...
    'DisplayName', 'Sensor 1 Calibration Pts');
plot(S2_x, S2_y, 'r*', 'MarkerSize', 12, 'LineWidth', 2, ...
    'DisplayName', 'Sensor 2 Calibration Pts');
hold off;

xlabel('Input Value, x', 'FontSize', 12);
ylabel('Sensor Output, y', 'FontSize', 12);
title('Two-Sensor Output Comparison', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'northwest', 'FontSize', 10);
grid on;

%% =========================================================
% TASK 4: Compute error e(x) = y1 - y2 and plot separately
% =========================================================
e = y1 - y2;    % agreement error at each x

figure('Name', 'Sensor Agreement Error e(x) = y1 - y2', 'NumberTitle', 'off');

plot(x, e, 'm-d', 'LineWidth', 2, 'MarkerSize', 5, 'DisplayName', 'e(x) = y_1 - y_2');
hold on;
yline(0, 'k--', 'LineWidth', 1.5, 'DisplayName', 'Perfect Agreement (e = 0)');
hold off;

xlabel('Input Value, x', 'FontSize', 12);
ylabel('Error e(x) = y_1 - y_2 (mm)', 'FontSize', 12);
title('Sensor Agreement Error', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 10);
grid on;

%% =========================================================
% TASK 5: Identify x where sensors agree best (min absolute error)
% =========================================================
abs_e = abs(e);
[min_err, idx_min] = min(abs_e);
x_agree = x(idx_min);

fprintf('--- Agreement Analysis ---\n');
fprintf('  x value where sensors agree best : x = %g\n', x_agree);
fprintf('  Minimum absolute error           : |e| = %.6f\n', min_err);
fprintf('  Sensor 1 output at x_agree       : y1 = %.4f\n', y1(idx_min));
fprintf('  Sensor 2 output at x_agree       : y2 = %.4f\n', y2(idx_min));
fprintf('\n');

% Analytical crossover point: solve m1*x + b1 = m2*x + b2
if (m1 - m2) ~= 0
    x_cross = (b2 - b1) / (m1 - m2);
    y_cross = m1 * x_cross + b1;
    fprintf('--- Analytical Crossover (exact agreement) ---\n');
    fprintf('  Sensors are identical at x = %.4f\n', x_cross);
    fprintf('  Both output y = %.4f at this point\n', y_cross);
else
    fprintf('  Sensors have equal slopes — they never cross (parallel lines).\n');
end

%% =========================================================
% SUMMARY TABLE: x, y1, y2, e(x), |e(x)|
% =========================================================
fprintf('\n--- Data Table (x = 0 to 30) ---\n');
fprintf('%6s  %10s  %10s  %10s  %10s\n', 'x', 'y1', 'y2', 'e(x)', '|e(x)|');
fprintf('%s\n', repmat('-', 1, 55));
for i = 1:length(x)
    marker = '';
    if x(i) == x_agree
        marker = '  <-- Best Agreement';
    end
    fprintf('%6g  %10.4f  %10.4f  %10.4f  %10.4f%s\n', ...
        x(i), y1(i), y2(i), e(i), abs_e(i), marker);
end

%% =========================================================
% Add best-agreement marker to both figures
% =========================================================
figure(1);   % Sensor outputs figure
hold on;
plot(x_agree, y1(idx_min), 'ko', 'MarkerSize', 14, 'LineWidth', 2.5, ...
    'DisplayName', sprintf('Best Agreement at x = %g', x_agree));
hold off;
legend('Location', 'northwest', 'FontSize', 10);

figure(2);   % Error figure
hold on;
plot(x_agree, e(idx_min), 'ko', 'MarkerSize', 14, 'LineWidth', 2.5, ...
    'DisplayName', sprintf('Min |e| = %.4f at x = %g', min_err, x_agree));
hold off;
legend('Location', 'best', 'FontSize', 10);