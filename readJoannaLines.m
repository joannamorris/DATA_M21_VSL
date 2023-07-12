%specify_path_to_file and name

fileID=fopen('S105.txt','r');
formatSpec='%s %s %s %s\n';
sizeA=[24 Inf];
A=textscan(fileID,formatSpec,sizeA,'Delimiter',',');
fclose(fileID);

bins=1:24;
bin_counts=regexprep(A{2},'# ','');
bin_counts=cellfun(@str2num,bin_counts);