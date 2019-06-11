function showTwoImages_train(win, gray, imageName1, imageName2, imageDuration)
% load and present two images for a given duration with a given
% pause between images and wait for button press before exiting

% History:
% V1: 11/6/16 Aenne Brielmann: created from ShowOneImagePerSide
% V2: 01/27/17 Aenne Brielmann: adapted to now work for pre- and
% post-cueing

%% get screen dimensions
[winW, winH] = Screen('WindowSize', win);

%% Set up textures, i.e. the actual image data
global folderName_trainingImages

cd(folderName_trainingImages)
imageData1 = imread(imageName1);
imagetex1=Screen('MakeTexture', win, imageData1);
imageData2 = imread(imageName2);
imagetex2=Screen('MakeTexture', win, imageData2);

%% present images
% Draw on image on either side of the fixation cross:
Screen('DrawTexture', win, imagetex1, [], [winW/25 winH/2-200 winW/25+500 winH/2+200]);
Screen('DrawTexture', win, imagetex2, [], [(winW-winW/25-500) winH/2-200 (winW-winW/25) winH/2+200]);

Screen('DrawLine', win, [0 0 0], winW/2-10, winH/2, winW/2+10, winH/2, 4);
Screen('DrawLine', win, [0 0 0], winW/2, winH/2-10, winW/2, winH/2+10, 4);
Screen('Flip', win);
% wait untril image duration has elapsed
pause(imageDuration);

% display a blank screen
Screen('FillRect', win, gray)
Screen('Flip', win);

return;