%% Clear memory and the command window
    clear;
    clc;

%% Load eeglab
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    ALLERP = buildERPstruct([]);
%% Set up variables holding key values 
    
    
DIR            = pwd;                                    % Current folder (where the script should be located)
erp_dir        = 'm21_vsl_erpfiles_dprime';
subj_list      = importdata('subjlist.txt');             % list of subject ids
num_subjects   = length(subj_list);                      % number of subjects
  


%% Load the  ERPsets and make them available in the ERPLAB GUI

for subject = 1:num_subjects
    subjID = subj_list{subject};
    filename = [subjID '_dprime.erp'];

    %% Check to make sure the dataset file exists
    if (exist([DIR filesep erp_dir filesep filename], 'file')<=0);
        fprintf('\n *** WARNING: %s does not exist *** \n', filename);
        fprintf('\n *** Skip all processing for this subject *** \n\n');
    else 

        ERP = pop_loaderp('filename', filename, 'filepath', [DIR filesep erp_dir]);
	    CURRENTERP = CURRENTERP + 1;
        ALLERP(CURRENTERP) = ERP;  
    end % end of the "if/else" statement that makes sure the file exists

end % end of looping through all subjects
erplab redraw;