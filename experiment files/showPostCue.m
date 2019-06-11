function [response_start] = showPostCue(postCueDuration, win, bgColor, prePostCue, cueType)
% [stim_start] = showPostCue([win] [,bg color], prePostCue, cueType)
% displays a screen that indicates to participants whether to report left,
% right or both images if prePostCue==2; otherwise shows neutral precue
% output is the onset time of the postcue which is then used to calculate
% response times

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
if prePostCue ==1
    
    Screen('FillOval', win, [0 0 0], [winW/2-10 winW/2+10; winH/2-10 winH/2+10]);
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
    else
        %         DrawFormattedText(win, 'BOTH', 'center', 'center');
        Screen('DrawLines', win, [winW/2-50 winW/2+50; winH/2 winH/2], 5, [0 0 0]);
        Screen('DrawLines', win, [winW/2-50 winW/2-25; winH/2 winH/2-25], 5, [0 0 0]); %upper part of arrow
        Screen('DrawLines', win, [winW/2-50 winW/2-25; winH/2 winH/2+25], 5, [0 0 0]); %lower part of arrow
        Screen('DrawLines', win, [winW/2+25 winW/2+50; winH/2-25 winH/2], 5, [0 0 0]); %upper part of arrow
        Screen('DrawLines', win, [winW/2+25 winW/2+50; winH/2+25 winH/2], 5, [0 0 0]); %lower part of arrow
        
        Screen('Flip', win);
    end
end

pause(postCueDuration);

    Screen('TextSize', win, 48);
    DrawFormattedText(win, '?', 'center', 'center');
    response_start = Screen('Flip', win);
end

