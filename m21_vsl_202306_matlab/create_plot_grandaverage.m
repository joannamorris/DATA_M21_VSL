%% Clear memory and the command window
    clear;
    clc;

  %% Load eeglab
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;

%% %Create a grand average ERP waveform from the files listed in ERPset_List
ERP = pop_gaverager(ERPset_List , 'DQ_flag', 1, 'ExcludeNullBin', 'on');
ERP.erpname = Grand_name;    
ERP = pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', DIR, 'Warning', 'off');

%Plot the grand average
bin_list = 1:ERP.nbin; % List of bins to be plotted
chan_list = 1:ERP.nchan-2; % List of channels to be plotted. We're excluding the bipolar EOG channels
baseline_period = '-200 0';
xscale = [-200.0 800.0   -200:200:800]; %Set x-axis scale and tick marks in milliseconds
yscale = [-15.0 15.0   -15:5:15]; %Set y-axis scale and tick marks in microvolts
rows_and_columns = [6 6]; % Number of rows and columns for array of channels in the plot
ERP = pop_ploterps( ERP, bin_list, chan_list, 'Box', rows_and_columns, 'blc', baseline_period, 'Maximize', 'off', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale);