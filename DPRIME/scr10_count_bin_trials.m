% This file will give the number of trials in each condition.  
% You should first get a list of the erp files that you want to query and put those in a list.


%% Clear memory and the command window
clear;
clc;


%% specify_path_to_file and name

    %  Path to the parent folder, which contains the data folders for all subjects


DIR = pwd;
file_dir = [DIR filesep 'dprime_txt_files_2'];
A = importdata([DIR filesep 'subjlist.txt']);
nsubj = length(A);

% To expand the size of a matrix repeatedly, such as within a for loop, 
% it is a best practice to preallocate space for the largest matrix 
% you anticipate creating. Without preallocation, MATLAB has to allocate 
% memory every time the size increases, slowing down operations.
% Here we preallocate a matrix with 'nsubj' rows and 24 columns

B = zeros(nsubj,24);

for subject = 1:nsubj

    fileID=fopen([file_dir filesep A{subject} '.txt'],'r');
    formatSpec='%s %s %s %s\n';
    sizeA=[24 Inf];
    C=textscan(fileID,formatSpec,sizeA,'Delimiter',',');
    fclose(fileID);

    bins=1:24;
    bin_counts=regexprep(C{2},'# ','');
    bin_counts=cellfun(@str2num,bin_counts);

    B(subject, 1:24) = bin_counts(:) ; 
end


D = num2cell(B);       % convert the array of bin counts to a cell array
E = horzcat(A, D);     % concatenate with the array of Subj IDs


% convert the combined cell array D to a table 

T = cell2table(E,'VariableNames',{'SubjID','bin1', 'bin2', 'bin3','bin4','bin5',...
                                  'bin6', 'bin7', 'bin8', 'bin9','bin10', 'bin11',...
                                  'bin12', 'bin13', 'bin14', 'bin15', 'bin16',...
                                  'bin17', 'bin18', 'bin19', 'bin20', 'bin21', ...
                                  'bin22', 'bin23', 'bin24'});

% write the combined table T to a .csv file using 'writetable'
 writetable(T,[DIR filesep 'm21_bincounts.csv']);

