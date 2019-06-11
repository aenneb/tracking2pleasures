function runPleasureIntegration
% function runPleasureIntegration()
% calls all necessary functions sequentially and allows specification of
% the basic set-up for the trials

% V1: Aenne Brielmann, 11/6/16: create.
% V2: Aenne Brielmann, 11/7/16: use this now as master function that is the
% only one calling for the Screen, showOneImagePerSide() and
% showTwoImages( are now completely dependent on this function
% V3: Aenne Brielmann 01/27/17: change design to mixed pre-post-cueing experiment
% V4: Denis Pelli 1/31/17: define folders in a portable way to work on any
% computer. Polished the instructions.
% V5: Aenne Brielmann 02/01/2017: replace simple KbWait() with Denis
% Pelli's suggested try-catch version of ListenChar() in combination with
% KbStrockeWait(). Implement this in a new function getKeyboardResponse()
%%
% diary debug.out % for debugging, write complete ouptput and error messages in output file
clear %clean up
close all %close any figures
%% set folders we're working with
global folderName_scripts folderName_imageSet1 folderName_imageSet2 folderName_trainingImages

folderName_scripts = fileparts(mfilename('fullpath'));
folderName_imageSet1=fullfile(folderName_scripts,'imageSet1');
folderName_imageSet2=fullfile(folderName_scripts,'imageSet2');
folderName_trainingImages=fullfile(folderName_scripts,'trainingImages');

%% set up INPUTS
imageDuration = .2; % in seconds
pauseDuration = .5; % in seconds
cueDuration = 1; % in seconds

numBlocks = 4;

gray = [200 200 200];

introText1 = ['On each trial, you will briefly see a pair of images, one on the left and one on the right. \n'...
    'You will rate how much pleasure you felt from one or both images (1-9). \n' ...
    'Arrows will indicate whether to report on the left (<--), right (-->), or both images (<-->).\n' ...
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
trainText = ['You will now do some training trials to get you used to your task. \n \n'...
    'Hit any key to continue.'];
endTrainText = ['Thank you. You have finsihed your prectice trials. \n' ...
     'Please call the experimenter. \n \n'...
    'Hit any key to continue.'];
startExperimentText = ['You will now start the actual experiment. \n \n'...
    'Hit any key to continue.'];
preCueExplanation = ['In this block of the experiment, we will tell you which images to report on BEFORE they appear. \n' ...
    'Keep your eyes on the cross in the middle of the screen. Do not let your eyes drift away. \n'...
    'Remember: Report only how much pleasure you felt, not the image''s goodness or badness. \n'...
    'Rate by hitting a key from 1 (no pleasure at all) to 9 (very intense pleasure). \n \n'...
    'Hit any key to continue.'];
postCueExplanation = ['In this block of the experiment, we will tell you which images to report on AFTER they appear. \n' ...
    'Keep your eyes on the cross in the middle of the screen. Do not let your eyes drift away. \n'...
    'Remember: Report only how much pleasure you felt, not the image''s goodness or badness. \n'...
    'Rate by hitting a key from 1 (no pleasure at all) to 9 (very intense pleasure). \n \n'...
    'Hit any key to continue.'];

%% %----------------- NO EDITING BEYOND THIS LINE NECESSARY FOR RUNNING THE EXPERIMENT --------------%
%% set up a logfile
cd(folderName_scripts)
logfile = setUpLogfileMain(imageDuration, cueDuration, pauseDuration, numBlocks);

%% read in image names
cd(folderName_imageSet1)
str=dir('*.jpg');
imageNames1 = {str(:).name};
cd(folderName_imageSet2)
str=dir('*.jpg');
imageNames2 = {str(:).name};
cd(folderName_trainingImages)
str=dir('*.jpg');
imageNamesTrain = {str(:).name};
numImages = length(imageNames1);
%% randomly chose for each participant whether he or she sees pre- or post-cue trials first
prePostSequence = round(rand);

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

%% first do some practice trials with fixed cue and image order
trainSpec = [1 1 1 3;
             1 2 2 4;
             1 3 1 4;
             2 2 2 3;
             2 3 2 4;
             2 1 1 3];
         
DrawFormattedText(win, trainText,'center', 'center');
response_start = Screen('Flip', win);
pause(1);
getKeyboardResponse(keyboard, response_start);

for trial = 1:size(trainSpec,1)
        %show intro to each cueing condition
        if trial==1 || trial==size(trainSpec,1)/2+1
            
            if trainSpec(trial,1)==1
                Screen('TextFont', win, 'Arial');
                Screen('TextSize', win, 24);
                DrawFormattedText(win, preCueExplanation,'center', 'center');
                response_start = Screen('Flip', win);
            else
                Screen('TextFont', win, 'Arial');
                Screen('TextSize', win, 24);
                DrawFormattedText(win, postCueExplanation,'center', 'center');
                response_start = Screen('Flip', win);
            end
            
            pause(2);
            getKeyboardResponse(keyboard, response_start);
            pause(1);
        end
    showPreCue(cueDuration, win, gray, trainSpec(trial,1), trainSpec(trial,2));
    
    pause(.1);
    
    showTwoImages_train(win, gray, imageNamesTrain{trainSpec(trial,3)}, imageNamesTrain{trainSpec(trial,4)}, imageDuration);
    
    pause(.1);
    
    cd(folderName_scripts)
    [response_start] = showPostCue(cueDuration, win, gray, trainSpec(trial,1), trainSpec(trial,2));
    
    getKeyboardResponse(keyboard, response_start);
    
    % display the fixation cross again
    Screen('DrawLine', win, [0 0 0], winW/2-10, winH/2, winW/2+10, winH/2, 4);
    Screen('DrawLine', win, [0 0 0], winW/2, winH/2-10, winW/2, winH/2+10, 4);
    Screen('Flip', win);

    pause(pauseDuration);
end

%% switch from training to experiment proper with forced break in between
DrawFormattedText(win, endTrainText,'center', 'center');
response_start = Screen('Flip', win);
pause(5);
getKeyboardResponse(keyboard, response_start);

DrawFormattedText(win, startExperimentText,'center', 'center');
response_start = Screen('Flip', win);
pause(1);
getKeyboardResponse(keyboard, response_start);

for block = 1:numBlocks
    %% set up randomization
    cd(folderName_scripts)
    trialSpecification = setUpRandomizationPleasureIntegration(numImages, prePostSequence); % first column codes whether pre- or post-cue; second column codes which kind of cue (left, right, both); third column codes number of image on left side; fourth column codes number of image on the right
    % and also shuffle one of the image name sequences, so we have
    % randomized pairs for each block
    imageNames2 = Shuffle(imageNames2);
    nTrials = size(trialSpecification,1);
    
    %% start image presentation
    for trial = 1:nTrials
        
        %show intro to each cueing condition
        if trial==1 || trial==nTrials/2+1
            
            if trialSpecification(trial,1)==1
                Screen('TextFont', win, 'Arial');
                Screen('TextSize', win, 24);
                DrawFormattedText(win, preCueExplanation,'center', 'center');
                response_start = Screen('Flip', win);
            else
                Screen('TextFont', win, 'Arial');
                Screen('TextSize', win, 24);
                DrawFormattedText(win, postCueExplanation,'center', 'center');
                response_start = Screen('Flip', win);
            end
            
            pause(2);
            getKeyboardResponse(keyboard, response_start);
            pause(1);
        end
        
        showPreCue(cueDuration, win, gray, trialSpecification(trial,1), trialSpecification(trial,2));
        
        pause(.1);
        
        showTwoImages(win, gray, imageNames1{trialSpecification(trial,3)}, imageNames2{trialSpecification(trial,4)}, imageDuration);
        
        pause(.1);
        
        cd(folderName_scripts)
        [response_start] = showPostCue(cueDuration, win, gray, trialSpecification(trial,1), trialSpecification(trial,2));
        
        [rt, response, responseKey] = getKeyboardResponse(keyboard, response_start);
        
        % display the fixation cross again
        Screen('DrawLine', win, [0 0 0], winW/2-10, winH/2, winW/2+10, winH/2, 4);
        Screen('DrawLine', win, [0 0 0], winW/2, winH/2-10, winW/2, winH/2+10, 4);
        Screen('Flip', win);
        
        % write info into logfile
        writeTrialInfoToLogfile(logfile, trialSpecification(trial,1), trialSpecification(trial,2), imageNames1{trialSpecification(trial,3)}, imageNames2{trialSpecification(trial,4)}, response, responseKey, rt);
        
        pause(pauseDuration);
    end
    
end

%% show a short thanks
DrawFormattedText(win, ['Thank you! This part of the experiment is now finished. \n \n'...
    'Please contact the experimenter.'],'center', 'center');
Screen('Flip', win);
pause(3);

%% Done. Close windows, close logfile and exit:
fclose(logfile);
Screen('CloseAll');
ShowCursor;

end