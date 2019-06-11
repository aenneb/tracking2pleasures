function [rt, response, responseKey] = getKeyboardResponse(keyboard, response_start)
% getKeyboardResponse(keyboard)
% is a modified version of KeyboardInputDemo by Denis Pelli, January 2017
%
% Suppresses keyboard echoing with ListenChar(2).
% uses  try/catch/end to clean up after an error by
% Catch block contains SCA, closes the screen.
% records response time and response key.
% sets "x" as an exit key
%% defaults
if nargin < 1
    keyboard = [];
end
if isempty(keyboard)
    keyboard = -1; % set all keyboards as default for device to detect keystrokes from
end
if nargin < 2
    response_start = [];
end
if isempty(response_start)
    response_start = 0;
end
%%

try
    ListenChar(2);
    [secs, keyCode, ~] = KbStrokeWait(keyboard); % Wait for all keys up, any key down, and all keys back up. Record key and time until key was pressed.
    ListenChar;
catch
    ListenChar; % restore keyboard
    sca; % restore screen
    Screen('CloseAll');
    ShowCursor;
end

% at least on an OSX system, keyCodes can easily be translated into
% their actual meaning. Do this to directly record pleasure ratings as
% made by participants
responseKey = find(keyCode,1);
if responseKey<39 && responseKey>29 % for num keys above letter keys
    response = responseKey-29;
elseif responseKey<98 && responseKey>88 % for NumPad
    response = responseKey - 88;
elseif responseKey == 77 % for NumPad with numLock
    response = 1;
elseif responseKey == 78 % for NumPad with numLock
    response = 3;
elseif responseKey == 79 % for NumPad with numLock
    response = 6;
elseif responseKey == 80 % for NumPad with numLock
    response = 4;
elseif responseKey == 81 % for NumPad with numLock
    response = 2;
elseif responseKey == 82 % for NumPad with numLock
    response = 8;
elseif responseKey == 77 % for NumPad with numLock
    response = 1;
elseif responseKey == 75 % for NumPad with numLock
    response = 9;
elseif responseKey == 74 % for NumPad with numLock
    response = 7;
else
    response = NaN; % set response to NaN if a non-number key has been pressed.
end

rt = secs - response_start;

if responseKey == 27 % hitting "x" will quit
    %% QUIT. Close windows and exit:
    sca; % restore screen
    Screen('CloseAll');
    ShowCursor;
end

end
