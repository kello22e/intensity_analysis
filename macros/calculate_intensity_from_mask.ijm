//path = getArgument();
//name = File.getName(path);

//need to remeber to include / 
path = "/Volumes/LaCie/VALA_TEST_IMAGES/20240502125054";

//get file list first, then make new folder
files = getFileList(path);

//make a folder for files you have already analyzed
analyzed_folder = path + File.separator + "analyzed";
File.makeDirectory(analyzed_folder);


//get name of masks file and open it
for (i = 0; i < files.length; i++) {
	title = files[i];
	if(matches(title, ".*masks.*")){
		//open(path + "/" + files[i]);
	}
}

for (i = 0; i < files.length-1; i++) {
	current_file = files[i+1];
	
	//open(path + "/" + current_file);
	
	run("Labels To Rois");
	
	//enter parameters --> should run label to ROIs and then once you select the correct images --> CONTINUE TO MEASURE EACH ROI
	waitForUser("Input the parameters into the plugin");
	
	//loops through each cell ROI and measures the intensity -- ALSO LOGS THE ROI NUMBER
	for (j=0; j<roiManager("Count"); j++) {

		roiManager("Select", j);
		
		//do whatever you like with the ROI, e.g. measure intensity
  		roiManager("Measure");
	}
	
	//need to also close the Label to ROI thingy
	waitForUser("Hit finish in LabelToROI plugin, then hit OK to continue to next image"); 
	
	//unselects all ROIs, deletes all ROIs, closes the ROI manager
	roiManager("deselect");
	roiManager("delete");
	close("ROI Manager");
	
	//move file you just analyzed to new folder 
	// Define the paths
	inputFolder = path+File.separator;
	outputFolder = analyzed_folder + File.separator;

	// Construct the full paths
	inputPath = inputFolder + current_file;
	outputPath = outputFolder + current_file;

	// Check if the file exists
	if(File.exists(inputPath)){
		// Move the file
		File.rename(inputPath, outputPath);
		//print("File moved successfully!");
	} else {
		print("File not found!");
	}
}

//makes sure that the when measuring the label is included in the results.csv
run("Set Measurements...", "area mean min integrated display redirect=None decimal=3");

//save the results in the correct folder
selectWindow("Results");
saveAs("Results", path + "/Results.csv");

run("Close All");
