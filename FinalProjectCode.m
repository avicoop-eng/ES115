%% =========================================================
%  Aerospace Altitude & Speed Profile Analyzer
%  ES115 – Engineering Computer Applications
%  Project 4 – Avi Cooperman, Jack O'charek
%  Date: April 2026
%% =========================================================

clc; clear; close all;

%% --- 1. GENERATE SYNTHETIC FLIGHT DATA ---
dt = 1;                     % time step (seconds)
t  = (0:dt:7200)';          % total flight: 2 hours = 7200 s

% --- Altitude profile (feet) ---
alt = zeros(size(t));
for i = 1:length(t)
    ti = t(i);
    if ti < 300                         % Takeoff: 0–5 min
        alt(i) = 0 + (35000/300)*ti;
    elseif ti < 600                     % Climb continues: 5–10 min
        alt(i) = 35000 + (3000/300)*(ti-300);
    elseif ti < 6600                    % Cruise: 10 min – 1 hr 50 min
        alt(i) = 38000 + 200*sin(2*pi*ti/3000);   % gentle wave
    elseif ti < 7050                    % Descent: 1 hr 50 min – end
        alt(i) = 38000 - (38000/450)*(ti-6600);
    else
        alt(i) = 0;                     % landed
    end
end

% --- Speed profile (knots) ---
spd = zeros(size(t));
for i = 1:length(t)
    ti = t(i);
    if ti < 120                         % Takeoff acceleration
        spd(i) = (160/120)*ti;
    elseif ti < 300                     % Climb acceleration
        spd(i) = 160 + (320/180)*(ti-120);
    elseif ti < 600                     % Reach cruise speed
        spd(i) = 480 + (10/300)*(ti-300);
    elseif ti < 6600                    % Cruise
        spd(i) = 490 + 5*sin(2*pi*ti/600);
    elseif ti < 7050                    % Deceleration during descent
        spd(i) = 490 - (340/450)*(ti-6600);
    else
        spd(i) = 150;                   % approach/landing speed
    end
end

% Add mild random noise
rng(42);
alt = alt + 80*randn(size(alt));
spd = spd + 3*randn(size(spd));
alt = max(alt, 0);
spd = max(spd, 0);

%% --- 2. PHASE IDENTIFICATION ---
% Thresholds
ALT_CRUISE  = 30000;   % ft – above this = cruise eligible
SPD_TAKEOFF = 80;      % kts – above this = airborne
ALT_LANDED  = 500;     % ft – below this = on ground
DALT_CLIMB  = 5;       % ft/s – positive = climbing
DALT_DESC   = -5;      % ft/s – negative = descending

% Compute rate-of-climb (ft/s)
dalt = [0; diff(alt)/dt];
% Smooth it
dalt_sm = movmean(dalt, 30);

phase = zeros(size(t));   % 0=ground, 1=takeoff, 2=climb, 3=cruise, 4=descent

for i = 1:length(t)
    if alt(i) < ALT_LANDED && spd(i) < SPD_TAKEOFF
        phase(i) = 0;                  % Ground / landed
    elseif alt(i) < ALT_LANDED && spd(i) >= SPD_TAKEOFF
        phase(i) = 1;                  % Takeoff
    elseif alt(i) >= ALT_LANDED && alt(i) < ALT_CRUISE
        if dalt_sm(i) > DALT_CLIMB
            phase(i) = 2;              % Climb
        else
            phase(i) = 4;              % Descent
        end
    elseif alt(i) >= ALT_CRUISE
        if dalt_sm(i) < DALT_DESC
            phase(i) = 4;              % Descent from cruise
        else
            phase(i) = 3;              % Cruise
        end
    end
end

phase_names = {'Ground','Takeoff','Climb','Cruise','Descent'};
colors      = [0.6 0.6 0.6;   % gray  – ground
               0.2 0.7 0.3;   % green – takeoff
               0.2 0.4 0.9;   % blue  – climb
               0.9 0.5 0.1;   % orange – cruise
               0.85 0.2 0.2]; % red   – descent

%% --- 3. COMPUTE KEY METRICS ---
% Max climb rate
climb_idx  = (phase == 2);
if any(climb_idx)
    max_climb = max(dalt_sm(climb_idx)) * 60;  % ft/min
