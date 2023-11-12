 % Clear memory and the command window
    clear;
    clc;

 
    % Initialize the ALLERP structure and CURRENTERP
    ALLERP     = buildERPstruct([]);
    CURRENTERP = 0;

 
    % This defines the set of subjects
    subject_list = {'m15_s11',  'm15_s12',  'm15_s13',  'm15_s14',  'm15_s15',  'm15_s16',  'm15_s17',  'm15_s18',  'm15_s19',  'm15_s20',  'm15_s21',  'm15_s22',  'm15_s23',  'm15_s24',  'm15_s25',  'm15_s26',  'm15_s27',  'm15_s28',  'm15_s29',  'm15_s30',  'm15_s31'};
    nsubj        = length(subject_list); % number of subjects

 

    % Path to the parent folder, which contains the data folders for all subjects
    home_path  = 'Z:\PROJECTS\MPH_H\MORPH15\dat\erp\erp_files\';
    
    % Set the save_everything variable to 1 to save all of the intermediate files to the hard drive
    % Set to 0 to save only the initial and final dataset and ERPset for each subject
    save_everything  = 1;

 % Loop through all subjects
    for s=1:nsubj

        fprintf('\n******\nProcessing subject %s\n******\n\n', subject_list{s});
        
        % Path to the folder containing the current subject's data
        % data_path  = [home_path subject_list{s} '/'];

        % Check to make sure the dataset file exists
        % Initial filename = path plus Subject# plus _EEG.set
        sname      = [home_path subject_list{s} '.erp'];

        if exist(sname, 'file')<=0
                fprintf('\n *** WARNING: %s does not exist *** \n', sname);
                fprintf('\n *** Skip all processing for this subject *** \n\n');
        else 
 
            %% Load Data
            % Load original dataset
            %
            fprintf('\n\n\n**** %s: Loading dataset ****\n\n\n', subject_list{s});
            EEG = pop_loaderp('filename', [subject_list{s} '.erp'], 'filepath', home_path);
            
            %% Difference Wave
            % Now we will do bin operations using a set of equations
            % stored in the file 'bin_equations.txt', which must be in
            % the home folder for the experiment

            
            ERP         = pop_binoperator( ERP, [home_path 'm15_diff_eqlist.txt']);

            ERP.erpname = [subject_list{s} '_diff'];  % name for erpset menu;  
            pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', home_path, 'warning', 'off');

       

            % Save this final ERP in the ALLERP structure.  This is not
            % necessary unless you want to see the ERPs in the GUI or if you
            % want to access them with another function (e.g., pop_gaverager)

            CURRENTERP         = CURRENTERP + 1;
            ALLERP(CURRENTERP) = ERP;
            
        end % end of the "if/else" statement that makes sure the file exists

    end % end of looping through all subjects