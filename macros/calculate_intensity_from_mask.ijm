path = getArgument();
//name = File.getName(path);

//path = "/Volumes/LaCie/VALA_TEST_IMAGES/20240502125054";

files = getFileList(path);

//get name of masks file and open it
//for (i = 0; i < files.length; i++) {
	//title = files[i];
	//if(matches(title, ".*masks.*")){
		//open(files[i]);
	//}
//}

//makes sure that the when measuring the label is included in the results.csv
run("Set Measurements...", "area mean min integrated area_fraction display redirect=None decimal=3");

for (i = 0; i < files.length; i++) {
	current_file = files[i];
	
	open(current_file);
	
	run("Labels To Rois", );
	
	//enter parameters --> should run label to ROIs and then once you select the correct images --> CONTINUE TO MEASURE EACH ROI
	waitForUser("Input Your Parameters");
	
	//loops through each cell ROI and measures the intensity -- ALSO LOGS THE ROI NUMBER
	for (i=0; i<roiManager("Count"); i++) {

		roiManager("Select", i);
		
		//do whatever you like with the ROI, e.g. measure intensity
  		roiManger("Measure");
	}
	
	//unselects all ROIs, deletes all ROIs, closes the ROI manager
	roiManager("deselect");
	roiManager("delete");
	close("ROI Manager");
	
	//closes the current file and moves onto the next image
	close(current_file);
}

selectWindow("Results");
saveAs("Results", path + "/Results.csv");

run("Close All");
