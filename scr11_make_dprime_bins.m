      %% Clear memory and the command window
    clear;
    clc;
    
    %% Load eeglab
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
 
    %% Initialize the ALLERP structure and CURRENTERP
    ALLERP     = buildERPstruct([]);
    CURRENTERP = 0;

 
   %% This defines the all variables including the Path to the parent folder, which contains the data folders for all subjects
    DIR = pwd;
    erpfolder = [DIR filesep 'vsl_test_erp_category'];
    erp_dprime_folder = [DIR filesep 'erp_vsl_dprime'];
    subjlist = importdata("subjlist2.txt");
    nsubj = length(subjlist); % number of subjects


 %% Loop through all subjects
    for s=1:nsubj

        fprintf('\n******\nProcessing subject %s\n******\n\n', subjlist{s});
        
     
        % Check to make sure the dataset file exists
        fname     = [subjlist{s} '_p2_bin2.erp'];

        if exist([erpfolder filesep fname], 'file')<=0
                fprintf('\n *** WARNING: %s does not exist *** \n', [erpfolder filesep fname]);
                fprintf('\n *** Skip all processing for this subject *** \n\n');
        else 
 
            %% Load erpset
            %
            fprintf('\n\n\n**** %s: Loading erpset ****\n\n\n', subjlist{s});
            EEG = pop_loaderp('filename', fname, 'filepath', erpfolder);
            
            %% Dprime Wave
            % Now we will do bin operations using a set of equations
            % stored in the file 'bin_equations.txt', which must be in
            % the home folder for the experiment

            
            ERP         = pop_binoperator( ERP, [DIR filesep 'm21_bin_equations_dprime_202311.txt']);

            ERP.erpname = [subjlist{s} '_vsl_dprime'];  % name for erpset menu;  eg
            pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', erp_dprime_folder, 'warning', 'off');

       

            % Save this final ERP in the ALLERP structure.  This is not
            % necessary unless you want to see the ERPs in the GUI or if you
            % want to access them with another function (e.g., pop_gaverager)

            CURRENTERP         = CURRENTERP + 1;
            ALLERP(CURRENTERP) = ERP;
            
            
        end % end of the "if/else" statement that makes sure the file exists
        

    end % end of looping through all subjects