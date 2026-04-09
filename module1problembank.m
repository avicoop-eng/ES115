% =========================================================
% PROJECT 1: Community Solar Billing Simulator
% =========================================================
% A community solar program offers two billing plans:
%
% Plan A: BA(x) = 15x + 25  (linear, for all x)
%
% Plan B: BB(x) = 12x + 40,            if x <= 400 kWh
%                 14x + (40 - 2*400),  if x >  400 kWh
%
% where x = energy usage in kWh
%
% TASKS:
% 1. Implement both billing models for x = 0:25:800
% 2. Plot both plans on the same figure, show break at 400 kWh
% 3. Find where Plan A and Plan B have the same cost
% 4. Create a table of usage values and bills (at least 10 rows)
% 5. Recommendation: when should a customer choose Plan A vs B?
% =========================================================

%% --- TASK 1: Implement both billing models ---

x = 0:25:800;           % energy usage in kWh

% Plan A: simple linear
BA = 15*x + 25;

% Plan B: piecewise
BB = zeros(size(x));    % preallocate
for i = 1:length(x)
    if x(i) <= 400
        BB(i) = 12*x(i) + 40;
    else
        BB(i) = 14*x(i) + (40 - 2*400);
    end
end

% NOTE: You can also use logical indexing instead of a loop:
% BB(x <= 400) = 12*x(x <= 400) + 40;
% BB(x >  400) = 14*x(x >  400) + (40 - 2*400);


%% --- TASK 2: Plot both plans on same figure ---

figure;
plot(x, BA, 'b-',  'LineWidth', 2, 'DisplayName', 'Plan A: 15x + 25');
hold on;
plot(x, BB, 'r--', 'LineWidth', 2, 'DisplayName', 'Plan B: Piecewise');

% Mark the break point at x = 400
xline(400, 'k:', 'LineWidth', 1.5, 'DisplayName', 'Break at 400 kWh');

title('Community Solar Billing Plans');
xlabel('Energy Usage (kWh)');
ylabel('Monthly Bill ($)');
legend('Location', 'northwest');
grid on;

% NOTE: hold on lets you plot multiple lines on the same figure.
% xline draws a vertical line at a specified x value.
% DisplayName sets the label shown in the legend.


%% --- TASK 3: Find where Plan A = Plan B ---

% For x <= 400: set BA = BB
% 15x + 25 = 12x + 40
% 3x = 15 -> x = 5 kWh

% For x > 400: set BA = BB
% 15x + 25 = 14x + (40 - 800)
% 15x + 25 = 14x - 760
% x = -785  -> not valid (negative usage)

% So only one valid crossover point: x = 5 kWh
crossover = (40 - 25) / (15 - 12);
fprintf('--- TASK 3: Crossover Point ---\n');
fprintf('Plan A = Plan B at x = %.2f kWh\n', crossover);
fprintf('Bill at crossover = $%.2f\n\n', 15*crossover + 25);

% Mark crossover on plot
plot(crossover, 15*crossover + 25, 'ko', ...
     'MarkerSize', 10, 'DisplayName', 'Crossover Point');

% NOTE: Solve analytically by setting equations equal and solving for x.
% Only check each region of the piecewise function separately.


%% --- TASK 4: Table of usage values and bills ---

fprintf('--- TASK 4: Billing Table ---\n');
fprintf('%-15s %-15s %-15s\n', 'Usage (kWh)', 'Plan A ($)', 'Plan B ($)');
fprintf('%s\n', repmat('-', 1, 45));

% Select at least 10 representative values
x_table = 0:100:800;    % 9 values — add a few extras
x_table = [0, 50, 100, 200, 300, 400, 500, 600, 700, 800];

for i = 1:length(x_table)
    xi  = x_table(i);
    bai = 15*xi + 25;

    if xi <= 400
        bbi = 12*xi + 40;
    else
        bbi = 14*xi + (40 - 2*400);
    end

    fprintf('%-15d %-15.2f %-15.2f\n', xi, bai, bbi);
end
fprintf('\n');

% NOTE: fprintf with %-15s left-aligns text in a 15-character wide column.
% repmat('-', 1, 45) creates a string of 45 dashes for the divider line.


%% --- TASK 5: Recommendation ---

fprintf('--- TASK 5: Recommendation ---\n');
fprintf('At x = %.0f kWh (crossover), both plans cost the same.\n', crossover);
fprintf('For usage below %.0f kWh: Plan B is cheaper (lower slope).\n', crossover);
fprintf('For usage above %.0f kWh: Plan A is cheaper up to 400 kWh.\n', crossover);
fprintf('Above 400 kWh: Plan B slope increases to 14, making Plan A cheaper.\n');
fprintf('\nRecommendation:\n');
fprintf('  - Low usage (x < 5 kWh):    Choose Plan B\n');
fprintf('  - Mid usage (5-400 kWh):    Choose Plan A\n');
fprintf('  - High usage (x > 400 kWh): Choose Plan A (Plan B gets expensive)\n\n');


%% --- REFLECTION NOTES (in comments) ---

% Q: What do slope and intercept represent for each plan?
%    - Slope = cost per kWh (rate). Plan A charges $15/kWh, Plan B charges
%      $12/kWh (under 400) or $14/kWh (over 400).
%    - Intercept = base/fixed monthly charge regardless of usage.
%      Plan A has a $25 base fee, Plan B has a $40 base fee.

% Q: How does the piecewise structure change decision-making?
%    - Plan B appears cheaper per kWh under 400, but the higher base fee
%      ($40 vs $25) and the rate jump to $14/kWh above 400 kWh makes it
%      more expensive for most moderate-to-high usage customers.
%    - The piecewise structure means you cannot use a single comparison —
%      you must evaluate each region separately to find crossover points.