else
    max_climb = 0;
end

% Average cruise speed
cruise_idx = (phase == 3);
if any(cruise_idx)
    avg_cruise_spd = mean(spd(cruise_idx));
else
    avg_cruise_spd = 0;
end

% Descent duration
desc_idx = (phase == 4);
desc_duration_min = sum(desc_idx) * dt / 60;   % minutes

% Cruise altitude stats
if any(cruise_idx)
    avg_cruise_alt = mean(alt(cruise_idx));
    max_alt        = max(alt);
else
    avg_cruise_alt = 0;
    max_alt = max(alt);
end

fprintf('=== FLIGHT METRICS ===\n');
fprintf('Max Climb Rate:       %.0f ft/min\n', max_climb);
fprintf('Average Cruise Speed: %.1f knots\n',  avg_cruise_spd);
fprintf('Average Cruise Alt:   %.0f ft\n',     avg_cruise_alt);
fprintf('Maximum Altitude:     %.0f ft\n',     max_alt);
fprintf('Descent Duration:     %.1f min\n',    desc_duration_min);

%% --- 4. VISUALIZATIONS ---
t_min = t/60;   % convert seconds to minutes for plotting

% ---- Figure 1: Altitude vs Time (phase-colored) ----
figure('Name','Altitude vs Time','Position',[100 100 900 400]);
hold on
for p = 0:4
    idx = (phase == p);
    if any(idx)
        scatter(t_min(idx), alt(idx), 3, colors(p+1,:), 'filled');
    end
end
xlabel('Time (min)','FontSize',12);
ylabel('Altitude (ft)','FontSize',12);
title('Altitude vs. Time – Phase Colored','FontSize',14,'FontWeight','bold');
legend(phase_names,'Location','northeast','FontSize',10);
grid on; box on;
yline(ALT_CRUISE,'--k','LineWidth',1.2,'Label','Cruise Threshold');
hold off
saveas(gcf,'plot_altitude_vs_time.png');

% ---- Figure 2: Speed vs Time (phase-colored) ----
figure('Name','Speed vs Time','Position',[100 560 900 400]);
hold on
for p = 0:4
    idx = (phase == p);
    if any(idx)
        scatter(t_min(idx), spd(idx), 3, colors(p+1,:), 'filled');
    end
end
xlabel('Time (min)','FontSize',12);
ylabel('Speed (knots)','FontSize',12);
title('Speed vs. Time – Phase Colored','FontSize',14,'FontWeight','bold');
legend(phase_names,'Location','northeast','FontSize',10);
grid on; box on;
hold off
saveas(gcf,'plot_speed_vs_time.png');

% ---- Figure 3: Combined dual-axis ----
figure('Name','Combined Profile','Position',[100 100 1000 450]);
yyaxis left
plot(t_min, alt, 'b-', 'LineWidth',1.2);
ylabel('Altitude (ft)','FontSize',12,'Color','b');
yyaxis right
plot(t_min, spd, 'r-', 'LineWidth',1.2);
ylabel('Speed (knots)','FontSize',12,'Color','r');
xlabel('Time (min)','FontSize',12);
title('Combined Altitude & Speed Profile','FontSize',14,'FontWeight','bold');
legend({'Altitude','Speed'},'Location','southeast');
grid on;
saveas(gcf,'plot_combined_profile.png');

% ---- Figure 4: Histogram of speeds by phase ----
figure('Name','Speed Histogram','Position',[100 100 900 450]);
hold on
for p = 1:4
    idx = (phase == p);
    if any(idx)
        histogram(spd(idx), 30, 'FaceColor', colors(p+1,:), ...
                  'FaceAlpha', 0.6, 'EdgeColor','none');
    end
end
xlabel('Speed (knots)','FontSize',12);
ylabel('Count','FontSize',12);
title('Speed Distribution by Flight Phase','FontSize',14,'FontWeight','bold');
legend(phase_names(2:5),'Location','northwest','FontSize',10);
grid on; box on;
hold off
saveas(gcf,'plot_speed_histogram.png');

fprintf('\nAll plots saved as PNG files.\n');
