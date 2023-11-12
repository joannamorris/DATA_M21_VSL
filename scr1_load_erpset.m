%% Clear memory and the command window
clear;
clc;

%% Load eeglab
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;

%% This defines the all variables including the Path to the parent folder, which contains the data folders for all subjects
   DIR = pwd;
   erpfolder  = [DIR filesep 'erp_vsl_dprime'];
   subjlist = importdata("subjlist.txt");
   nsubj = length(subjlist); % number of subjects


%% Initialize the ALLERP structure and CURRENTERP
if (CURRENTERP == 0)
    ALLERP = buildERPstruct([]);
end

%Loop through each subject listed in SUB
for i = 1:nsubj

    fprintf('\n******\nProcessing subject %s\n******\n\n', subjlist{i});
        
     
        % Check to make sure the dataset file exists
        fname     = [subjlist{i} '_vsl_dprime.erp'];

        if exist([erpfolder filesep fname], 'file')<=0
                fprintf('\n *** WARNING: %s does not exist *** \n', [erpfolder filesep fname]);
                fprintf('\n *** Skip all processing for this subject *** \n\n');
        else 
    
    
        %Load the ERPsets created in the above steps
        ERP = pop_loaderp('filename', fname, 'filepath', erpfolder);
	
	    % Add the current ERP to ALLERP
	    CURRENTERP = CURRENTERP + 1;
        ALLERP(CURRENTERP) = ERP;
        erplab redraw;
        end
    
end

%Update the GUI so that the ERPs show up in the ERPsets menu
erplab redraw;
