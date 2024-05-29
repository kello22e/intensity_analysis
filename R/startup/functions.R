#calculates the deltaF/F
calculate_DFF <- function(path,sample_rate){
  # Import the spreadsheet
  data <- read.csv(paste(path,"/Results.csv",sep=""), header = TRUE)
  
  # Calculate the baseline fluorescence for each cell (column)
  # Stim happens at 5s 
  baseline <- apply(data[1:(5*sample_rate),], 2, mean)

  # Subtract the baseline from every row
  data_corrected <- data
  for (i in 1:ncol(data)) {
    data_corrected[, i] <- data[, i] - baseline[i]
  }
  
  #Write the corrected data back to a new spreadsheet
  write.csv(data_corrected, paste(path,"/DFF_data.csv",sep=""), row.names = FALSE)
}

#calculates the time point of each frame
write_time <- function(path){
  
  # Read the CSV file
  data <- read.csv(path, header = TRUE)
  
  # Calculate the number of frames per second
  # Assuming the first column is the number of frames
  num_frames <- nrow(data)
  experiment_duration <- 90  # seconds
  frames_per_second <- num_frames / experiment_duration
  
  # Create a new column for time in seconds
  data$Time <- (0:(num_frames-1)) / frames_per_second
  
  # Replace the first column with the new time column
  data <- data[, -1]  # Remove the original first column
  data <- cbind(Time = data$Time, data)
  
  # Write the modified data back to a new CSV file
  #output_path <- paste(path,"_modified_data.csv",sep = "")
  output_path <- gsub("DFF_data.csv$", "DFF_data_modified.csv", path)
  write.csv(data, output_path, row.names = FALSE)
  
  # If you want to replace the original file
  #write.csv(data, path, row.names = FALSE)
}

move_files <- function(file_list, new_folder_path){
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
      #ADDED CODE IF YOU WANT TO MAKE PNG FILES
      # Extract the base name without extension
      #file_base_name <- tools::file_path_sans_ext(basename(file))
      
      # Construct the new file path with .png extension
      #new_file_path <- file.path(new_folder_path, paste0(file_base_name, ".png"))
      
      # Copy the file to the new location with the new extension
      #file.copy(from = file, to = new_file_path, overwrite = TRUE, recursive = FALSE, copy.mode = TRUE)
      file.copy(from=file, to=new_folder_path, overwrite = TRUE, recursive = FALSE, copy.mode = TRUE)
      
      #if you have moved an image, then you look for the next image in the sequence so add
      if(i < experiment_len){
        i = i + sample_rate
      }
    }
  }
}

make_destination_folder <- function(raw_data, move_folder){
  # Extract the number using regular expressions
  number <- str_extract(raw_data, "\\d{14}")
  well_part <- str_extract(raw_data, "Well__[A-Z]_[0-9]{3}")
  new_folder_name <- paste0(number, "_", well_part,sep="")
  
  # Specify the location for the new folder
  new_folder_location <- move_folder
  
  # Construct the full path for the new folder
  new_folder_path <- file.path(new_folder_location, new_folder_name)
  
  #check if folder exists, if not, make the folder
  if(!(dir.exists(new_folder_path))){
    dir.create(new_folder_path)
  }
  
  return(new_folder_path)
}
