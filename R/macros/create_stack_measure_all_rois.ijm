path = getArgument();

//path = "/Volumes/LaCie/VALA_TEST_IMAGES/20240502125054";
files = getFileList(path);

//wanna save as a virtual stack first
sequence = path + File.separator;
//run Image seqeunce import
File.openSequence(sequence, "virtual");
saveAs("Tiff", path + "/20240502125054_raw.tif");
run("Bleach Correction", "correction=[Histogram Matching]");
close("Log");
selectImage("DUP_20240502125054");
saveAs("Tiff", path + "/20240502125054_corrected.tif");

//MOVE CELLPOSE MASK TO CURRENT FOLDER
//FOLDER WHERE CELLPOSE MASKS ARE 
mask_folder = "/Users/emilykellogg/Desktop/cellpose_masks";
masks = getFileList(mask_folder);

//basename of the cellpose mask - KNOW THIS BECAUSE THE MASK IS ALWAYS CREATED FROM 1st FRAME
basename = files[0].substring(0, files[0].lastIndexOf("."));

for (i = 0; i < masks.length; i++) {
	mask = masks[i];
	//check if the basename of the file is there for the correct mask
	if(matches(mask, ".*"+basename+".*")){
		// Construct the full paths
		inputPath = mask_folder + mask;
		outputPath = path+ File.separator + mask; 
		
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

//RUN LABEL TO ROI --> wait for use to finish entering information
run("Labels To Rois"); 
//enter parameters --> select new stack from as base and select cp_mask as label image
waitForUser("Hit finish in LabelToROI plugin, then hit OK"); 

//calculate number of ROIs
roi_num = Array.getSequence(roiManager("Count"));
//select all ROIs
roiManager("Select",roi_num);
//measure all ROIs for each frame of the movie
roiManager("Multi Measure");

//set measurements to be mean intensity only
run("Set Measurements...", "mean redirect=None decimal=3");

//save results file to the same folder
selectWindow("Results");
saveAs("Results", path + "/Results.csv");

//closes ROI manager window
//unselects all ROIs, deletes all ROIs, closes the ROI manager
roiManager("deselect");
roiManager("delete");
close("ROI Manager");

//closes all windows
run("Close All");
