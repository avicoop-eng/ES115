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