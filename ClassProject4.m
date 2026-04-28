%% Project 19: Vehicle Fuel Consumption (Mechanical)
% Objective: Estimate fuel usage over a simplified driving cycle
%
% Driving Cycle Phases:
%   1. Idle       : v = 0 km/h         (engine on, not moving)
%   2. Accelerate : 0 → 80 km/h
%   3. Cruise     : v = 80 km/h        (constant highway speed)
%   4. Decelerate : 80 → 30 km/h
%   5. City Drive : v = 30 km/h        (constant city speed)
%   6. Brake/Stop : 30 → 0 km/h
%
% Fuel Consumption Model:
%   FCR(t) = FC_idle + alpha * |a(t)| + beta * v(t)^2
%   Units: liters/second
%
% Where:
%   FC_idle = base idle fuel rate (L/s)
%   alpha   = acceleration fuel penalty coefficient (L*s/m)
%   beta    = aerodynamic drag fuel coefficient (L*s/m^2)
%   a(t)    = acceleration (m/s^2)
%   v(t)    = speed (m/s)

clc; clear; close all;

%% =========================================================
% VEHICLE & FUEL MODEL PARAMETERS
% =========================================================
FC_idle = 0.0003;    % Base idle consumption (L/s) ~ 1.08 L/hr at idle
alpha   = 0.0010;    % Acceleration fuel penalty (L·s/m)
beta    = 8e-8;      % Aerodynamic drag coefficient (L·s/m²) scaled to speed²

%% =========================================================
% TASK 1: Model Vehicle Speed Over a Simplified Driving Cycle
% =========================================================
% Time step
dt = 1;   % 1 second resolution

% --- Define each phase ---
% Phase 1: Idle — 10 seconds at 0 km/h
t_idle  = (0:dt:10)';
v_idle  = zeros(size(t_idle));

% Phase 2: Accelerate — 0 to 80 km/h over 20 seconds
t_accel = (0:dt:20)';
v_accel = linspace(0, 80, length(t_accel))';

% Phase 3: Cruise — 80 km/h for 60 seconds
t_cruise = (0:dt:60)';
v_cruise  = 80 * ones(size(t_cruise));

% Phase 4: Decelerate — 80 to 30 km/h over 15 seconds
t_decel1 = (0:dt:15)';
v_decel1 = linspace(80, 30, length(t_decel1))';

% Phase 5: City speed — 30 km/h for 40 seconds
t_city  = (0:dt:40)';
v_city  = 30 * ones(size(t_city));

% Phase 6: Brake to stop — 30 to 0 km/h over 10 seconds
t_brake = (0:dt:10)';
v_brake = linspace(30, 0, length(t_brake))';

% --- Concatenate all phases (remove duplicate boundary points) ---
v_kmh = [v_idle; v_accel(2:end); v_cruise(2:end); ...
          v_decel1(2:end); v_city(2:end); v_brake(2:end)];

N   = length(v_kmh);
t   = (0:N-1)' * dt;            % global time vector (seconds)
v   = v_kmh / 3.6;              % convert km/h → m/s

% --- Phase boundary markers for plotting ---
phase_times = cumsum([10, 20, 60, 15, 40, 10]);
phase_labels = {'Idle','Accel','Cruise','Decel','City','Brake'};

%% =========================================================
% TASK 2: Relate Fuel Consumption Rate to Speed & Acceleration
% =========================================================
% Acceleration via finite differences (m/s²)
a      = zeros(N, 1);
a(2:N) = diff(v) / dt;          % forward difference
a(1)   = 0;

% Fuel Consumption Rate at each time step (L/s)
FCR = FC_idle + alpha .* abs(a) + beta .* v.^2;

%% =========================================================
% TASK 3: Compute Total Fuel Consumed Over the Cycle
% =========================================================
% Numerical integration using cumulative trapezoidal rule
fuel_cumulative = cumtrapz(t, FCR);             % cumulative fuel (L)
total_fuel      = fuel_cumulative(end);          % total fuel used (L)

% Distance travelled (m → km)
distance_m  = cumtrapz(t, v);
total_dist_km = distance_m(end) / 1000;

% Fuel economy (L/100 km)
if total_dist_km > 0
    fuel_economy = (total_fuel / total_dist_km) * 100;
else
    fuel_economy = NaN;
end

%% =========================================================
% FIGURE 1: Speed vs. Time with Phase Regions
% =========================================================
figure('Name', 'Vehicle Speed Profile', 'NumberTitle', 'off', ...
       'Position', [80, 80, 1000, 420]);

