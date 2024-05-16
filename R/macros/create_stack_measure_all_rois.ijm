path = getArgument();

//path = "/Volumes/LaCie/VALA_TEST_IMAGES/20240502125054";
files = getFileList(path);

//wanna save as a virtual stack first
sequence = path + File.separator;
//run Image seqeunce import
File.openSequence(sequence, "virtual");
saveAs("Tiff", path + "/20240502125054.tif");

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
