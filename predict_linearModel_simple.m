function [predictions] = predict_linearModel_simple(parameters, targetPleasure, distractorPleasure)

% predicts ratings based on a linear function of a weighted average of target and
% distractor pelasure
% special case: no compresstion or amplification

weight = parameters;

predictions = weight*targetPleasure + (1-weight)*distractorPleasure;


end