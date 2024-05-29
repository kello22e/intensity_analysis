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
