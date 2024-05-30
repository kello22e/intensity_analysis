#import necessary libraries
library(stringr)
library(writexl)

#change code to tell it where the parameters.R files is
source("~/Documents/GitHub/intensity_analysis/R/parameters.R")
source(functions)

# --- NOTES ---
#CAN ONLY RUN THIS FOR 1 EXPERIMENT AND HAVE TO RUN CELLPOSE FOR EACH 0000000 FILE FIRST 
#PUT CELLPOSE MASKS IN A FOLDER DEFINED BY USER --> NEED TO CHANGE THE MACRO1 TO TELL IT WHERE THIS FOLDER IS 
#RUN 'save_composite_tiff.ijm' TO CREATE COMPOSITE TO ANALYZE IN CELLPOSE

#CHANGE EVERY TIME YOU DO THIS -- SPECIFY PATH TO THE EXPERIMENT FOLDER
raw_data <- path

#get all of the files in the experiment folder
file_list <- list.files(raw_data, full.names = TRUE)

#1 --- CREATE A NEW FOLDER IN A FOLDER OF YOUR CHOICE - NAMED AFTER WELL # AND DATE NUMBER STRING
new_folder_path <- make_destination_folder(raw_data, move_folder)

#2 --- SAMPLE AT RATE OF CHOICE, MOVE FILE TO NEW FOLDER IN HARD DRIVE
#set experiment in parameters.R --> if calcium fluo8 = TRUE, if voltage fluovolt = TRUE 
if(fluo8){
  aq_rate = 30
}elseif(fluovolt){
  aq_rate = 45
}

#SET RATE AT WHICH YOU WANT TO SAMEPLE FOR ANALYSIS - set in parameters.R
sample_rate <- rate

#SET EXPERIMENT LENGTH - EQUALS # OF FILES IN THE FOLDER
# Remove files with .xml extension
file_list <- file_list[!grepl("\\.xml$", file_list)]

#2.5 --- CALL THE MOVE FILES FUNCT, MOVES FILES FROM EXPERIMENT FOLDER TO NEW FOLDER AT SAMPLE RATE
move_files(file_list, new_folder_path, sample_rate)

#3 --- CALL FIJI MACROS TO DO FLUORESCENCE CALCULATIONS
#NOTE = the sys.setenv (command below) might need to be run if it throws and error the first time, should only have to run once
#Sys.setenv(PATH=paste(Sys.getenv("PATH"), "/the/bin/folder/of/bedtools", sep=":"))
command <- paste(fiji_executable, "-macro", macro1, new_folder_path)
system(command)

#4 --- CALCULATE THE DELTA F/F
#harder to calculate hz if you dont have even number
hz = aq_rate/sample_rate 
#calculate DFF, average the first 5 seconds as baseline 
calculate_DFF(new_folder_path,hz)

#5 --- EDIT DELTA F/F FILE SO THE FIRST COLUMN IS TIME 
#List all files in the directory
all_files <- list.files(path = new_folder_path, full.names = TRUE)

# find the "DFF_data.csv"
dff_file <- grep("DFF_data.csv", all_files, value = TRUE)
#change the dff file so that the first column is the time
write_time(dff_file)
