path = getArgument();
//name = File.getName(path);

//path = "/Volumes/LaCie/VALA_TEST_IMAGES/20240502125054";

//get file list first, then make new folder
files = getFileList(path);


//make a folder for files you have already analyzed
analyzed_folder = path + File.separator + "analyzed";
File.makeDirectory(analyzed_folder);


//FOLDER WHERE CELLPOSE MASKS ARE 
mask_folder = "/Users/emilykellogg/Desktop/cellpose_masks";
masks = getFileList(mask_folder);

//basename of the cellpose mask - KNOW THIS BECAUSE THE MASK IS ALWAYS CREATED FROM 1st FRAME
basename = files[0].substring(0, files[0].lastIndexOf("."));

for (i = 0; i < masks.length; i++) {
	mask = masks[i];

	//check if the basename of the file is there for the correct mask
	if(matches(mask, ".*"+basename+".*")){
		
		//MOVE MASK FILE TO THE CORRECT FOLDER
		// Define the paths
		inputFolder = "/Users/emilykellogg/Desktop/cellpose_masks/";
		outputFolder = path + File.separator;

		// Construct the full paths
		inputPath = inputFolder + mask;
		outputPath = outputFolder + mask; 
		
		// Check if the file exists
		if(File.exists(inputPath)){
			// Copy the file to the correct folder
			File.copy(inputPath, outputPath);
			//print("File moved successfully!");
		} else {
			print("File not found!");
		}
	}
}

for (i = 0; i < files.length; i++) {
	//move the mask file after calculate the number of files in the folder
	current_file = files[i];
	
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
		move = File.rename(inputPath, outputPath);
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