% Shade driving phases
phase_colors = [0.85 0.95 1.0;   % Idle     — light blue
                0.95 1.0  0.85;  % Accel    — light green
                1.0  0.95 0.80;  % Cruise   — light yellow
                1.0  0.88 0.85;  % Decel    — light red
                0.90 0.85 1.0;   % City     — light purple
                0.85 0.95 0.95]; % Brake    — light teal

phase_starts = [0, phase_times(1:end-1)];
for p = 1:6
    x_region = [phase_starts(p), phase_times(p), phase_times(p), phase_starts(p)];
    y_region  = [0, 0, 90, 90];
    fill(x_region, y_region, phase_colors(p,:), 'EdgeColor', 'none', 'FaceAlpha', 0.5);
    hold on;
end

plot(t, v_kmh, 'b-', 'LineWidth', 2.5);

% Phase labels
for p = 1:6
    mid_t = (phase_starts(p) + phase_times(p)) / 2;
    text(mid_t, 85, phase_labels{p}, 'HorizontalAlignment', 'center', ...
         'FontSize', 9, 'FontWeight', 'bold', 'Color', [0.2 0.2 0.2]);
end

% Phase boundary lines
for p = 1:length(phase_times)-1
    xline(phase_times(p), 'k--', 'LineWidth', 1.0, 'Alpha', 0.4);
end

xlabel('Time (s)', 'FontSize', 12);
ylabel('Speed (km/h)', 'FontSize', 12);
title('Vehicle Speed Profile — Simplified Driving Cycle', ...
      'FontSize', 14, 'FontWeight', 'bold');
ylim([0 92]);
xlim([0 t(end)]);
grid on;

%% =========================================================
% FIGURE 2: Acceleration vs. Time
% =========================================================
figure('Name', 'Acceleration Profile', 'NumberTitle', 'off', ...
       'Position', [100, 120, 1000, 350]);

area(t, a, 'FaceColor', [0.8 0.9 1.0], 'EdgeColor', 'b', 'LineWidth', 1.5);
yline(0, 'k-', 'LineWidth', 1.2);

xlabel('Time (s)', 'FontSize', 12);
ylabel('Acceleration (m/s²)', 'FontSize', 12);
title('Acceleration vs. Time', 'FontSize', 14, 'FontWeight', 'bold');
grid on; xlim([0 t(end)]);

%% =========================================================
% FIGURE 3: Fuel Consumption Rate vs. Time
% =========================================================
figure('Name', 'Fuel Consumption Rate', 'NumberTitle', 'off', ...
       'Position', [120, 160, 1000, 420]);

yyaxis left
plot(t, FCR * 1000, 'r-', 'LineWidth', 2, 'DisplayName', 'Fuel Rate (mL/s)');
ylabel('Fuel Consumption Rate (mL/s)', 'FontSize', 12);

yyaxis right
plot(t, v_kmh, 'b--', 'LineWidth', 1.5, 'DisplayName', 'Speed (km/h)');
ylabel('Speed (km/h)', 'FontSize', 12);

xlabel('Time (s)', 'FontSize', 12);
title('Fuel Consumption Rate vs. Time', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'northeast', 'FontSize', 10);
grid on; xlim([0 t(end)]);

%% =========================================================
% FIGURE 4: Cumulative Fuel Consumed vs. Time
% =========================================================
figure('Name', 'Cumulative Fuel Consumed', 'NumberTitle', 'off', ...
       'Position', [140, 200, 1000, 420]);

plot(t, fuel_cumulative * 1000, 'm-', 'LineWidth', 2.5, ...
     'DisplayName', 'Cumulative Fuel (mL)');
hold on;
plot(t(end), total_fuel * 1000, 'ko', 'MarkerSize', 10, ...
     'MarkerFaceColor', 'k', ...
     'DisplayName', sprintf('Total = %.2f mL (%.4f L)', ...
     total_fuel*1000, total_fuel));
hold off;

