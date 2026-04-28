%{
Age Calculator
Author: Your Name
Version: 1.0
Date: 2026-03-31
Purpose:
    Control Panel that prompts the user for their birthdate and
    calculates their age in either minutes or days.
Input:
    - User birthdate via input dialog
    - Menu button selection (minutes, days, or exit)
Output:
    - Age displayed in minutes or days based on user selection
Engineering Algorithms:
    - Prompt user for birthdate using inputdlg
    - Validate input with try/catch
    - Wrap menu and switch/case in a forever while loop
    - When button 1 is pressed: display age in minutes
    - When button 2 is pressed: display age in days
    - When button 3 is pressed: exit program
MATLAB tools/functions:
    - While loop, menu, datetime, fprintf, switch/case,
      inputdlg, try/catch
%}

clear, clc

% Get and validate birthday before entering the menu loop
MyBirthday = GetBirthday();

% Build panel title: name stacked above current date
Rtitle = ["Age Calculator"; ...
          string(datetime('now', 'Format', 'eeee MMMM d yyyy'))];

PanelActive = true;

while PanelActive == true
    clc
    choice = menu(Rtitle, ...
        'Age in Minutes', ...
        'Age in Days', ...
        'Change Birthday', ...
        'Exit');

    switch choice
        case 1
            % Calculate age in minutes
            ageMinutes = minutes(datetime('now') - MyBirthday);
            fprintf('You were born %.0f minutes ago.\n', ageMinutes)
            pause(2)  % Pause so user can read the result

        case 2
            % Calculate age in days
            ageDays = days(datetime('now') - MyBirthday);
            fprintf('You were born %.1f days ago.\n', ageDays)
            pause(2)

        case 3
            % Allow user to re-enter birthday
            MyBirthday = GetBirthday();

        case 4
            PanelActive = false;
            clc
            fprintf('Goodbye!\n')
    end
end


%% --- Helper Function: GetBirthday ---
%{
GetBirthday function
Purpose:
    Prompts the user for their birthdate using a dialog box
    and validates the input.
Input:
    - N/A: no arguments expected
Output:
    - Validated datetime birthdate, or today's date if input is invalid
%}
function MyBirthday = GetBirthday()
    clc
    % Prompt user for birthdate via dialog box
    prompt          = {'Enter your birthday (yyyy-mm-dd):'};
    promptTitle     = 'Birthday Input';
    promptFieldsize = [1 35];
    promptDefault   = {char(datetime('today', 'Format', 'yyyy-MM-dd'))};

    answer = inputdlg(prompt, promptTitle, promptFieldsize, promptDefault);

    % Validate input
    try
        % Check if user cancelled the dialog
        if isempty(answer)
            warning('No input provided. Using today as default.');
            MyBirthday = datetime('today');
            return
        end

        % Parse the entered date
        MyBirthday = datetime(answer{1}, 'InputFormat', 'yyyy-MM-dd');

        % Make sure birthday is not in the future
        if MyBirthday > datetime('today')
            warning('Birthday cannot be in the future. Using today as default.');
            MyBirthday = datetime('today');
        end

    catch
        warning('Invalid date format entered. Using today as default.');
        MyBirthday = datetime('today');
    end
end