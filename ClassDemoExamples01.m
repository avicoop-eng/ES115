%% ES115 Class Demo Examples - All Solutions
% Complete MATLAB code for all 5 class demos

%% =========================================================
%  CLASS DEMO 1.0 - Control Panel (Basic Version)
% =========================================================
%{
ES115-Control Panel Class-Project
Author: Fname Lname
Version: 1.0
Date: 2026-02-15
Purpose:
    Control Panel to display name, date and age in years or days.
Input:
    - number indicating which button was pressed
Output:
    - Name stacked above date in panel title
    - Display age in years to two decimal places
    - Display age in days to one decimal place
Engineering Algorithms:
    - Clear the screen and delete all variables
    - Package the panel title information as a matrix of strings
    - Wrap menu and switch/case in a forever while loop
    - When button one is pressed display age in years
    - When button two is pressed display age in days
    - When button three is pressed exit while loop and end program
MATLAB tools/functions:
    - While loop, menu, datetime, fprintf, switch/case.
%}

clear, clc
PanelActive = true;
MyBirthday = datetime(2000, 6, 1);  % Set your birthday here
Rtitle = ["My name is FName LName"; string(datetime('now', 'Format', 'eeee MMMM d yyyy'))];

while PanelActive == true
    clc
    choice = menu(Rtitle, 'Age in years', 'Age in days', 'Exit');
    switch choice
        case 1
            x = years(datetime('now') - MyBirthday);
            fprintf('I was born %0.2f years ago\n', x)
        case 2
            x = days(datetime('now') - MyBirthday);
            fprintf('I was born %0.1f days ago\n', x)
        case 3
            break
    end
end


%% =========================================================
%  CLASS DEMO 2.0 - Control Panel with User Input
% =========================================================
%{
ES115-Control Panel Class-Project
Author: Fname Lname
Version: 2.0
Date: 2026-02-22
Purpose:
    Control Panel to display name, date and age in years or days.
    Prompts the user for a birthday then calculates age.
    Includes input parsing and helper function to validate user input.
Input:
    - number indicating which button was pressed
Output:
    - Name stacked above date in panel title
    - Display age in years to two decimal places
    - Display age in days to one decimal place
Engineering Algorithms:
    - Clear the screen and delete all variables
    - Package the panel title information as a matrix of strings
    - Wrap menu and switch/case in a forever while loop
    - When button one is pressed display age in years
    - When button two is pressed display age in days
    - When button three is pressed exit while loop and end program
MATLAB tools/functions:
    - While loop, menu, datetime, fprintf, switch/case,
    - User function with return value but no argument.
%}

clear, clc
PanelActive = true;
Rtitle = ["My name is FName LName"; string(datetime('now', 'Format', 'eeee MMMM d yyyy'))];

while PanelActive == true
    clc
    choice = menu(Rtitle, 'Age in years', 'Age in days', 'Exit');
    switch choice
        case 1
            x = years(datetime('now') - GetBirthday());
            fprintf('I was born %0.2f years ago\n', x)
        case 2
            x = days(datetime('now') - GetBirthday());
            fprintf('I was born %0.1f days ago\n', x)
        case 3
            break
    end
end

% --- Helper Function: GetBirthday ---
%{
GetBirthday function
Author: Fname Lname
Version: 2.0
Date: 2026-02-22
Purpose:
    Prompts the user for a birthday and validates user input.
Input:
    - N/A: Function is not expecting arguments.
Output:
    - Validated user birthdate or today's date
Engineering Algorithms:
    - Clear the screen
    - Prompt user for birthdate
    - Validate birthdate from user or use current default date
MATLAB tools/functions:
    - inputdlg, try/catch, User function with return value but no argument
%}
function MyBirthday = GetBirthday()
    clc
    % Prompt user for their birth date using inputdlg
    prompt = {'Enter your birthday (yyyy-mm-dd):'};
    promptTitle = 'Birthday Input';
    promptFieldsize = [1 35];
    promptDefault_input = {char(datetime('today', 'Format', 'yyyy-MM-dd'))};
    answer = inputdlg(prompt, promptTitle, promptFieldsize, promptDefault_input);

    % Validate and convert input to datetime
    try
        MyBirthday = datetime(answer{1}, 'InputFormat', 'yyyy-MM-dd');
    catch
        warning('Invalid date entered. Assigning current date.');
        MyBirthday = datetime('today');  % Assign current date if input is invalid
    end
