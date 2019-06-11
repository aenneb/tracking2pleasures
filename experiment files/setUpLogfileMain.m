function logfile = setUpLogfileMain(imageDuration, preCueDuration, pauseDuration, nBlocks)
% sets up a logfile for the control task for the N-backExperiment
% all dates are in American format, now

subject_id = input('Enter subject ID:	', 's');

fileName = [subject_id '_' ...
            datestr(now, '_mm') datestr(now, '_dd')...
            datestr(now,'_yy') '_main.txt'];
        
filePath = cd;
logfile = fopen([filePath '/' fileName],'a+');

fprintf(logfile, 'Participant: %s\n', subject_id);

fprintf(logfile, [datestr(now, 'mm'), datestr(now, ' dd'),...
            datestr(now,' yy'), datestr(now, ' HH:MM:SS\n')]);
        
fprintf(logfile, 'image_duration: %.2f\n', imageDuration);
fprintf(logfile, 'precue_duration: %.2f\n', preCueDuration);
fprintf(logfile, 'pause_duration: %.2f\n', pauseDuration);
fprintf(logfile, 'nBlocks: %d\n', nBlocks);

fprintf(logfile, ['image_left' '\t' 'image_right' '\t'...
    'pre_or_post_cue' '\t' 'location_cued_image' '\t'...
    'pelasure' '\t' 'key_pressed' '\t' 'rt' '\t' '\n']);
        
end
