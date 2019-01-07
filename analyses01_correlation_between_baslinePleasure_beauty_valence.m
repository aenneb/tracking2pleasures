% relate the pleasure ratings to the "normative" beauty ratings obtained in
% a previous stuyd, Brielmann & Pelli (under review)
%%
clear
close all

cd ..

cd([pwd '/data/'])
load baselineImageInformation

cd([pwd '/matFiles/'])

%% load data
files = dir('*.mat');

idCount = 1;

for file = files'

    mat_file = file.name;
    load(mat_file);
    
    % we calculate correlations between baseline pleasure ratings and the beauty
    % rating for that image per participant
    
    r_beauty(idCount) = corr(imInfo.beauty, baselinePleasure', 'rows', 'complete');
    r_valence(idCount) = corr(imInfo.valence, baselinePleasure', 'rows', 'complete');
     
    idCount = idCount+1;
end

%% summary
mean(r_beauty)
min(r_beauty)
max(r_beauty)

mean(r_valence)
min(r_valence)
max(r_valence)