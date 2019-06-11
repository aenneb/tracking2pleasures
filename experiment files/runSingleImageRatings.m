function runSingleImageRatings
% function runSingleImageRatings()
% calls all necessary functions sequentially and allows specification of
% the basic set-up for the trials

% V1: Aenne Brielmann, 24/4/17: create based on and as supplementary script
% to runPleasureIntegration.m
% should always follow pleasure integration experiment and simply asks
% participants for their pleasure rating for each image from 1-9
% I think we want to keep presentation in the periphery and the image's
% position fixed left or right
%%
diary debug.out % for debugging, write complete ouptput and error messages in output file
%%--- HIT THE KEY X AT ANY TIME DURING THE MAIN TRIALS TO EXIT---%%
clear %clean up
close all %close any figures
%% set folders we're working with
global folderName_scripts folderName_imageSet1 folderName_imageSet2

folderName_scripts = fileparts(mfilename('fullpath'));
folderName_imageSet1=fullfile(folderName_scripts,'imageSet1');
folderName_imageSet2=fullfile(folderName_scripts,'imageSet2');

%% set up INPUTS
imageDuration = .2; % in seconds
pauseDuration = .5; % in seconds
cueDuration = 1; % in seconds

gray = [200 200 200];

introText1 = ['On each trial, you will briefly see one image. \n'...
    'It will either be shown on the left or right side of the screen. \n'...
    'You will rate how much pleasure you felt from this image (1-9). \n' ...
    'When making your rating, please ignore whether it''s a picture of something good or bad. \n' ...
    'Just rate how much pleasure you felt, regardless of the goodness or badness of what''s in the picture. \n \n'...
    'Hit any key to continue.'];
introText2 = ['You will use the keys 1-9 on the keyboard to rate the pleasure you felt. \n' ...
    'A rating of 1 means that you felt no pleasure at all. '...
    'A rating of 9 indicates that you felt very intense pleasure. \n'...
    'There is no right or wrong answer. Just rate how much pleasure you felt. \n \n'...
    'Hit any key to continue.'];
introText3 = ['Between the two images, in the middle of the screen, you will see a black cross. \n'...
    'Always keep your eyes on this cross. Do not let your eyes drift away. \n'...
    'Keep your eyes on the cross. \n \n'...
    'Hit any key to continue.'];

%% %----------------- NO EDITING BEYOND THIS LINE NECESSARY FOR RUNNING THE EXPERIMENT --------------%
%% set up a logfile
cd(folderName_scripts)
logfile = setUpLogfileSingle(imageDuration, cueDuration, pauseDuration);

%% read in image names
cd(folderName_imageSet1)
str=dir('*.jpg');
imageNames1 = {str(:).name};
cd(folderName_imageSet2)
str=dir('*.jpg');
imageNames2 = {str(:).name};
numImages = length(imageNames1);

%% set up the screen and keyboard
screenid = max(Screen('Screens'));
Screen('Preference', 'SkipSyncTests', 1);

win = Screen('OpenWindow', screenid, gray);

[winW, winH] = Screen('WindowSize', win);

ifi = Screen('GetFlipInterval', win);
vbl=Screen('Flip', win);

% use 'vbl' based timing, just that the frame-skip detector works
% accurately and we get notified of possibly skipped frames
vbl=Screen('Flip', win,vbl+ifi/2);

keyboard=-1; % allows use of any keyboard

%% run the experiment. Run through numBlocks blocks of the same structure
% first show an intro
cd(folderName_scripts)
HideCursor;
DrawFormattedText(win, introText1,'center', 'center');
response_start = Screen('Flip', win);
pause(3);
getKeyboardResponse(keyboard, response_start);
pause(.2);
DrawFormattedText(win, introText2,'center', 'center');
response_start = Screen('Flip', win);
pause(2);
getKeyboardResponse(keyboard, response_start);
pause(.2);
DrawFormattedText(win, introText3,'center', 'center');
response_start = Screen('Flip', win);
pause(2);
getKeyboardResponse(keyboard, response_start);
pause(.2);


%% set up randomization
cd(folderName_scripts)
trialSpecification = setUpRandomizationSingleImages(numImages); % first column codes whether left or right image is displayed; second column codes number of image on left side; third column codes number of image on the right
nTrials = size(trialSpecification,1);

%% start image presentation
for trial = 1:nTrials
    
    pause(pauseDuration);
    
    showPreCue(cueDuration, win, gray, 2); % with arg(4) = 2, only dot is shown
    
    pause(.1);
    
    if trialSpecification(trial,1)==0
        showOneImage(win, gray, imageNames1{trialSpecification(trial,2)}, trialSpecification(trial,1), imageDuration);
    else
        showOneImage(win, gray, imageNames2{trialSpecification(trial,3)}, trialSpecification(trial,1), imageDuration);
    end
    
    pause(.1);
    
    cd(folderName_scripts)
    [response_start] = showPostCue(cueDuration, win, gray, 1); % with arg(4) = 1, only dot is shown
    
    [rt, response, responseKey] = getKeyboardResponse(keyboard, response_start);
    
    % display the fixation cross again
    Screen('DrawLine', win, [0 0 0], winW/2-10, winH/2, winW/2+10, winH/2, 4);
    Screen('DrawLine', win, [0 0 0], winW/2, winH/2-10, winW/2, winH/2+10, 4);
    Screen('Flip', win);
    
    % write info into logfile
    
    if trialSpecification(trial,1)==0
        writeTrialInfoSingle(logfile, imageNames1{trialSpecification(trial,2)}, 'NaN', response, responseKey, rt);
    else
        writeTrialInfoSingle(logfile, 'NaN', imageNames2{trialSpecification(trial,3)},  response, responseKey, rt);
    end
    
end

%% show a short thanks
DrawFormattedText(win, 'Thank you! The experiment is now finished.','center', 'center');
Screen('Flip', win);
pause(3);

%% Done. Close windows, close logfile and exit:
fclose(logfile);
Screen('CloseAll');
ShowCursor;

end