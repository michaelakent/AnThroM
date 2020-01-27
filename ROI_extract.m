%========================================================================
%     fROI analysis for fmriprep data in BIDS format
%========================================================================
%     This script is written by  Michaela Kent and Ruud Hortensius
%     (University of Glasgow) 
%
%     Last updated: January 2020
%========================================================================
clear all
%add marsbar to path
marsbar('on')

%% Inputdirs
BIDS = spm_BIDS('/Volumes/Project0255/dataset_1'); % parse BIDS directory (easier to query info from dataset)
BIDSsecond=fullfile(BIDS.dir,'derivatives/bids_spm/second_level'); % get the second-level directory

contrastid = 'mental' %can be either mental (vs. pain) or pain (vs. mental)
networkid = 'tom' %can be either tom (theory-of-mind) or pain (pain matrix)

%% Outputdirs
outputdir=fullfile(BIDS.dir,'derivatives/roi', networkid);  % root outputdir for sublist
spm_mkdir(outputdir); % create output directory 

%% Load design matrix
spm_name = spm_load(fullfile(BIDSsecond, filesep, contrastid , 'SPM.mat'))
D  = mardo(spm_name);


%% Load rois
parcels = dir(fullfile(BIDS.dir,'derivatives/parcels/', networkid))
parcels = struct2cell(parcels(arrayfun(@(x) ~strcmp(x.name(1),'.'),parcels)))
parcels(2:6,:) = []

for i=1:length(parcels) 
    roi = fullfile(BIDS.dir,'derivatives/parcels/',  networkid, parcels{i})
    R  = maroi(roi);
    % Fetch data into marsbar data object
    mY  = get_marsy(R, D, 'mean');
    roi_data = summary_data(mY); % get summary time course(s)
    roi_name = [outputdir,filesep,parcels{i},'.tsv'];
    dlmwrite(roi_name,roi_data);
end