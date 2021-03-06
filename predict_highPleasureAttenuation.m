function [predictions] = predict_highPleasureAttenuation(parameters, targetPleasure, distractorPleasure)

% predicts ratings based on a linear function of a weighted average of target and
% distractor pelasure
% here, predicted averaged pleasure is more extreme than the actual average

P_beau=parameters(1);

for trial = 1:length(targetPleasure)
    
   if targetPleasure(trial)<P_beau
       predictions(trial) = targetPleasure(trial);
   else
       predictions(trial) = P_beau + (distractorPleasure(trial)./targetPleasure(trial))*(targetPleasure(trial)-P_beau);
   end
    
end

end