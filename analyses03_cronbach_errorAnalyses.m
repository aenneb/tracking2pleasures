% Based on the Habermann et al., 2015, paper, I also want to look at the
% consistency in participants' errors
% We need to use the mean absolute error per item, to be consistent with
% their paper (by coincidence, I think we even have the same # of trials
% per item, i.e., 4)

%%
clear
close all
cd ..
rootdir = pwd;
cd([pwd '/data/matFiles/'])
%% load data
files = dir('*.mat');

idCount = 1;

for file = files'
    
    mat_file = file.name;
    load(mat_file);
    
    % sort trials appropriately
    pleasure_pre_one = pleasure(imageCue<3 & prePostCue==1);
    targetInd_pre_one = targetInd(imageCue<3 & prePostCue==1);
    
    pleasure_pre_both = pleasure(imageCue==3 & prePostCue==1);
    targetInd_pre_both = targetInd(imageCue==3 & prePostCue==1);
    distractorInd_pre_both = distractorInd(imageCue==3 & prePostCue==1);
    
    pleasure_post_one = pleasure(imageCue<3 & prePostCue==2);
    targetInd_post_one = targetInd(imageCue<3 & prePostCue==2);
    
    pleasure_post_both = pleasure(imageCue==3 & prePostCue==2);
    targetInd_post_both = targetInd(imageCue==3 & prePostCue==2);
    distractorInd_post_both = distractorInd(imageCue==3 & prePostCue==2);
    
    %compute errors, average per item
    for im = 1:36
        error_pre_one(idCount,im) = nanmean(abs(pleasure_pre_one(targetInd_pre_one==im) - baselinePleasure(im)));
        error_post_one(idCount,im) = nanmean(abs(pleasure_post_one(targetInd_post_one==im) - baselinePleasure(im)));
        
        % because we counter-balanced the side on which each image is
        % shown, we get the image on the left OR right for both image
        % trials for each participant, not both. We thus compute from the
        % respective trial in which the image is shown at all.
        if sum(targetInd_pre_both==im)>0
            error_pre_both(idCount,im) = nanmean(abs(pleasure_pre_both(targetInd_pre_both==im) - ...
                mean([baselinePleasure(im) baselinePleasure(distractorInd_pre_both(targetInd_pre_both==im))])));
        else
            error_pre_both(idCount,im) = nanmean(abs(pleasure_pre_both(distractorInd_pre_both==im) - ...
                mean([baselinePleasure(im) baselinePleasure(targetInd_pre_both(targetInd_pre_both==im))])));
        end
        
        if sum(targetInd_post_both==im)>0
            error_post_both(idCount,im) = nanmean(abs(pleasure_post_both(targetInd_post_both==im) - ...
                mean([baselinePleasure(im) baselinePleasure(distractorInd_post_both(targetInd_post_both==im))])));
        else
            error_post_both(idCount,im) = nanmean(abs(pleasure_post_both(distractorInd_post_both==im) - ...
                mean([baselinePleasure(im) baselinePleasure(targetInd_post_both(targetInd_post_both==im))])));
        end
        
    end

    idCount = idCount+1;
end

%%
cd([rootdir '/analyses/'])
% the NaN for one participant regarding baseline ratings is problematic, so
% exclude him or her
alpha_pre_one = cronbach(error_pre_one(2:end,:))
alpha_post_one = cronbach(error_post_one([2:11 13],:))
alpha_pre_both = cronbach(error_pre_both(2:end,:))
alpha_post_both = cronbach(error_post_both([2:10 12:13],:))

%% based on these, there's a max. correlation between errors in each task
max_withinOne_corr = sqrt(alpha_pre_one*alpha_post_one)
max_withinBoth_corr = sqrt(alpha_pre_both*alpha_post_both)

max_withinPre_corr = sqrt(alpha_pre_one*alpha_pre_both)
max_withinPost_corr = sqrt(alpha_post_one*alpha_post_both)

%% now we should actually look at these correlations
% those are based on participant-wise mean absolute errors

r_withinOne = corr(nanmean(error_pre_one,2), nanmean(error_post_one,2), 'rows', 'pairwise')
r_withinBoth = corr(nanmean(error_pre_both,2), nanmean(error_post_both,2), 'rows', 'pairwise')

r_withinPre = corr(nanmean(error_pre_one,2), nanmean(error_pre_both,2), 'rows', 'pairwise')
r_withinPost = corr(nanmean(error_post_one,2), nanmean(error_post_both,2), 'rows', 'pairwise')

%% plot these results

figure(1);clf;
subplot(2,2,1)
plot(nanmean(error_pre_one,2), nanmean(error_post_one,2), 'o')
lsline()
hold on
box off
axis square
axis([0 3 0 3])

subplot(2,2,2)
plot(nanmean(error_pre_both,2), nanmean(error_post_both,2), 'o')
lsline()
hold on
box off
axis square
axis([0 3 0 3])

subplot(2,2,3)
plot(nanmean(error_pre_one,2), nanmean(error_pre_both,2), 'o')
lsline()
hold on
box off
axis square
axis([0 3 0 3])

subplot(2,2,4)
plot(nanmean(error_post_one,2), nanmean(error_post_both,2), 'o')
lsline()
hold on
box off
axis square
axis([0 3 0 3])
