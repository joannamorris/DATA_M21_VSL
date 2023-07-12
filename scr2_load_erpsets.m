%% Clear memory and the command window
    clear;
    clc;

%% Load eeglab
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    ALLERP = buildERPstruct([]);
%% Set up variables holding key values 
    
    
DIR            = pwd;                                    % Current folder (where the script should be located)
subj_list      = importdata('subjlist.txt');             % list of subject ids
num_subjects   = length(subj_list);                      % number of subjects
  


%% Load the  ERPsets and make them available in the ERPLAB GUI

for subject = 1:num_subjects
    subjID = subj_list{subject};
    Subject_DIR = [DIR filesep subjID];
    filename = [subjID '.erp'];
    ERP = pop_loaderp('filename', filename, 'filepath', Subject_DIR);
	CURRENTERP = CURRENTERP + 1;
    ALLERP(CURRENTERP) = ERP;    
end
erplab redraw;