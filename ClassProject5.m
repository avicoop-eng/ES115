%% Project 8: Cooling of a Heated Object (Mechanical)
% Objective: Model cooling using Newton's Law of Cooling
%
% Newton's Law of Cooling:
%   T(t) = T_env + (T0 - T_env) * exp(-k * t)
%
% Where:
%   T(t)  = temperature at time t (°C)
%   T_env = ambient/environment temperature (°C)
%   T0    = initial temperature of the object (°C)
%   k     = cooling coefficient (1/s) — higher k = faster cooling
%   t     = time (seconds)

clc; clear; close all;

%% =========================================================
% PARAMETERS
% =========================================================
T_env = 25;       % Ambient temperature (°C) — room temperature
T0    = 200;      % Initial object temperature (°C) — e.g., heated metal block

t     = 0:1:300;  % Time vector: 0 to 300 seconds, step = 1s

% Three different cooling coefficients to compare
k1 = 0.005;   % Slow cooling   (e.g., insulated object)
k2 = 0.015;   % Medium cooling (e.g., bare metal in still air)
k3 = 0.035;   % Fast cooling   (e.g., forced convection / fan)

%% =========================================================
% SIMULATE TEMPERATURE DECAY — Newton's Law of Cooling
% =========================================================
T1 = T_env + (T0 - T_env) .* exp(-k1 .* t);   % Slow
T2 = T_env + (T0 - T_env) .* exp(-k2 .* t);   % Medium
T3 = T_env + (T0 - T_env) .* exp(-k3 .* t);   % Fast

%% =========================================================
% FIGURE 1: Temperature vs. Time — All Three Cooling Coefficients
% =========================================================
figure('Name', 'Cooling of a Heated Object', 'NumberTitle', 'off', ...
       'Position', [100, 100, 900, 550]);

plot(t, T1, 'b-',  'LineWidth', 2.5, ...
    'DisplayName', sprintf('Slow Cooling   (k = %.3f s^{-1})', k1));
hold on;
plot(t, T2, 'r--', 'LineWidth', 2.5, ...
    'DisplayName', sprintf('Medium Cooling (k = %.3f s^{-1})', k2));
plot(t, T3, 'g-.',  'LineWidth', 2.5, ...
    'DisplayName', sprintf('Fast Cooling   (k = %.3f s^{-1})', k3));

% Ambient temperature reference line
yline(T_env, 'k:', 'LineWidth', 1.8, ...
    'DisplayName', sprintf('Ambient Temp T_{env} = %d°C', T_env));

% Mark initial temperature
plot(0, T0, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k', ...
    'DisplayName', sprintf('Initial Temp T_0 = %d°C', T0));
hold off;

xlabel('Time (seconds)', 'FontSize', 13);
ylabel('Temperature (°C)', 'FontSize', 13);
title('Cooling of a Heated Object — Newton''s Law of Cooling', ...
      'FontSize', 15, 'FontWeight', 'bold');
legend('Location', 'northeast', 'FontSize', 11);
grid on;
xlim([0 300]);
ylim([T_env - 10, T0 + 10]);

%% =========================================================
% FIGURE 2: Cooling Rate dT/dt vs. Time
% dT/dt = -k * (T(t) - T_env)  [analytical derivative]
% =========================================================
dT1_dt = -k1 .* (T1 - T_env);
dT2_dt = -k2 .* (T2 - T_env);
dT3_dt = -k3 .* (T3 - T_env);

figure('Name', 'Cooling Rate vs Time', 'NumberTitle', 'off', ...
       'Position', [150, 150, 900, 450]);

plot(t, dT1_dt, 'b-',  'LineWidth', 2.5, ...
    'DisplayName', sprintf('Slow   (k = %.3f)', k1));
hold on;
plot(t, dT2_dt, 'r--', 'LineWidth', 2.5, ...
    'DisplayName', sprintf('Medium (k = %.3f)', k2));
plot(t, dT3_dt, 'g-.', 'LineWidth', 2.5, ...
    'DisplayName', sprintf('Fast   (k = %.3f)', k3));
yline(0, 'k:', 'LineWidth', 1.5, 'DisplayName', 'Rate = 0 (Equilibrium)');
hold off;

xlabel('Time (seconds)', 'FontSize', 13);
ylabel('Cooling Rate dT/dt (°C/s)', 'FontSize', 13);
title('Cooling Rate vs. Time', 'FontSize', 15, 'FontWeight', 'bold');
legend('Location', 'northeast', 'FontSize', 11);
grid on;

