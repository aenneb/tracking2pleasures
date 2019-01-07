% get all participants' ratings and calculate ICC

%%
clear
close all
cd '/Users/aennebrielmann/Google Drive/PhD/studies/pleasure integration/data/matFiles'
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
cd '/Users/aennebrielmann/Google Drive/PhD/studies/pleasure integration/analyses'
% for ICC we need a ...-1 argument, as we do not have average, but single
% measurements; we need A-... argument because we are interested in the
% absolute and not only the relative pleasure judgement.
% we also need to exclude participants with incomplete data as ICC cannot
% handle NaN.
ICC(BASELINEPLEASURE(:,2:end),'A-1')

%% also look at the correlation between our subbject's pleasure ratings and the 
% valence as well as beauty ratings obtained on mTurk
cd '/Users/aennebrielmann/Google Drive/PhD/studies/pleasure integration/data'
load baselineImageInformation

for subj = 1:idCount-1
    
   corr_valence(subj) = corr(BASELINEPLEASURE(:,subj), imInfo.valence);
   corr_beauty(subj) = corr(BASELINEPLEASURE(:,subj), imInfo.beauty);
end

figure(1);clf;

subplot(1,2,1)
box off
axis square
hold on
for subj = 1:idCount-1
plot(imInfo.valence, BASELINEPLEASURE(:,subj), 'o')
lsline()
end 
axis([1 7 1 9])
xlabel('Valence pre-rated')
ylabel('Pleasure')

subplot(1,2,2)
box off
axis square
hold on
for subj = 1:idCount-1
plot(imInfo.beauty, BASELINEPLEASURE(:,subj), 'o')
lsline()
end 
axis([1 7 1 9])
xlabel('Beauty pre-rated')
ylabel('Pleasure')