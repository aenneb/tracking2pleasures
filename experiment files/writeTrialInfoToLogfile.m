function writeTrialInfoToLogfile(logfile, prePostCue, cueType, imageName1, imageName2, response1, responseKey, rt1)

% print info about the current picture shown
fprintf(logfile, ['%s' '\t'], imageName1);
fprintf(logfile, ['%s' '\t'], imageName2);
fprintf(logfile, ['%d' '\t'], prePostCue);
fprintf(logfile, ['%d' '\t'], cueType);
fprintf(logfile, ['%d' '\t'], response1);
fprintf(logfile, ['%d' '\t'], responseKey);
fprintf(logfile, ['%d' '\n'], rt1);

end