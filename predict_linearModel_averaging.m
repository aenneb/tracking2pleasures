function [predictions] = predict_linearModel_averaging(parameters, targetPleasure, distractorPleasure)

% predicts ratings based on a linear function of a weighted average of target and
% distractor pelasure
% a simplified version to only test both-cued ratings always assumes a
% weight of .5

a=parameters(1);
b=parameters(2);
weight = 0.5;

predictions = a + b*(weight*targetPleasure + (1-weight)*distractorPleasure);


end