%% =========================================================
% FIGURE 3: Temperature Difference (T - T_env) on Log Scale
% This shows exponential decay as a straight line
% =========================================================
figure('Name', 'Log-Scale Temperature Difference', 'NumberTitle', 'off', ...
       'Position', [200, 200, 900, 450]);

semilogy(t, T1 - T_env, 'b-',  'LineWidth', 2.5, ...
    'DisplayName', sprintf('Slow   (k = %.3f)', k1));
hold on;
semilogy(t, T2 - T_env, 'r--', 'LineWidth', 2.5, ...
    'DisplayName', sprintf('Medium (k = %.3f)', k2));
semilogy(t, T3 - T_env, 'g-.', 'LineWidth', 2.5, ...
    'DisplayName', sprintf('Fast   (k = %.3f)', k3));
hold off;

xlabel('Time (seconds)', 'FontSize', 13);
ylabel('T(t) - T_{env}  (°C)  [log scale]', 'FontSize', 13);
title('Temperature Difference vs. Time (Logarithmic Scale)', ...
      'FontSize', 15, 'FontWeight', 'bold');
legend('Location', 'northeast', 'FontSize', 11);
grid on;

%% =========================================================
% ANALYSIS: Time to reach key temperature thresholds
% =========================================================
thresholds = [150, 100, 75, 50, 30];   % target temperatures (°C)

fprintf('============================================================\n');
fprintf('  Project 8: Cooling of a Heated Object\n');
fprintf('  T(t) = T_env + (T0 - T_env) * exp(-k*t)\n');
fprintf('============================================================\n\n');

fprintf('  Parameters:\n');
fprintf('    Initial Temperature  T0    = %d °C\n', T0);
fprintf('    Ambient Temperature  T_env = %d °C\n', T_env);
fprintf('    Time Range           t     = 0 to %d seconds\n\n', max(t));

fprintf('--- Cooling Coefficients ---\n');
fprintf('  k1 = %.3f s^-1  (Slow   — insulated object)\n',   k1);
fprintf('  k2 = %.3f s^-1  (Medium — bare metal, still air)\n', k2);
fprintf('  k3 = %.3f s^-1  (Fast   — forced convection)\n\n', k3);

% Time constant tau = 1/k (time to drop ~63.2% of excess temperature)
fprintf('--- Time Constants (tau = 1/k) ---\n');
fprintf('  tau1 = %.1f s  |  tau2 = %.1f s  |  tau3 = %.1f s\n\n', ...
        1/k1, 1/k2, 1/k3);

% Time to reach each threshold: t = -ln((T_thresh - T_env)/(T0 - T_env)) / k
fprintf('--- Time to Reach Temperature Thresholds ---\n');
fprintf('%10s  %12s  %12s  %12s\n', 'Target(°C)', 'k1 (slow)', 'k2 (med)', 'k3 (fast)');
fprintf('%s\n', repmat('-', 1, 52));

for T_thr = thresholds
    if T_thr > T_env
        ratio = (T_thr - T_env) / (T0 - T_env);
        t1_thr = -log(ratio) / k1;
        t2_thr = -log(ratio) / k2;
        t3_thr = -log(ratio) / k3;
        fprintf('%10d  %10.1f s  %10.1f s  %10.1f s\n', ...
                T_thr, t1_thr, t2_thr, t3_thr);
    end
end

%% =========================================================
% FINAL TEMPERATURE TABLE (every 30 seconds)
% =========================================================
fprintf('\n--- Temperature Values (every 30 seconds) ---\n');
fprintf('%8s  %12s  %12s  %12s\n', 't (s)', 'T1 (°C)', 'T2 (°C)', 'T3 (°C)');
fprintf('%s\n', repmat('-', 1, 50));

t_sample = 0:30:300;
T1s = T_env + (T0 - T_env) .* exp(-k1 .* t_sample);
T2s = T_env + (T0 - T_env) .* exp(-k2 .* t_sample);
T3s = T_env + (T0 - T_env) .* exp(-k3 .* t_sample);

for i = 1:length(t_sample)
    fprintf('%8d  %12.4f  %12.4f  %12.4f\n', ...
            t_sample(i), T1s(i), T2s(i), T3s(i));
end

fprintf('\n============================================================\n');
fprintf('  Physical Interpretation:\n');
fprintf('  - Higher k = faster approach to ambient temperature\n');
fprintf('  - Time constant tau=1/k is the time to lose ~63%% of excess heat\n');
fprintf('  - Log-scale plot confirms true exponential decay (straight lines)\n');
fprintf('============================================================\n');