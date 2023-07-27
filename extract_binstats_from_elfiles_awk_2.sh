#!/bin/bash

# This script extracts the number of events in each bin from the eventlist file.
# The general syntax of awk is:  `awk 'script' filename`


awk '/^	bin/ {print}' S201_VSL2_ELS_BIN.txt > S201.txt
awk '/^	bin/ {print}' S202_VSL2_ELS_BIN.txt > S202.txt
awk '/^	bin/ {print}' S203_VSL2_ELS_BIN.txt > S203.txt
awk '/^	bin/ {print}' S204_VSL2_ELS_BIN.txt > S204.txt
