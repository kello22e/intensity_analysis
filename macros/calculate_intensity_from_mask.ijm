path = getArgument();
//name = File.getName(path);

//path = "/Volumes/LaCie/VALA_TEST_IMAGES/20240502125054";

files = getFileList(path);

//get name of masks file
for (i = 0; i < files.length; i++) {
	title = files[i];
	if(matches(title, ".*masks.*")){
		open(files[i]);
	}
}

for (i = 0; i < files.length; i++) {
	current_file = files[i];
	
	open(current_file);
	
	run("Labels To Rois", );
	
	//enter parameters --> should run label to ROIs and then once you select the correct images, save CSV
	waitForUser("Input Your Parameters");
	
	close(current_file);
}

run("Close All");
