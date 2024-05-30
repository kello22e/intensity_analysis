#1 --- YOU NEED TO CHANGE THIS FILE TO ALL OF THE PATHS THAT YOU NEED
#CHECK SOURCE ON SAVE

#CHANGE THIS PATH - CHANGE TO WHERE THE FLUOVOLT OR CAL520 FOLDER IS
path = ""

#path to functions.R file
functions = "~/Documents/GitHub/intensity_analysis/R/startup/functions.R"

#CHANGE TO TRUE FOR WHATEVER EXPERIMENT YOU DID AND FALSE FOR EXPERIMENT YOU DIDNT DO
fluovolt = FALSE
fluo8 = TRUE

#CHANGE THIS - CHANGE DEPENDING AT WHAT RATE YOU WANT TO SAMPLE AT
#FLUOVOLT is captured at 45 hz and to sample at 5hz sample every 9 frames
#CAL520 is captured at 30 hz and to sample at 5hz sample every 6 frames
rate = 6

#paths to fiji macros used to measure ROIs
macro1 <- "~/Documents/GitHub/intensity_analysis/R/macros/create_stack_measure_all_rois.ijm"

#fiji path - MIGHT NEED TO CHANGE DEPENDING ON COMPUTER TYPE
fiji_executable <- "/Applications/Fiji.app/Contents/MacOS/ImageJ-macosx"

#CHANGE THIS PATH - POINTS TO THE FOLDER YOU WANT TO SAVE TO FOR ANALYSIS
move_folder <- "~/Desktop/VALA_ANALYSIS"
