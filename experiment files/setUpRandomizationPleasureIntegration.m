function [trialSpecification] = setUpRandomizationPleasureIntegration(numImages, prePostSequence)
% numImages : indicates the number of images for each side
% prePostSequence : 0 or 1, inidcates whether the first block is pre- or post-cueing
% prePostCueInd : 0 or 1, indicates for each trial whether a pre-or post-cue is used. A remainder from randomization without blocking pre- and post-cue. I kept the variable for more flexibility, so we could theoretically mix pre- and post-cueing again.
% imageInd1 / imageInd2 : indices for the image files
% imageCueInd : either 1 (cues image on the left), 2 (cues image on the right), or 3 (cues both)
% trialSpecification : a 4 x numImages matrix that specifies the concrete trial setup used. Column 1 indicates whether its pre- or post-cueing, column 2 which images are cued, column 3 and 4 give the indices for the images to be shown.

% random trial specifications are set up in triplets within which each
% images is shown once under each priming condition, but never paired with
% the same other image
% for this to work number of images HAS to be a multiple of 3! Otherwise,
% not all images will be shown
%%
numTrialsPerCue = 3*floor(numImages/3);

% we block pre- and post-cue trials, so first column is N x repeatedly the
% same pre/post cue.
if prePostSequence==1
    prePostCueInd = [repmat(ones(3,1), numTrialsPerCue, 1); repmat(ones(3,1)*2, numTrialsPerCue, 1)];
else
    prePostCueInd = [repmat(ones(3,1)*2, numTrialsPerCue, 1); repmat(ones(3,1), numTrialsPerCue, 1)];
end

% setting up the triplets separately for pre- and post-cueing, such that
% piarings also don't repeat between blocks
for cueBlock = 1:2
    %to avoid same pairings for different participants, shuffle image
    %counter for BOTH image sets, but do so in triplets, because
    %otherwise we get duplicates and left out images
    im1Ind = Shuffle(1:3:numTrialsPerCue);
    im2Ind = Shuffle(1:3:numTrialsPerCue);
    im1Counter = 1;
    im2Counter = 1;
    imCounter = 1;
    
    %% also ensure that none of the image pairings repeats
    indices_stored(cueBlock,:,:) = [im1Ind; im2Ind];
    
    if cueBlock>1
        indRepeat = 1;
        while indRepeat
            if sum(sum(indices_stored(cueBlock-1,:,:)==indices_stored(cueBlock,:,:)))>numTrialsPerCue
                im1Ind = Shuffle(1:3:numTrialsPerCue);
                indices_stored(cueBlock,:,:) = [im1Ind; im2Ind];
            else
                indRepeat = 0;
            end
        end
    end
    
    %% create the triplet structure
    trialCounter = 1;
    for ii = 1:floor(numImages/3)
        
        % kind of cueing
        imageCuePairs(1,trialCounter:trialCounter+8) = ...
            repmat(1:3,1,3);
        %image index for image on left
        imageCuePairs(2,trialCounter:trialCounter+8) = ...
            [repmat(im1Ind(im1Counter),1,3) repmat(im1Ind(im1Counter)+1,1,3) repmat(im1Ind(im1Counter)+2,1,3)]; % images on left stream are simply sorted
        % index for image on right
        imageCuePairs(3,trialCounter:trialCounter+8) = ...
            [im2Ind(im2Counter) im2Ind(im2Counter)+1 im2Ind(im2Counter)+2 ...
            im2Ind(im2Counter)+2 im2Ind(im2Counter) im2Ind(im2Counter)+1 ...
            im2Ind(im2Counter)+1 im2Ind(im2Counter)+2 im2Ind(im2Counter)]; % images on right stream are matched to first stream such that no repetition of pairs occurs
        
        imCounter = imCounter+3;
        im1Counter = im1Counter+1;
        im2Counter = im2Counter+1;
        trialCounter = trialCounter+9;
    end
    
    % shuffle the cue sequence
    randSeq = Shuffle(1:size(imageCuePairs,2));
    randImCue_tmp = imageCuePairs(:,randSeq);
    
    % the last thing we now need to check is whether any image is presented
    % repeatedly
    jj = 1;
    while jj<size(randImCue_tmp,2)-1
        
        if randImCue_tmp(2,jj)==randImCue_tmp(2,jj+1) || randImCue_tmp(3,jj)==randImCue_tmp(3,jj+1)
            
            swapTrialInd = Sample(1:numTrialsPerCue);
            swapTrial = randImCue_tmp(:,swapTrialInd);
            randImCue_tmp(:,swapTrialInd) = randImCue_tmp(:,jj);
            randImCue_tmp(:,jj) = swapTrial;
            jj = 1;
            
        else
            jj=jj+1;
        end
        
    end
    
    randImCue(:,:,cueBlock) = randImCue_tmp;
    
end
trialSpecification_tmp = [randImCue(:,:,1) randImCue(:,:,2)]';

trialSpecification = [prePostCueInd trialSpecification_tmp];

end

