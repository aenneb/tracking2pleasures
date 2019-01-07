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
    
    
    %% we are only intersted in  one-image trials here
    % therefore, set imageCue<3
    % for pre-cued trials prePostCue==1; for post-cued trials prePostCue==2
    pleasure = pleasure(imageCue<3 & prePostCue==1);
    targetPleasure = targetPleasure(imageCue<3 & prePostCue==1);
    distractorPleasure = distractorPleasure(imageCue<3 & prePostCue==1);
    
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
            predict_linearModel_simple(parameters, trainTarget, trainDistractor)).^2));

        % Set the number of iterations and other options to optimally use fmin...
        options = optimoptions('fmincon', 'maxIter',10e8, 'maxFunEvals', 10e8, 'TolX', 1e-20); % for disgnostics also include: ,'Display','iter',
        % constraints
        lowerBounds = [0];
        upperBounds = [1];
        
        startValues = [.5];
        % Call the minimization fn
        parameters_linear(itter,:) = fmincon(cost_linear, startValues,[],[],[],[],lowerBounds,upperBounds,[],options);
    
        predictions_linear = predict_linearModel_simple(parameters_linear(itter,:), testTarget, testDistractor);
        
        cost_highAtt = @(parameters) sqrt(nanmean((trainPleasure - ...
            predict_highPleasureAttenuation(parameters, trainTarget, trainDistractor)).^2));
        % constraints
        lowerBounds = [1];
        upperBounds = [9];
        
        startValues = [5];
        % Call the minimization fn
        parameters_highAtt(itter,:) = fmincon(cost_highAtt, startValues,[],[],[],[],lowerBounds,upperBounds,[],options);
        
        predictions_highAtt = predict_highPleasureAttenuation(parameters_highAtt(itter,:), testTarget, testDistractor);
        
        % r-square can be ignored here - one data point to test is not
        % enough to compute it.
        [rSquare_linear(itter) RMSE_linear(itter)] = rsquare(testPleasure, predictions_linear);
        [rSquare_highAtt(itter) RMSE_highAtt(itter)] = rsquare(testPleasure, predictions_highAtt);
        
        [rSquare_accurate(itter) RMSE_accurate(itter)] = rsquare(testPleasure, testTarget);
        [rSquare_averaging(itter) RMSE_averaging(itter)] = rsquare(testPleasure, mean([testTarget testDistractor]));

    end
    
    % get summary means and SDs per participant
    avg_parameters_linear(idCount,:) = nanmean(parameters_linear,1);
    avg_parameters_highAtt(idCount,:) = nanmean(parameters_highAtt,1);
    avg_RMSE_linear(idCount) = nanmean(RMSE_linear);
    avg_RMSE_highAtt(idCount) = nanmean(RMSE_highAtt);
    avg_RMSE_accurate(idCount) = nanmean(RMSE_accurate);
    avg_RMSE_averaging(idCount) = nanmean(RMSE_averaging);

    std_parameters_linear(idCount,:) = nanstd(parameters_linear,1);
    std_RMSE_linear(idCount) = nanstd(RMSE_linear);
    std_RMSE_highAtt(idCount) = nanstd(RMSE_highAtt);
    std_RMSE_accurate(idCount) = nanstd(RMSE_accurate);
    std_RMSE_averaging(idCount) = nanstd(RMSE_averaging);
    
    idCount = idCount+1;
end

