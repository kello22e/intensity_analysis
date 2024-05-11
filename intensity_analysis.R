library(neuronbridger)
library(stringr)

#0 --- CAN ONLY RUN THIS FOR EACH EXPERIMENT AND HAVE TO RUN CELLPOSE FOR EACH 0000000 FILE FIRST --> put in cellpose_masks folder
macro1 = "/Users/emilykellogg/Documents/GitHub/intensity_analysis/macros/calculate_intensity_from_mask.ijm"

#CHANGE EVERY TIME YOU DO THIS -- SPECIFY PATH TO THE CALCIUM CAL50 FOLDER
raw_data = '/Volumes/Seagate Portable Drive/Emily/Adult_CMs_VB_LH_01_20240502125054/scan/Well__C_009/Cal520/'
  
#1 --- CREATE A FOLDER IN A THE LACIE HARD DRIVE
# Extract the number using regular expressions
number <- str_extract(raw_data, "\\d{14}")

# Specify the location for the new folder
new_folder_location <- "/Volumes/LaCie/VALA_TEST_IMAGES"

# Construct the full path for the new folder
new_folder_path <- file.path(new_folder_location, number)

#check if folder exists, if not, make the folder
if(!(dir.exists(new_folder_path))){
  dir.create(new_folder_path)
}

#get the well number
well_number <- gsub(".*Well__C_(\\d+)/.*", "\\1", raw_data)

#2 --- SAMPLE AT 0.5s EACH TIME POINT, MOVE FILE TO NEW FOLDER IN HARD DRIVE
for(i in seq(0, 2699, 30)){
  original_string <- '00000000'
  # Convert to number, add i, convert back to string
  new_number <- as.numeric(original_string) + i
  new_string <- sprintf("%08d", new_number)
  
  #set current file
  #NEED TO FIX THIS - has to change basedo n well
  currentfiles = paste(raw_data,'Cal520__C_',well_number,'_r_0004_c_0005_t_', new_string, '_z_0000.tif',sep = "")
  #tell where file should go
  file.copy(from=currentfiles, to=new_folder_path, overwrite = TRUE, recursive = FALSE, copy.mode = TRUE)
}

#2.5 --- MOVE THE MASK CREATED IN CELLPOSE TO CORRECT FOLDER 
#where the masks will be
masks = '/Users/emilykellogg/Desktop/cellpose_masks'

#create strings to match mask name
file_name = gsub("00002700", "00000000", basename(currentfiles))
new_file <- gsub(".tif", "_cp_masks.png", file_name)

#loop through files in the folder to find correct one, then move
for(x in masks){
  path = paste(masks,"/",x,sep="")
  if(grepl(x, new_file)){
    file.copy(from=x, to=new_folder_path, overwrite = TRUE, recursive = FALSE, copy.mode = TRUE)
  }
}

#define the folder where the sampled files are
var = new_folder_path 
  
#3 --- CALL FIJI MACROS TO DO FLUORESCENCE CALCULATIONS
fiji.path = neuronbridger:::fiji()
neuronbridger:::runFijiMacro(macro = macro1, 
                              macroArg = var, 
                              headless = FALSE,
                              batch = FALSE,
                              MinMem = "100m",
                              MaxMem = "25000m",
                              IncrementalGC = TRUE,
                              Threads = NULL,
                              fijiArgs = NULL,
                              javaArgs = NULL, 
                              fijiPath = fiji.path,
                              DryRun = FALSE)
