% get all participants' ratings and calculate ICC

%%
clear
close all
cd ..
rootdir = pwd;
cd([pwd '/data/matFiles/'])
%% load data
files = dir('*.mat');

counter = 1;
idCount = 1;

for file = files'
    
    mat_file = file.name;
    load(mat_file);
    
    PLEASURE(counter:counter+length(pleasure)-1) = pleasure;
    TARGETPLEASURE(counter:counter+length(targetPleasure)-1) = targetPleasure;
    DISTRACTORPLEASURE(counter:counter+length(targetPleasure)-1) = distractorPleasure;
    
    BASELINEPLEASURE(:,idCount) = baselinePleasure;
    
    IMAGECUE(counter:counter+length(pleasure)-1) = imageCue;
    PREPOSTCUE(counter:counter+length(pleasure)-1) = prePostCue;

    subjectID(counter:counter+length(pleasure)-1) = idCount;
    
    counter = size(PLEASURE, 2)+1;
    idCount = idCount+1;
    
end

subjIedntifiers = {files.name};

%% calculate ICC
cd([rootdir '/analyses/'])
% for ICC we need a ...-1 argument, as we do not have average, but single
% measurements; we need A-... argument because we are interested in the
% absolute and not only the relative pleasure judgement.
% we also need to exclude participants with incomplete data as ICC cannot
% handle NaN.
ICC(BASELINEPLEASURE(:,2:end),'A-1')
