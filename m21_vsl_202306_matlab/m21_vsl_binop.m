%% Clear memory and the command window
    clear;
    clc;

  %% Load eeglab
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
  %% Set up variables holding key values 
    DIR = pwd; %Current folder (where the script should be located)
    Bin_Operators       = [DIR '/dprime_equations.txt']; %File that holds difference wave equations for bin operations;     
    erpfile_path        = [DIR '/m21_vsl_erpfiles_202306/'];
    new_erpfile_path    = [DIR  '/m21_vsl_erpfiles_binop/']
    subj_list           = readtable([DIR filesep 'filelist.txt']);  %list containing subjids
    subj_ids            = subj_list.SubjID;
    nsubj               = length(subj_ids);                         % number of subjects

    ALLERP = buildERPstruct([]);
    CURRENTERP = 0;

%% Loop through subjects
    for s=1:nsubj 
        sname = subj_ids{s};
        fprintf('\n******\nProcessing subject %s\n******\n\n', sname);
    
        %Load the starting ERPset from this subject and save it in ALLERP
        fname = [sname '.erp'];
        ERP = pop_loaderp('filename', fname , 'filepath', erpfile_path  );
    
        %Compute hits, misses, correct rejections and false alarms
        ERP = pop_binoperator( ERP, Bin_Operators);

        %Change ERPset name, save the file, and save the filename
        ERP.erpname = [sname '_binop' ];    
    
        ERP = pop_savemyerp(ERP,...
                        'erpname', ERP.erpname,...
                        'filename', [ERP.erpname '.erp'],...
                        'filepath', new_erpfile_path,...
                        'Warning', 'off');

        CURRENTERP = CURRENTERP + 1;

        ALLERP(CURRENTERP) = ERP;

        eeglab redraw;
        erplab redraw;
    
    end  % end of looping through all subjects