%% Clear memory and the command window
clear;
clc;

%% Load eeglab
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;


%% Set up variables holding key values
DIR = pwd; %Current folder (where the script should be located)
subj_list   = readtable([DIR filesep 'filelist.txt']);  %list containing subjids
subj_ids    = subj_list.SubjID;
nsubj       = length(subj_ids); Grand_name = 'grand_vsl'; %ERPset name for grand average
Grand_name  = 'grand_vsl'; %ERPset name for grand average
ERPset_fileList = 'm21_vsl_binop_erpfilelist.txt';
Grand_name  =  'm21_vsl_grandaverage'



%% %Create a grand average ERP waveform from the files listed in ERPset_List


ERP = pop_gaverager( [DIR '/m21_vsl_binop_erpfilelist.txt'] , 'DQ_flag',...
 0);
ERP = pop_savemyerp(ERP, 'erpname', Grand_name, 'filename', 'm21_vsl_ga.erp', 'filepath',...
 DIR, 'Warning', 'on');



