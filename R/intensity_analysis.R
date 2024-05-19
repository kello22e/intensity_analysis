library(stringr)
source("/Users/emilykellogg/Documents/GitHub/intensity_analysis/R/parameters.R")
source(functions)

#NOTE --- CAN ONLY RUN THIS FOR EACH EXPERIMENT AND HAVE TO RUN CELLPOSE FOR EACH 0000000 FILE FIRST --> put in cellpose_masks folder

#CHANGE EVERY TIME YOU DO THIS -- SPECIFY PATH TO THE EXPERIMENT FOLDER
raw_data <- '/Volumes/Seagate Portable Drive/Emily/20240516_fluovolt_fluo8_senktide_nkb_SP/Rao_lab_voltage_fluidics_20240516114631/scan/Well__C_002/FluoVolt/'

#get all of the files in the experiment folder
file_list <- list.files(raw_data, full.names = TRUE)
  
#1 --- CREATE A FOLDER IN A THE LACIE HARD DRIVE - NAMED AFTER THE DATE NUMBER STRING
# Extract the number using regular expressions
number <- str_extract(raw_data, "\\d{14}")

# Specify the location for the new folder
new_folder_location <- move_folder

# Construct the full path for the new folder
new_folder_path <- file.path(new_folder_location, number)

#check if folder exists, if not, make the folder
if(!(dir.exists(new_folder_path))){
  dir.create(new_folder_path)
}

#2 --- SAMPLE AT 1s EACH TIME POINT, MOVE FILE TO NEW FOLDER IN HARD DRIVE
#SET EXPERIMENT SAMPLE RATE HERE 
#30 hz for Fluo8
#45 hz for FluoVolt
aq_rate = 45
#SET SAMPLE RATE FOR ANALYSIS - sample every 30 frames for example which means every 1 second (1hz)
# --- Sample every 15 frames --> which means twice every second (2hz)
sample_rate <- 9 
#SET EXPERIMENT LENGTH
# Remove files with .xml extension
file_list <- file_list[!grepl("\\.xml$", file_list)]
experiment_len <- length(file_list)
i <- 0

#loops through the image folder, gets the images at sampling rate and move to the LaCie drive
for(file in file_list){
  #checking the 8 digit number in the file name --> corresponds to frame of the experiment
  #gets basename of the file
  base <- basename(file)
  #checks what number string it is 
  result <- regmatches(base, regexpr("\\d{8}", base))
  image_num = as.numeric(result)
  
  #checks if the image is the correct number
  if(i == image_num){
    file.copy(from=file, to=new_folder_path, overwrite = TRUE, recursive = FALSE, copy.mode = TRUE)
    
    #if you have moved an image, then you look for the next image in the sequence so add
    if(i < experiment_len){
      i = i + sample_rate
    }
  }
}

#3 --- CALL FIJI MACROS TO DO FLUORESCENCE CALCULATIONS
#Sys.setenv(PATH=paste(Sys.getenv("PATH"), "/the/bin/folder/of/bedtools", sep=":"))
command <- paste(fiji_executable, "-macro", macro3, new_folder_path)
system(command)

#you might actually have to click stop because the macro will be perceived as hanging but im not 100% sure

#harder if you dont have even numbers, might not work unless you do 1 hz or like experimental rate
hz = aq_rate/sample_rate 

#when done, calculate the DFF
calculate_DFF(new_folder_path,hz)

