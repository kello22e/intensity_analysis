source("/Users/emilykellogg/Documents/GitHub/intensity_analysis/R/parameters.R")
library(stringr)

#NOTE --- CAN ONLY RUN THIS FOR EACH EXPERIMENT AND HAVE TO RUN CELLPOSE FOR EACH 0000000 FILE FIRST --> put in cellpose_masks folder

#CHANGE EVERY TIME YOU DO THIS -- SPECIFY PATH TO THE EXPERIMENT FOLDER
raw_data <- '/Volumes/Seagate Portable Drive/Emily/Adult_CMs_VB_LH_01_20240502125054/scan/Well__C_009/Cal520/'

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
#SET SAMPLE RATE HERE 
sample_rate <- 30 
#SET EXPERIMENT LENGTH
experiment_len <- length(file_list)-1
i <- 0
#loops through the image folder, gets the images at sampling rate and move to the LaCie drive
for(file in file_list){
  
  #gets basename of the file
  basename <- basename(file)
  #checks what number string it is 
  result <- regmatches(basenae, regexpr("\\d{8}", basename))
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

