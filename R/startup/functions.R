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