end


%% =========================================================
%  CLASS DEMO 3.0 - Free Vibration of a Damped Mass-Spring System
% =========================================================

clc
% Free vibration of a damped mass-spring system
m = 1;      % mass (kg)
k = 20;     % spring stiffness (N/m)
c = 2;      % damping coefficient (Ns/m)

% Time span
tspan = [0 10];

% Initial conditions [displacement; velocity]
x0 = [1; 0];

% Define ODE as system of first-order equations:
%   x(1) = displacement,  x(2) = velocity
%   dx1/dt = x2
%   dx2/dt = -(c/m)*x2 - (k/m)*x1
f = @(t, x) [x(2);
             -(c/m)*x(2) - (k/m)*x(1)];

% Solve ODE using ode45
[t, x] = ode45(f, tspan, x0);

% Plot displacement
figure
plot(t, x(:,1), 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Displacement (m)')
title('Free Vibration with Damping')
grid on


%% =========================================================
%  CLASS DEMO 4.0 - Differential Equation Example
% =========================================================

% Solve dy/dt = -2y with y(0) = 3
% Define ODE as function handle: dy/dt = -2*y
f = @(t, y) -2*y;

% Time span for integration
tspan = [0 5];

% Initial condition y(0) = 3
y0 = 3;

% Numerically solve ODE using ode45 (non-stiff explicit RK)
[t, y] = ode45(f, tspan, y0);

% Plot numeric solution
figure
plot(t, y, 'b-', 'LineWidth', 2)
grid on
xlabel('Time t')
ylabel('Solution y(t)')
title('Solution of dy/dt = -2y with y(0) = 3')


%% =========================================================
%  CLASS DEMO 5.0 - Kirchhoff's Laws / Linear Systems
% =========================================================
% Use Kirchhoff's current loop method to find loop currents Ia, Ib, Ic
%
% Loop equations:
%   Ia: 9V  - 6k(Ia) - 2k(Ia) + 2k(Ib) - 10k(Ia)  => 18Ia -  2Ib +  0Ic = 9
%   Ib: 1.5V + 2k(Ia) - 2k(Ib) - 1k(Ib) - 8k(Ib) + 8k(Ic) => -2Ia + 11Ib - 8Ic = 1.5
%   Ic: 3V  + 8k(Ib) - 8k(Ic) - 9k(Ic) - 5k(Ic)   =>  0Ia -  8Ib + 22Ic = 3

clc
syms I1 I2 I3          % Create symbolic variables

% Voltage vector
V = [9; 1.5; 3];

% Resistance coefficient matrix (kOhms)
R = [18  -2   0;
     -2  11  -8;
      0  -8  22];

% --- Method 1: Using MATLAB inv() function ---
I_inv = inv(R) * V
fprintf('Method 1 (inv):  Ia = %.4f, Ib = %.4f, Ic = %.4f mA\n', I_inv(1), I_inv(2), I_inv(3))

% --- Method 2: Using matrix exponent R^-1 ---
I_exp = R^-1 * V
fprintf('Method 2 (R^-1): Ia = %.4f, Ib = %.4f, Ic = %.4f mA\n', I_exp(1), I_exp(2), I_exp(3))

% --- Method 3: Matrix Left Division (Gauss elimination) --- PREFERRED
I_ldiv = R \ V
fprintf('Method 3 (R\\V):  Ia = %.4f, Ib = %.4f, Ic = %.4f mA\n', I_ldiv(1), I_ldiv(2), I_ldiv(3))

% --- Method 4: Reduced Row Echelon Form ---
I_rref = rref([R, V])
fprintf('Method 4 (rref): Ia = %.4f, Ib = %.4f, Ic = %.4f mA\n', I_rref(1,4), I_rref(2,4), I_rref(3,4))

% --- Compute voltage difference between nodes C and F ---
% Vcf = Vc - Vf = (Ib - Ic) * 8 kOhm
Vcf = 8 * (I_ldiv(2) - I_ldiv(3));
fprintf('\nVoltage Vcf = %.4f V\n', Vcf)
