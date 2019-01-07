% try to model complete data per participant with different cues for
% pre-post and both cued conditions

%%
clear
close all
cd ..
rootdir = pwd;
cd([rootdir '/data/matFiles/'])
%% load data
files = dir('*.mat');

idCount = 1;

for file = files'
    
    cd([rootdir '/data/matFiles/'])
    mat_file = file.name;
    load(mat_file);
    
    %% we are only intersted in pre/post-cued, both-image trials here
    % therefore imageCue==3
    % for pre-cued trials prePostCue==1; for post-cued trials prePostCue==2
    pleasure = pleasure(imageCue==3 & prePostCue==2);
    targetPleasure = targetPleasure(imageCue==3 & prePostCue==2);
    distractorPleasure = distractorPleasure(imageCue==3 & prePostCue==2);
    
    nTrials = length(pleasure);
    
    for itter = 1:nTrials
        %% now we leave one trial out for computation of error
        trainPleasure = pleasure;
        trainTarget = targetPleasure;
        trainDistractor = distractorPleasure;
        trainPleasure(itter) = NaN;
        trainTarget(itter) = NaN;
        trainDistractor(itter) = NaN;
        
        testPleasure = pleasure(itter);
        testTarget = targetPleasure(itter);
        testDistractor = distractorPleasure(itter);
        
        %% for each trial, we need the right target/distractor input information
        cd([rootdir '/analyses/'])
        
        cost_linear = @(parameters) sqrt(nanmean((trainPleasure - ...
            predict_linearModel_averaging(parameters, trainTarget, trainDistractor)).^2));

        % Set the number of iterations and other options to optimally use fmin...
        options = optimoptions('fmincon', 'maxIter',10e8, 'maxFunEvals', 10e8, 'TolX', 1e-20); % for disgnostics also include: ,'Display','iter',
        % constraints
        lowerBounds_compress = [0 0]; upperBounds_compress = [10 1];
        lowerBounds_extreme = [-10 1]; upperBounds_extreme = [0 10];
        
        startValues = [0 1];
        % Call the minimization fn
        parameters_compress(itter,:) = fmincon(cost_linear, startValues,[],[],[],[],lowerBounds_compress,upperBounds_compress,[],options);
        parameters_extreme(itter,:) = fmincon(cost_linear, startValues,[],[],[],[],lowerBounds_extreme,upperBounds_extreme,[],options);
        
        predictions_compress = predict_linearModel_averaging(parameters_compress, testTarget, testDistractor);
        predictions_extreme = predict_linearModel_averaging(parameters_extreme, testTarget, testDistractor);
        
        RMSE_compress(itter) = sqrt(nanmean((testPleasure - predictions_compress).^2));
        RMSE_extreme(itter) = sqrt(nanmean((testPleasure - predictions_extreme).^2));
        
        RMSE_averaging(itter) = sqrt(nanmean((testPleasure - mean([testTarget testDistractor])).^2));
        
    end
    % get summary means per participant
    avg_parameters_compress(idCount,:) = nanmean(parameters_compress,1);
    avg_parameters_extreme(idCount,:) = nanmean(parameters_extreme,1);
    
    avg_RMSE_compress(idCount) = nanmean(RMSE_compress);
    avg_RMSE_extreme(idCount) = nanmean(RMSE_extreme);
    avg_RMSE_averaging(idCount) = nanmean(RMSE_averaging);
 
    idCount = idCount+1;
end
