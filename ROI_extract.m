%========================================================================
%     fROI analysis for fmriprep data in BIDS format
%========================================================================
%     This script is written by  Michaela Kent and Ruud Hortensius
%     (University of Glasgow) 
%
%     Last updated: January 2020
%========================================================================

clear all

%% Inputdirs
BIDS = spm_BIDS('/Volumes/Project0255/dataset_1'); % parse BIDS directory (easier to query info from dataset)
BIDSsecond=fullfile(BIDS.dir,'derivatives/bids_spm/second_level'); % get the second-level directory

contrastid = 'pain' %can be either mental (vs. pain) or pain (vs. mental)
networkid = 'pain' %can be either tom (theory-of-mind) or pain (pain matrix)

%% Outputdirs
outputdir=fullfile(BIDS.dir,'derivatives/roi', networkid);  % root outputdir for sublist
spm_mkdir(outputdir); % create output directory 

%% Extract ROI data
designmatrix = spm_load(fullfile(BIDSsecond, filesep, contrastid , 'SPM.mat'))

parcels = dir(fullfile(BIDS.dir,'derivatives/parcels/', networkid))
parcels = struct2cell(parcels(arrayfun(@(x) ~strcmp(x.name(1),'.'),parcels)))
parcels(2:6,:) = []

for i=1:length(parcels) 
    roi = spm_load(fullfile(BIDS.dir,'derivatives/parcels/',  networkid, parcels{i}))
    roi_data = mean(spm_get_data(cellstr(designmatrix.SPM.xY.P),roi.roi_XYZ),2);
    file_mat = [outputdir,filesep,parcels{i},'.tsv'];
    csvwrite(file_mat,roi_data)
end