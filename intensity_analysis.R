library(neuronbridger)
library(stringr)

macro1 = "/Users/emilykellogg/Documents/GitHub/intensity_analysis/macros/calculate_intensity_from_mask.ijm"

#CHANGE EVERY TIME YOU DO THIS -- SPECIFY PATH TO THE CALCIUM CAL50 FOLDER
raw_data = '/Volumes/Seagate Portable Drive/Emily/Adult_CMs_VB_LH_01_20240502125054/scan/Well__C_009/Cal520/'
  
#1 --- CREATE A FOLDER IN A THE LACIE HARD DRIVE
# Extract the number using regular expressions
number <- str_extract(raw_data, "\\d{14}")

# Specify the location for the new folder
new_folder_location <- "/Volumes/LaCie/VALA_TEST_IMAGES"

# Construct the full path for the new folder
new_folder_path <- file.path(new_folder_location, 'test')

#check if folder exists, if not, make the folder
if(!(dir.exists(new_folder_path))){
  dir.create(new_folder_path)
}

#2 --- SAMPLE AT 0.5s EACH TIME POINT, MOVE FILE TO NEW FOLDER IN HARD DRIVE
for(i in seq(0, 2699, 30)){
  original_string <- '00000000'
  # Convert to number, add i, convert back to string
  new_number <- as.numeric(original_string) + i
  new_string <- sprintf("%08d", new_number)
  
  #set current file
  currentfiles = paste(raw_data,'Cal520__C_009_r_0004_c_0005_t_', new_string, '_z_0000.tif',sep = "")
  #tell where file should go
  newlocation = '/Volumes/LaCie/VALA_TEST_IMAGES'
  file.copy(from=currentfiles, to=newlocation, overwrite = TRUE, recursive = FALSE, copy.mode = TRUE)
}


to_process = list.files('/Volumes/LaCie/VALA_TEST_IMAGES', full.names = TRUE)
  
#3 --- CALL FIJI MACROS TO DO FLUORESENCE CALCULATIONS
for (var in to_process) {
  
  #puts all of the files in the correct folder
  fiji.path = neuronbridger:::fiji()
  runMacro(macro = macro1, 
           macroArg = var, 
           headless = FALSE,
           batch = FALSE,
           MinMem = "100m",
           MaxMem = "25000m",
           IncrementalGC = TRUE,
           Threads = NULL,
           fijiArgs = NULL,
           javaArgs = NULL, 
           ijArgs = NULL,
           fijiPath = fiji.path,
           DryRun = FALSE)
}