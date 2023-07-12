%% Clear memory and the command window
clear;
clc;

%% Load eeglab
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;

%% Specify working directory
DIR = pwd;

ALLERP = buildERPstruct([]);
CURRENTERP = 0

%% Load grand average waveform
ERP = pop_loaderp('filename', 'm21_vsl_grandaverage.erp', 'filepath', DIR);
CURRENTERP = CURRENTERP + 1;
ALLERP(CURRENTERP) = ERP;    
erplab redraw;

%% Plot Grand Average Waveform

ERP = pop_ploterps( ERP, [ 25 26 29 30 33 34], [ 3 2 25 7 20 21 12 11 16] , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc',...
 '-100  100', 'Box', [ 3 3], 'ChLabel', 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec',...
 {'k-' , 'k-.' , 'b-' , 'b-.' , 'r-' , 'r-.' }, 'LineWidth',  1, 'Maximize', 'on', 'Position', [ 68.6429 15.0714 106.857 31.9286], 'Style',...
 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale', [ -200.0 600.0   -200:100:600 ], 'YDir', 'reverse' );