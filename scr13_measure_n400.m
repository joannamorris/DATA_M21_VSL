   %% Clear memory and the command window
    clear;
    clc;
    
     %% Load eeglab
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;

 
    %% Initialize the ALLERP structure and CURRENTERP
    ALLERP     = buildERPstruct([]);
    CURRENTERP = 0;

 
    %% This defines the all variables including the 
    %  Path to the parent folder, which contains the data folders for all subjects

    DIR = pwd;
    erpfolder = 'erpfiles_1';
    subjlist = readtable([DIR filesep 'M21_subjectProfiles_hampshire.csv']);
    interval   = [300 500];
    baseline    = [-200 0];
    bins         = 1:32;
    channels     = 1:27;
    output_fname = [DIR filesep 'm21_vsl_mea_300500_150050.txt']
    format       = 'long'


ALLERP = pop_geterpvalues(subject_list_file, ...
                          interval,bins,channels , ...
                          'Baseline', baseline, ...
                          'Binlabel', 'on', ...
                          'FileFormat',format, ...
                          'Filename', output_fname, ...
                          'Fracreplace', 'NaN', ...
                          'InterpFactor',1, ...
                          'Measure', 'meanbl', ...
                          'Mlabel', 'mean_amp',...
                          'Resolution',3 );





    fprintf('\n\n\n**** FINISHED ****\n\n\n');  