xlabel('Time (s)', 'FontSize', 12);
ylabel('Cumulative Fuel Consumed (mL)', 'FontSize', 12);
title('Cumulative Fuel Consumption Over Driving Cycle', ...
      'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'northwest', 'FontSize', 11);
grid on; xlim([0 t(end)]);

%% =========================================================
% FIGURE 5: Fuel Consumption Breakdown by Phase (Bar Chart)
% =========================================================
phase_end_idx   = round(phase_times / dt);
phase_start_idx = [1, phase_end_idx(1:end-1) + 1];

fuel_per_phase = zeros(1, 6);
dist_per_phase = zeros(1, 6);

for p = 1:6
    idx = phase_start_idx(p):min(phase_end_idx(p), N);
    fuel_per_phase(p) = trapz(t(idx), FCR(idx)) * 1000;   % mL
    dist_per_phase(p) = trapz(t(idx), v(idx)) / 1000;     % km
end

figure('Name', 'Fuel Breakdown by Phase', 'NumberTitle', 'off', ...
       'Position', [160, 240, 700, 420]);

bar_colors = [0.3 0.6 0.9;  0.2 0.8 0.4;  1.0 0.8 0.2;
              0.9 0.4 0.3;  0.7 0.4 0.9;  0.3 0.8 0.8];
b = bar(fuel_per_phase, 'FaceColor', 'flat');
b.CData = bar_colors;

set(gca, 'XTickLabel', phase_labels, 'FontSize', 11);
xlabel('Driving Phase', 'FontSize', 12);
ylabel('Fuel Consumed (mL)', 'FontSize', 12);
title('Fuel Consumption Breakdown by Driving Phase', ...
      'FontSize', 14, 'FontWeight', 'bold');
grid on; grid minor;

% Add value labels on bars
for p = 1:6
    text(p, fuel_per_phase(p) + 0.02, sprintf('%.2f mL', fuel_per_phase(p)), ...
         'HorizontalAlignment', 'center', 'FontSize', 9, 'FontWeight', 'bold');
end

%% =========================================================
% CONSOLE OUTPUT — Full Summary Report
% =========================================================
fprintf('============================================================\n');
fprintf('  Project 19: Vehicle Fuel Consumption Summary\n');
fprintf('============================================================\n\n');

fprintf('--- Vehicle Fuel Model ---\n');
fprintf('  FCR(t) = FC_idle + alpha*|a(t)| + beta*v(t)^2\n');
fprintf('  FC_idle = %.4f L/s  (%.4f L/hr idle)\n', FC_idle, FC_idle*3600);
fprintf('  alpha   = %.4f  (acceleration penalty)\n', alpha);
fprintf('  beta    = %.2e  (aerodynamic drag term)\n\n', beta);

fprintf('--- Driving Cycle Overview ---\n');
fprintf('  Total Duration  : %d seconds (%.1f minutes)\n', t(end), t(end)/60);
fprintf('  Total Distance  : %.3f km\n', total_dist_km);
fprintf('  Total Fuel Used : %.4f L (%.2f mL)\n', total_fuel, total_fuel*1000);
fprintf('  Fuel Economy    : %.2f L/100 km\n\n', fuel_economy);

fprintf('--- Phase-by-Phase Breakdown ---\n');
fprintf('%-12s  %8s  %10s  %10s  %12s\n', ...
        'Phase', 'Duration', 'Distance', 'Fuel(mL)', 'Fuel/km(mL)');
fprintf('%s\n', repmat('-', 1, 60));

phase_durations = [10, 20, 60, 15, 40, 10];
for p = 1:6
    if dist_per_phase(p) > 0
        eff = fuel_per_phase(p) / dist_per_phase(p);
    else
        eff = NaN;
    end
    fprintf('%-12s  %6d s  %8.4f km  %8.3f mL  %10.2f mL/km\n', ...
            phase_labels{p}, phase_durations(p), dist_per_phase(p), ...
            fuel_per_phase(p), eff);
end

fprintf('\n--- Fuel Efficiency Insight ---\n');
[~, worst] = max(fuel_per_phase);
[~, best]  = min(fuel_per_phase);
fprintf('  Most fuel-hungry phase : %s (%.3f mL)\n', phase_labels{worst}, fuel_per_phase(worst));
fprintf('  Least fuel-hungry phase: %s (%.3f mL)\n', phase_labels{best},  fuel_per_phase(best));
fprintf('\n  Interpretation:\n');
fprintf('  - Acceleration phase burns most fuel per unit time due to high |a|\n');
fprintf('  - Cruise burns fuel steadily via aerodynamic drag (v^2 term)\n');
fprintf('  - Idle consumes base fuel rate even at zero speed\n');
fprintf('  - Braking wastes kinetic energy as heat, contributing minimal fuel\n');
fprintf('============================================================\n');
```

---

**What each section delivers:**

| Figure | Content |
|---|---|
| Figure 1 | Speed vs. time with color-shaded phase regions and labels |
| Figure 2 | Acceleration profile — shows where fuel penalty spikes occur |
| Figure 3 | Dual-axis: fuel rate (mL/s) overlaid with speed (km/h) |
| Figure 4 | Cumulative fuel consumed — total marked at the end |
| Figure 5 | Bar chart of fuel used per driving phase |

**Fuel model used:**
```
FCR(t) = FC_idle + α·|a(t)| + β·v(t)²