function durationInFrames = secondsToFrames(frameRate, duration)
% calculate duration in frames, as this is the time unit for
% displaying something with Psychtoolbox

durationInFrames = duration*frameRate;

end