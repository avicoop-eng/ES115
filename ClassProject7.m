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