  %% Clear memory and the command window
    clear;
    clc;

  %% Load eeglab
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
  %% Set up variables holding key values 
    
    
    DIR = pwd; %Current folder (where the script should be located)
    bdf_file            = [DIR '/VSL_BDF_PART2.txt'];      % bin descriptor file in 'bdf' folder
    og_setfile_path     = [DIR '/m21_vsl_setfiles_202206/'];               % folder containing original .set files that I'm starting with
    new_setfile_path    = [DIR '/m21_vsl_setfiles_202306/'];               % folder for new .set files that I'm creating
    erpfile_path        = [DIR '/m21_vsl_erpfiles_202306/'];
    reref_file          = [DIR 'reref_eq_brainvision.txt'];  % file with reref equations in 'ch_op' folder
    subj_list           = readtable([DIR '/m21_subjlist.csv']);  %list containing filenames to read it
    subj_ids            = subj_list.SubjID;
    fname_string        = '_p2_flt_rsp_ref_el_bin2'
    nsubj               = length(subj_ids);                         % number of subjects
  
  %% Loop through all subjects
    for s=1:nsubj
        sname = subj_ids{s};
        fprintf('\n******\nProcessing subject %s\n******\n\n', sname);

        fname = [sname fname_string];
        setfilename = [og_setfile_path fname '.set'];               % Get .set filename including path
        fdtfilename = [og_setfile_path fname '.fdt'];

        %% Check to make sure the dataset file exists
        if (exist(setfilename, 'file')<=0|| exist(fdtfilename, 'file')<=0);
                fprintf('\n *** WARNING: %s does not exist *** \n', setfilename);
                fprintf('\n *** Skip all processing for this subject *** \n\n');
        else 
            %% Load Data
            % Load .set file
            %
            fprintf('\n\n\n**** %s: Loading .set file ****\n\n\n', setfilename);
            EEG = pop_loadset(setfilename);
            EEG.setname = sname;
            EEG.datfile = [fname '.fdt']
            [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,...
                                                 'setname',EEG.setname,...
                                                 'save', [new_setfile_path sname '.set'],...
                                                 'gui','off');
            eeglab redraw;

            %% Bin
            % Use Binlister to sort the bins and save with _bins suffix
            % We are assuming that 'binlister_demo_1.txt' is present in the
            % home folder.
            %
            fprintf('\n\n\n**** %s: Running BinLister ****\n\n\n', setfilename);       

            EEG         = pop_binlister( EEG , ...
                                       'BDF'    , bdf_file, ...
                                       'ExportEL',[new_setfile_path sname '_el_2.txt'],...
                                       'IndexEL', 1     , ...
                                       'SendEL2', 'EEG&Text' , ...
                                       'UpdateEEG', 'on',...
                                       'Voutput', 'EEG' );

            EEG.setname = [EEG.setname '_bns'];
            [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,...
                                                 'setname',EEG.setname,...
                                                 'save', [new_setfile_path EEG.setname '.set'],...
                                                 'gui','off');
            eeglab redraw;

            %% Epoch
            % Extracts bin-based epochs (200 ms pre-stim, 800 ms post-stim.
            % Baseline correction by pre-stim window)
            % Then save with _be suffix
            %
            fprintf('\n\n\n**** %s: Bin-based epoching ****\n\n\n', setfilename);

            EEG         = pop_epochbin( EEG , [-200.0  1000.0],  'pre');

            EEG.setname = [EEG.setname '_epc'];
            [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,...
                                                 'setname',EEG.setname,...
                                                 'save', [new_setfile_path EEG.setname '.set'],...
                                                 'gui','off'); 
            % EEG = pop_saveset( EEG, 'filename',[EEG.setname '.set'],'filepath', new_setfile_path);
            eeglab redraw;
%% Artifact detection
            % Then export eventlist just for review
            % Save the processed EEG to disk because the next step will be averaging
            fprintf('\n\n\n**** %s: Artifact detection (moving window peak-to-peak and step function) ****\n\n\n', setfilename);              

            
          %% Artifact detection - Rd. 1
            % Artifact Detection with Moving window peak to peak threshold
            % Step-like artifacts in the VEOG channel           
            % Mark flags 1 and 4 (you must always mark flag 1
            EEG  = pop_artmwppth( EEG ,...
                                 'Channel',  32, ...
                                 'Flag',  [1 3], ...
                                 'Threshold',  70,...
                                 'Twindow', [ 200 798],...
                                 'Windowsize',  200, ...
                                 'Windowstep', 50 );
                             
                             
      %% Artifact detection - Rd. 2
            % Drift-like artifacts in the  scalp channels
            % Threshold = 30 uV; Window width = 400 ms;
            % Window step = 10 ms; Flags to be activated = 1 & 3
            EEG = pop_artstep( EEG , ...
                               'Channel'   ,  1:27        , ... 
                               'Flag'      , [ 1 4]     , ...
                               'Threshold' ,  70        , ...
                               'Twindow'   , [ -200 798], ...
                               'Windowsize',  400       , ...
                               'Windowstep',  10        );

            EEG.setname = [EEG.setname '_ar'];
            [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,...
                                                 'setname',EEG.setname,...
                                                 'save', [new_setfile_path EEG.setname '.set'],...
                                                 'gui','off'); 
            
            EEG  = pop_summary_AR_eeg_detection(EEG, [new_setfile_path sname '_ar_summary.txt']); 
            eeglab redraw;
            
             %% Report percentage of rejected trials (collapsed across all bins)
            artifact_proportion = getardetection(EEG);
            fprintf('%s: Percentage of rejected trials was %1.2f\n', sname, artifact_proportion);
            
             %% Average
            % Only good trials.  Include standard deviation.  Save to disk.
            %
            fprintf('\n\n\n**** %s: Averaging ****\n\n\n', sname);              

            ERP         = pop_averager( EEG, ...
                                       'Criterion'      , 'good', ...
                                       'ExcludeBoundary', 'on', ...
                                       'SEM'            , 'on');
            ERP.erpname = sname;  % name for erpset menu
            pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', erpfile_path, 'warning', 'off');

            

            % Save this final ERP in the ALLERP structure.  This is not
            % necessary unless you want to see the ERPs in the GUI or if you
            % want to access them with another function (e.g., pop_gaverager)

   
         end % end of the "if/else" statement that makes sure the file exists

    end % end of looping through all subjects
