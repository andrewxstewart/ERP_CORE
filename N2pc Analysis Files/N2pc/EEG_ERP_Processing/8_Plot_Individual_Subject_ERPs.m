%Script #8
%Operates on individual subject data
%Uses the output from Script #7: Average_ERPs.m
%This script loads the low-pass filtered averaged ERP waveforms from Script #7, plots the difference waveforms, parent waveforms, corrected and uncorrected HEOG, and ICA-corrected VEOG,
%and saves pdfs of all of the plots in the graphs folder located within each subjects's data folder.

close all; clearvars;

%Location of the main study directory, based on where this script is saved
%This method of specifying the study directory only works if you run the script; for running individual lines of code, replace the study directory with the path on your computer, e.g.: 
%DIR = /Users/KappenmanLab/ERP_CORE/N2pc
DIR = fileparts(fileparts(mfilename('fullpath'))); 

%List of subjects to process, based on the name of the folder that contains that subject's data
SUB = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40'};	

%**********************************************************************************************************************************************************************

%Set baseline correction period in milliseconds
baselinecorr = '-200 0';

%Set x-axis scale in milliseconds
xscale = [-200.0 800.0   -200:200:800];

%Set y-axis scale in microvolts for the EEG channels for the parent waves
yscale_EEG_parent = [-10.0 25.0   -10:5:25];

%Set y-axis scale in microvolts for the EEG channels for the difference waves
yscale_EEG_diff = [-5.0 5.0   -5:2.5:5];

%Set y-axis scale in microvolts for the ICA-corrected and uncorrected bipolar HEOG channels
yscale_HEOG = [-15.0 15.0   -15:5:15];

%Set y-axis scale in microvolts for the ICA-corrected monopolar VEOG signals and corrected bipolar VEOG signal
yscale_VEOG = [-25.0 25.0   -25:10:25];

%Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
%Loop through each subject listed in SUB
for i = 1:length(SUB)

    %Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    %Load the low-pass filtered averaged ERP waveforms outputted from Script #7 in .erp ERPLAB file format
    ERP = pop_loaderp('filename', [SUB{i} '_N2pc_erp_ar_diff_waves_lpfilt.erp'], 'filepath', Subject_Path);    
    
    %Plot the N2pc contra and ipsi parent waveforms at the key electrode sites of interest (P7/P8, PO7/PO8, PO3/PO4, O1/O2)
    ERP = pop_ploterps( ERP, [4 5], [8:11] , 'Box', [2 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    save2pdf([Subject_Path 'graphs' filesep SUB{i} '_N2pc_Parent_Waves.pdf']);
    close all

    %Plot the N2pc contra-minus-ipsi difference waveform at the key electrode sites of interest (P7/P8, PO7/PO8, PO3/PO4, O1/O2)
    ERP = pop_ploterps( ERP, [1], [8:11] , 'Box', [2 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_diff);
    save2pdf([Subject_Path 'graphs' filesep SUB{i} '_N2pc_Difference_Wave.pdf']);
    close all

    %Plot the N2pc contra and ipsi parent waveforms at all electrode sites
    ERP = pop_ploterps( ERP, [4 5], [1:11] , 'Box', [3 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    save2pdf([Subject_Path 'graphs' filesep SUB{i} '_N2pc_Parent_Waves_All_Channels.pdf']);
    close all

    %Plot the N2pc contra-minus-ipsi difference waveform at all electrode sites
    ERP = pop_ploterps( ERP, [1], [1:11] , 'Box', [3 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_diff);
    save2pdf([Subject_Path 'graphs' filesep SUB{i} '_N2pc_Difference_Wave_All_Channels.pdf']);
    close all
    
    %Load the low-pass filtered averaged parent ERP waveform outputted from Script #7 in .erp ERPLAB file format
    ERP = pop_loaderp('filename', [SUB{i} '_N2pc_erp_ar_lpfilt.erp'], 'filepath', Subject_Path);    

    %Plot the parent (left and right conditions) ICA-corrected and uncorrected bipolar HEOG signals 
    ERP = pop_ploterps( ERP, [1 2], [32 34] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
    save2pdf([Subject_Path 'graphs' filesep SUB{i} '_N2pc_HEOG.pdf']);
    close all
    
    %Plot the parent (left and right conditions) ICA-corrected monopolar VEOG signals and corrected bipolar VEOG signal
    ERP = pop_ploterps( ERP, [1 2], [15 31 33] , 'Box', [2 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
    save2pdf([Subject_Path 'graphs' filesep SUB{i} '_N2pc_VEOG.pdf']);
    close all

%End subject loop
end

%*************************************************************************************************************************************
