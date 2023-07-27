
    fileID=fopen(['S104_el_2.txt'],'r');
    formatSpec='%s %s %s %s\n';
    sizeA=[24 Inf];
    C=textscan(fileID,formatSpec,sizeA,'Delimiter',',');
    fclose(fileID);

    bins=1:24;
    bin_counts=regexprep(C{2},'# ','');
    bin_counts=cellfun(@str2num,bin_counts);

  
