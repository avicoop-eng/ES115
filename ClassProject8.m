
%% PROBLEM 3.15:
% Reactor temperature readings from 3 thermocouples (13 rows of data).
% Data is in thermocouple.dat (or entered manually below).
% a. Find the maximum temperature measured by each thermocouple.
% b. Find the minimum temperature measured by each thermocouple.

% Enter data manually (or load from file with: data = load('thermocouple.dat'))
data = [84.3, 90.0, 86.7;
        86.4, 89.5, 87.6;
        85.2, 88.6, 88.3;
        87.1, 88.9, 85.3;
        83.5, 88.9, 80.3;
        84.8, 90.4, 82.4;
        85.0, 89.3, 83.4;
        85.3, 89.5, 85.4;
        85.3, 88.9, 86.3;
        85.2, 89.1, 85.3;
        82.3, 89.5, 89.0;
        84.7, 89.4, 87.3;
        83.6, 89.8, 87.2];

% a. Maximum temperature per thermocouple
max_temps = max(data);
fprintf('Max Temperatures:\n');
fprintf('  Thermocouple 1: %.1f\n', max_temps(1));
fprintf('  Thermocouple 2: %.1f\n', max_temps(2));
fprintf('  Thermocouple 3: %.1f\n', max_temps(3));

% b. Minimum temperature per thermocouple
min_temps = min(data);
fprintf('Min Temperatures:\n');
fprintf('  Thermocouple 1: %.1f\n', min_temps(1));
fprintf('  Thermocouple 2: %.1f\n', min_temps(2));
fprintf('  Thermocouple 3: %.1f\n', min_temps(3));
