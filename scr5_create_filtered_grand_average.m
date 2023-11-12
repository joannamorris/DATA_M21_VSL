% This script creates a grand average erp file and then low pass filters it
% at 30 Hz

%% Clear memory and the command window
clear;
clc;

%% Load eeglab, erplab
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
ALLERP = buildERPstruct([]);
%% Set up variables holding key values 
    
    
DIR            = pwd;                                    % Current folder (where the script should be located)
subj_list      = importdata('SEN_SEM.txt');             % list of subject ids
nsubj          = length(subj_list);                      % number of subjects
prompt         = {'Type in the name for your grand average file:'};  %  array specifying the 2 prompts in the dialog box.  Note that braces create a cell array while square brackets create a regualar array.
dlgtitle       = 'Grand average filename';                         % title of dialog box
dims           = [1 70];                          % dimensions of input fields
definput       = {'M21_VSL_GA_SENSITIVE_SEMANTIC'};                      % sample answers as guide for how to enter data
my_input       = inputdlg(prompt,dlgtitle,dims,definput);   % function that gets the input
ga_name        = my_input{1};    
  



%% Load the  ERPsets and make them available in the ERPLAB GUI

for subject = 1:nsubj
    subjID = subj_list{subject};
    erp_DIR = [DIR filesep 'erp_vsl_dprime'];
    fname = [subjID '_vsl_dprime.erp'];

    %% Check to make sure the dataset file exists
       
    if exist([erp_DIR filesep fname], 'file')<=0
        fprintf('\n *** WARNING: %s does not exist *** \n', [erp_DIR filesep fname]);
        fprintf('\n *** Skip all processing for this subject *** \n\n');
    else 
        %% Load erpset
    
        fprintf('\n******\nProcessing subject %s\n******\n\n', subjID);
        ERP = pop_loaderp('filename', fname, 'filepath', erp_DIR);
	    CURRENTERP = CURRENTERP + 1;
        ALLERP(CURRENTERP) = ERP;    
    end
        erplab redraw;
end
%% %Create a grand average ERP waveform from the files listed in ALLERP


ERP = pop_gaverager(ALLERP , ...
                    'Erpsets', 1:nsubj,...
                    'Criterion',100,...
                    'SEM','on',...
                    'Warning', 'on', ...
                    'Weighted', 'on' )
ERP = pop_savemyerp(ERP,...
                    'erpname', ga_name,...
                    'filename', [ga_name '.erp'],...
                    'filepath', DIR , ...
                    'Warning', 'on');
CURRENTERP = CURRENTERP + 1;
ALLERP(CURRENTERP) = ERP; 
erplab redraw;

%% Filter Grand Average Waveform
ERP = pop_filterp(ERP, 1:33 ,...
                  'Cutoff',  30,...
                  'Design', 'butter',...
                  'Filter', 'lowpass',...
                  'Order',  2 );
ERP = pop_savemyerp(ERP,...
                    'erpname', [ga_name '_filt'],...
                    'filename', [ga_name '_filt.erp'],...
                    'filepath', DIR , ...
                    'Warning', 'on');
CURRENTERP = CURRENTERP + 1;
ALLERP(CURRENTERP) = ERP; 

erplab redraw;

