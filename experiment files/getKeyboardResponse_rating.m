function [rt, response, responseKey] = getKeyboardResponse_rating(keyboard, response_start)
% getKeyboardResponse(keyboard)
% is a modified version of KeyboardInputDemo by Denis Pelli, January 2017
%
% Suppresses keyboard echoing with ListenChar(2).
% records only keystrokes on the numbers 1-9, ignores all others.
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
KbName('UnifyKeyNames')
%%
keyValid=0;
try
    ListenChar(2);
    while keyValid==0
        [secs, keyCode, ~] = KbStrokeWait(keyboard);% Wait for all keys up, any key down, and all keys back up. Record key and time until key was pressed.
        responseKey = find(keyCode,1);
        if responseKey>29 && responseKey<39 % upper number panel
            response = responseKey-29;
            keyValid = 1;
        elseif responseKey>88 && responseKey<98 % numpad
            response = responseKey-88;
            keyValid = 1;
        elseif responseKey == 27 % hitting "x" will quit
            %% QUIT. Close windows and exit:
            ListenChar; % restore keyboard
            sca; % restore screen
            Screen('CloseAll');
            ShowCursor;
        else
            response = NaN;
        end
    end
    ListenChar;
catch
    ListenChar; % restore keyboard
    sca; % restore screen
    Screen('CloseAll');
    ShowCursor;
end

rt = secs - response_start;

end
