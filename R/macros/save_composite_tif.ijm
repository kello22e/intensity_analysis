//1 --- ENTER PATH TO YOUR DAPI CHANNEL
path1 = "";

//2 --- ENTER PATH TO FLUOVOLT OR CAL520 CHANNEL - MUST BE AT 00000000 TIME POINT 
path2 = "";

//3 --- ENTER THE PATH TO THE FOLDER YOU WANT TO SAVE YOUR COMPOSITE FILE TO
path3 = "";

//get name of each path
name1 = File.getName(path1);
name2 = File.getName(path2);

//4 --- OPEN EACH IMAGE
//open the DAPI image and the calcium or fluovolt image (first frame)
open(path1);
open(path2);


//5 -- CREATE A COMPOSITE OF THE DAPI AND FLUOVOLT/CAL520 IMAGE
//merge the channels - set the dapi as blue and the fluovolt/cal as green
run("Merge Channels...", "c2="+ name2 + " " + "c3=" + name1 + " create");
//select composite image you just created
selectImage("Composite");

//6 -- SAVE THE COMPOSITE IMAGE TO A FOLDER TO ANALYZE IN CELLPOSE
//save as a .tif file wherever you want
saveAs("Tiff", path3 + name2);
run("Close All");