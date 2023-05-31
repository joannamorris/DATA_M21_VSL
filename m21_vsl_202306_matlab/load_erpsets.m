%% Clear memory and the command window
    clear;
    clc;

%% Load eeglab
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;


%% Load the  ERPsets and make them available in the ERPLAB GUI
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
ALLERP = buildERPstruct([]);
for subject = 1:num_subjects
    ID = num2str(SUB(subject));
    Subject_DIR = [Data_DIR ID filesep];
    Subject_filename = [ID ERPset_name '.erp'];
    ERP = pop_loaderp('filename', Subject_filename, 'filepath', Subject_DIR);
	CURRENTERP = CURRENTERP + 1;
    ALLERP(CURRENTERP) = ERP;    
end
erplab redraw;