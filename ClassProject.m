%% PROBLEM 3.5:
% An air conditioner must remove heat from:
%   - 20 light bulbs emitting 100 J/s each
%   - 4 appliances emitting 500 J/s each
%   - Heat leaking in from outside at 3000 J/s
% a. How much heat must AC remove per second?
% b. If one AC unit handles 2000 J/s, how many units are needed?

n_bulbs    = 20;
power_bulb = 100;    % J/s
n_appl     = 4;
power_appl = 500;    % J/s
heat_leak  = 3000;   % J/s

% a. Total heat
total_heat = (n_bulbs * power_bulb) + (n_appl * power_appl) + heat_leak;
fprintf('Total heat to remove: %d J/s\n', total_heat);

% b. Number of AC units
ac_capacity = 2000;
n_units     = ceil(total_heat / ac_capacity);
fprintf('AC units needed: %d\n', n_units);

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

%% PROBLEM 8.2:
% Height of a rocket: height = 2.13t^2 - 0.0013t^4 + 0.000034t^4.751
% Create time vector from 0 to 100 at 2-second intervals
% a. Use find to determine when rocket hits ground (within 2 seconds)
% b. Use max to find maximum height and corresponding time
% c. Plot t vs height until rocket hits ground, with title and axis labels

t = 0:2:100;
height = 2.13*t.^2 - 0.0013*t.^4 + 0.000034*t.^4.751;

% a. Find when rocket hits ground
idx = find(height < 0, 1);
landing_time = t(idx);
fprintf('Rocket hits ground near t = %g seconds\n', landing_time);

% b. Maximum height
[max_height, max_idx] = max(height);
max_time = t(max_idx);
fprintf('Max height = %.2f m at t = %g s\n', max_height, max_time);

% c. Plot until rocket hits ground
t_flight = t(1:idx-1);
h_flight = height(1:idx-1);

figure;
plot(t_flight, h_flight);
title('Rocket Height vs Time');
xlabel('Time (s)');
ylabel('Height (m)');
grid on;

%% PROBLEM 9.14:
% cos(x) can be approximated by Maclaurin series:
% cos(x) = sum from k=1 to inf of (-1)^(k-1) * x^((k-1)*2) / ((k-1)*2)!
% Use a midpoint break loop to find how many terms needed
% to approximate cos(2) within 1e-4 error.
% Limit iterations to maximum of 10.

x         = 2;
true_val  = cos(x);
tolerance = 1e-4;
max_iter  = 10;
approx    = 0;
k         = 1;

while k <= max_iter
    term   = (-1)^(k-1) * x^((k-1)*2) / factorial((k-1)*2);
    approx = approx + term;
    err    = abs(true_val - approx);
    fprintf('k=%d | approx=%.6f | error=%.2e\n', k, approx, err);

    if err < tolerance      % midpoint break
        break;
    end
    k = k + 1;
end

fprintf('\nTerms needed: %d\n', k);
fprintf('Approximation: %.6f\n', approx);
fprintf('True cos(2):   %.6f\n', true_val);

%% ROBLEM 10.22:
% Statically determinate truss with applied force of 1000 lbf at 30 degrees.
% Inner angles theta1 = 45 degrees, theta2 = 65 degrees.
% Determine forces in each member and reactive forces at hinge and roller.
% Solve using matrix equation AX = B

F   = 1000;
a_F = deg2rad(30);
t1  = deg2rad(45);
t2  = deg2rad(65);

% External force components at node 1
Fx = -F * cos(a_F);
Fy = -F * sin(a_F);

% Equilibrium equations: [A]*[F1;F2;F3] = [B]
A = [-cos(t1),  cos(t2),  0;
      sin(t1),  sin(t2),  0;
      cos(t1),  0,       -1];

B = [Fx; Fy; 0];

X = A \ B;
fprintf('F1 (member 1) = %.2f lbf\n', X(1));
fprintf('F2 (member 2) = %.2f lbf\n', X(2));
fprintf('F3 (member 3) = %.2f lbf\n', X(3));

%% PROBLEM 10.23:
% Create a MATLAB function called my_matrix_solver that solves AX = B
% using nested for loops instead of built-in operators.
% Function accepts coefficient matrix A and result matrix B,
% and returns the variable vector X.
% Test with system from previous problem.

