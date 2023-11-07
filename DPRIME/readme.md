In order to calculate the dprime values for each participant we need to get the numbers of trials in each bin.  We get these from the `ELS_BIN` files.  

Put all the `ELS_BIN` files into a folder called 'el_files'. 

Then extract the bin numbers from the ELS_BIN files using the awk command:

`awk '/^	bin/ {print}' S104_el_2.txt > S104.txt`

To do this for all files, put the command for each file on a separate line in a text file called `extract_binstats_from_elfiles_awk` as follows:

```
#!/bin/bash

# This script extracts the number of events in each bin from the eventlist file.
# The general syntax of awk is:  `awk 'script' filename`

awk '/^	bin/ {print}' S104_el_2.txt > S104.txt
awk '/^	bin/ {print}' S105_el_2.txt > S105.txt
awk '/^	bin/ {print}' S106_el_2.txt > S106.txt

```

This will create a series of `.txt` files with the filenames equal to the subject ID e.g. `S104.txt`,

Then put all the text files into a folder called `d_prime_txt_files`. Then create a list of all the subject IDs in file called `subjlist.txt`.	 Once there, you can use the `scr10_count_bin_trials.m` to get the bin counts for each subject and put them into a file called `m21_bincounts.csv`.  

You can then run the R script called `dprime.R` to calculate the dprime values for each subject and write them to a file called `m21_bincounts.csv_dprime.csv`