//1 ---- GET ARGUMENTS SENT IN FROM R 
// argument should be the folder where you moved all of your files
path = getArgument();
name = File.getName(path)
files = getFileList(path);

//gets the base name of the first file without the .tif
base = files[0].substring(0, files[0].lastIndexOf("."));

//2 --- MAKE A VIRTUAL STACK OF THE EXPERIMENT
sequence = path + File.separator;
//run Image seqeunce import
File.openSequence(sequence, "virtual");
selectImage(name);
saveAs("Tiff", sequence + name + ".tif");

//3 --- CONDUCT BLEACH CORRECTION - SELECT BLEACH CORRECTION METHOD BELOW
//run("Bleach Correction", "correction=[Simple Ratio]");
run("Bleach Correction", "correction=[Exponential Fit]");
//run("Bleach Correction", "correction=[Simple Ratio]");
selectImage("DUP_" + name + ".tif");
saveAs("Tiff", sequence + name + "_corrected.tif");
close("Log")
run("Close All");

//4 --- MOVE MASK FILE TO THE FOLDER ON THE LACIE DRIVE
mask_folder = "~/Desktop/cellpose_masks"; //WHERE YOUR CELLPOSE MASK FILES ARE
masks = getFileList(mask_folder);

//loop through the cp_masks and get the one that matches the 00000000 file (i.e the 'base' name file)
for (i = 0; i < masks.length; i++) {
	mask = masks[i];

	//check if the basename of the file is there for the correct mask
	if(matches(mask, ".*"+base+".*")){

		// Construct the full paths
		inputPath = mask_folder + File.separator + mask;
		outputPath = path + File.separator + mask; 
		
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

//5 --- APPLY CELLPOSE MASK TO THE EXPERIMENT VIRTUAL STACK AND CALCULATE FLUORESCENCE
//RUN LABEL TO ROI --> wait for use to finish entering information
run("Labels To Rois"); 

//enter parameters --> select new stack from as base and select cp_mask as label image
waitForUser("Select virtual stack you just made and the cp_mask, hit next, then hit OK to continue"); 

//calculate number of ROIs
roi_num = Array.getSequence(roiManager("Count"));
//select all ROIs
roiManager("Select",roi_num);
//measure all ROIs for each frame of the movie
roiManager("Multi Measure");

//set measurements to be mean intensity only
run("Set Measurements...", "mean redirect=None decimal=3");

//5.5 --- SAVE THE RESULTS FOR EACH ROI TO THE SAME FOLDER
selectWindow("Results");
saveAs("Results", path + "/Results.csv");
close("Results");

//6 --- CLOSE THE MACRO AND QUIT TO GO BACK TO R
//close the macro
roiManager("deselect");
run("Quit");