% ---- Save the following as my_matrix_solver.m ----
function X = my_matrix_solver(A, B)
    n   = length(B);
    Aug = [A, B];

    % Forward elimination
    for col = 1:n
        for row = col+1:n
            factor = Aug(row,col) / Aug(col,col);
            for k = col:n+1
                Aug(row,k) = Aug(row,k) - factor * Aug(col,k);
            end
        end
    end

    % Back substitution
    X = zeros(n,1);
    for i = n:-1:1
        X(i) = Aug(i, n+1);
        for j = i+1:n
            X(i) = X(i) - Aug(i,j) * X(j);
        end
        X(i) = X(i) / Aug(i,i);
    end
end
% --------------------------------------------------

% Test script (run separately after saving function above):
A_test = [-cos(deg2rad(45)),  cos(deg2rad(65)),  0;
           sin(deg2rad(45)),  sin(deg2rad(65)),  0;
           cos(deg2rad(45)),  0,                -1];
B_test = [-1000*cos(deg2rad(30)); -1000*sin(deg2rad(30)); 0];
X_test = my_matrix_solver(A_test, B_test);
disp('Solution X:'); disp(X_test);

%% PROBLEM 12.12:
% Pendulum frequency equation: f = (1/2pi) * sqrt(mgL / I)
% where f = frequency, m = mass, g = gravity,
%       L = distance from pivot to center of gravity, I = inertia
% Use MATLAB symbolic capability to solve for length L.

syms f m g L I

% Define frequency equation
eqn = f == (1/(2*pi)) * sqrt(m*g*L / I);

% Solve symbolically for L
L_solution = solve(eqn, L);
fprintf('L = ');
disp(L_solution);

% Simplify
L_simplified = simplify(L_solution);
fprintf('Simplified L = ');
disp(L_simplified);

%% PROBLEM 13.10:
% Chemical reaction rate k = k0 * e^(-Q/RT)
% R = 8.314 kJ/kmol·K, Q = activation energy, T = temperature (K)
% Given data: T = [200,400,600,800,1000] K
%             k = [1.46e-7, 0.0012, 0.0244, 0.1099, 0.2710] s^-1
% a. Plot 1/T on x-axis and ln(k) on y-axis
% b. Use polyfit to find slope (-Q/R) and intercept ln(k0)
% c. Calculate Q
% d. Calculate k0

T = [200, 400, 600, 800, 1000];
k = [1.46e-7, 0.0012, 0.0244, 0.1099, 0.2710];
R = 8.314;

x = 1./T;
y = log(k);

% a. Plot
figure;
plot(x, y, 'o-');
xlabel('1/T  (K^{-1})');
ylabel('ln(k)');
title('Arrhenius Plot');
grid on;

% b. Linear fit
coeffs    = polyfit(x, y, 1);
slope     = coeffs(1);      % = -Q/R
intercept = coeffs(2);      % = ln(k0)
fprintf('Slope    (-Q/R)  = %.4f\n', slope);
fprintf('Intercept ln(k0) = %.4f\n', intercept);

% c. Activation energy Q
Q = -slope * R;
fprintf('Q = %.2f kJ/kmol\n', Q);

% d. Pre-exponential factor k0
k0 = exp(intercept);
fprintf('k0 = %.4e s^-1\n', k0);

%% PROBLEM 14.5:
% Plot y = sin(x) for x from -2pi to +2pi.
% Assign plot an object handle and use dot notation to change:
%   a. Line color to green
%   b. Line style to dashed
%   c. Line width to 2
%
% PROBLEM 14.6:
% Using the figure handle from 14.5, change:
%   a. Figure background color to red
%   b. Figure name to "A Sine Function"
%
% PROBLEM 14.7:
% Using the axes handle from 14.5, change:
%   a. Background color to blue
%   b. x-axis scale to log

x = -2*pi : 0.01 : 2*pi;
y = sin(x);

% 14.5
fig = figure;
h   = plot(x, y);

h.Color     = 'green';   % a.
h.LineStyle = '--';      % b.
h.LineWidth = 2;         % c.

% 14.6
fig.Color = 'red';             % a.
fig.Name  = 'A Sine Function'; % b.

% 14.7
ax        = gca;
ax.Color  = 'blue';   % a.
ax.XScale = 'log';    % b.