function showOneImage(win, gray, imageName, imageSide, imageDuration)
% load and present one image for a given duration with a given
% pause between images and wait for button press before exiting

% History:
% V1: 24/4/17 Aenne Brielmann: created from showTwoImages

%% get screen dimensions
[winW, winH] = Screen('WindowSize', win);

%% Set up textures, i.e. the actual image data
global folderName_imageSet1 folderName_imageSet2

if imageSide==0
    cd(folderName_imageSet1)
else
    cd(folderName_imageSet2)
end

imageData = imread(imageName);
imagetex=Screen('MakeTexture', win, imageData);

%% present images
% Draw on image on one side of the fixation cross:

if imageSide==0
    Screen('DrawTexture', win, imagetex, [], [winW/25 winH/2-200 winW/25+500 winH/2+200]);
else
    Screen('DrawTexture', win, imagetex, [], [(winW-winW/25-500) winH/2-200 (winW-winW/25) winH/2+200]);
end

Screen('DrawLine', win, [0 0 0], winW/2-10, winH/2, winW/2+10, winH/2, 4);
Screen('DrawLine', win, [0 0 0], winW/2, winH/2-10, winW/2, winH/2+10, 4);
Screen('Flip', win);
% wait untril image duration has elapsed
pause(imageDuration);

% display a blank screen
Screen('FillRect', win, gray)
Screen('Flip', win);

return;