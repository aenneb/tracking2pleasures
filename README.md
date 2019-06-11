# tracking2pleasures
Experiment presentation, data and analyses files for the article "Tracking two Pleasures" by Aenne A. Brielmann &amp; Denis G. Pelli

## File specifications
Each .mat file contains the complete data for one particpant
baselineImageInformation.mat contains average valence and arousal ratings from http://www.benedekkurdi.com/#!portfolio/project-4.html as well as average beauty ratings collected by Brielmann & Pelli (PLOS, under review)

The .m files provided allow replication of the analyses reported in Brielmann & Pelli (PBR, submitted) with the addition from some supporting scripts that can be found on MATLAB central. The analyses are numbered in the order the results appear in the manuscript.

Stats_per_participant provides the following values for each participant of the replication study: baseline ratings for each image, SDs of one- and combined-pleasure ratings for pre- and post-cued trials per target rating, median and SD of response times, average parameter values for all tested models.

The folder "experiment presentation files" contains all files and folders (in the appropriate structure) to run the entire experiment using MATLAB (R2018b) and Psychtoolbox.

## Original vs. replication data 
Data files located in the pilot_data folder (with dates from 2017) are part of the initial study with 13 participants. Data files within the replication_data folder (with 2019 dates) are part of a pre-registered (https://osf.io/x9wsf/) replication of this study.

## Recommended folder structure
To run the analysis files as provided here, all files of this repository should be placed in one common folder.
All .mat files should be placed in a subordinate folder 'data/matFiles'
All .m files should be placed in a subordinate folder 'analyses'
