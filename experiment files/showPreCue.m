function showPreCue(preCueDuration, win, bgColor, prePostCue, cueType)
% showPreCue([win] [,bg color], prePostCue, cueType)
% displays a screen that indicates to participants whether to report left,
% right or both images if prePostCue==1; otherwise shows neutral precue

%% set defaults
if nargin < 2
    bgColor = [];
end
if isempty(bgColor)
    bgColor = [200 200 200];
end

%% set up screen
[winW, winH] = Screen('WindowSize', win);

Screen('TextFont', win, 'Arial');
Screen('TextSize', win, 32);

%% present
% duation can be kept in seconds, as no movement is involved and thus
% pause(duration in s) kan be used to time presentation
if prePostCue ==2
    
    Screen('FillOval', win, [0 0 0], [winW/2-10 winW/2+10; winH/2-10 winH/2+10]);
%     Screen('TextSize', win, 48);
%     DrawFormattedText(win, '?', 'center', 'center');
    %     Screen('DrawLines', win, [winW/2-50 winW/2+50; winH/2 winH/2], 5, [0 0 0]);
    Screen('Flip', win);
    
else
    
    if cueType == 1 % cue to left image
        Screen('DrawLines', win, [winW/2-50 winW/2+50; winH/2 winH/2], 5, [0 0 0]);
        Screen('DrawLines', win, [winW/2-50 winW/2-25; winH/2 winH/2-25], 5, [0 0 0]); %upper part of arrow
        Screen('DrawLines', win, [winW/2-50 winW/2-25; winH/2 winH/2+25], 5, [0 0 0]); %lower part of arrow
        Screen('Flip', win);
    elseif cueType==2 % cue to right image
        Screen('DrawLines', win, [winW/2-50 winW/2+50; winH/2 winH/2], 5, [0 0 0]);
        Screen('DrawLines', win, [winW/2+25 winW/2+50; winH/2-25 winH/2], 5, [0 0 0]); %upper part of arrow
        Screen('DrawLines', win, [winW/2+25 winW/2+50; winH/2+25 winH/2], 5, [0 0 0]); %lower part of arrow
        Screen('Flip', win);
    else % cue both
        %         DrawFormattedText(win, 'BOTH', 'center', 'center');
       Screen('DrawLines', win, [winW/2-50 winW/2+50; winH/2 winH/2], 5, [0 0 0]);
        Screen('DrawLines', win, [winW/2-50 winW/2-25; winH/2 winH/2-25], 5, [0 0 0]); %upper part of arrow
        Screen('DrawLines', win, [winW/2-50 winW/2-25; winH/2 winH/2+25], 5, [0 0 0]); %lower part of arrow
        Screen('DrawLines', win, [winW/2+25 winW/2+50; winH/2-25 winH/2], 5, [0 0 0]); %upper part of arrow
        Screen('DrawLines', win, [winW/2+25 winW/2+50; winH/2+25 winH/2], 5, [0 0 0]); %lower part of arrow
        
        Screen('Flip', win);
    end
end

pause(preCueDuration);

% display the fixation cross and exit
Screen('DrawLine', win, [0 0 0], winW/2-10, winH/2, winW/2+10, winH/2, 4);
Screen('DrawLine', win, [0 0 0], winW/2, winH/2-10, winW/2, winH/2+10, 4);
Screen('Flip', win);

return;