
# Intensity Analysis for VALA Data

This is a pipeline in R and FIJI to analyze data from either calcium or
voltage data collected on the VALA.

## Use Cellpose to Generate ROIs

To create ROIs to measure each cell at time points of choice, use
[cellpose](https://www.cellpose.org/) to generate the ROIs. Follow the
instructions for installation on the [github
page](https://github.com/mouseland/cellpose). Once installed, to run
cellpose, open the terminal and type the following command.

``` c
conda activate cellpose
```

Then run the next command to open the GUI

``` c
cellpose
```

##### Use FIJI Macro to Generate Composite Images

The images to run cellpose on should be composite images of the DAPI
channel and the first frame of the experiment (should have the numbers
0000000 in the name as it is the first frame). You can use the FIJI
macro `save_composite_tif.ijm` to generate these images for you. You
will need to edit the first 3 lines in this macro to run it.

``` javascript
//1 --- ENTER PATH TO YOUR DAPI CHANNEL
path1 = "";

//2 --- ENTER PATH TO FLUOVOLT OR CAL520 CHANNEL - MUST BE AT 00000000 TIME POINT 
path2 = "";

//3 --- ENTER THE PATH TO THE FOLDER YOU WANT TO SAVE YOUR COMPOSITE FILE TO
path3 = "";
```

### Back to Cellpose

After saving this composite image, drag and drop it into the cellpose
GUI. You can try to train a model on your cells by following the
cellpose
[instructions](https://cellpose.readthedocs.io/en/latest/gui.html). The
built in model is also pretty good so you can also use that. To get the
best results, first run the ‘calibrate’ for the cell diameter and then
run ‘cyto3’. Finally, manually edit the ROIs by eye.

<img src="inst/images/cellpose_instructions.png" width="348" />

## How To Run The Pipeline

To run the pipeline you need to edit the `parameter.R` and the file
`intensity_analysis.R`, specifically you need to 1) add the path to the
folder where the images from the experiment are 2) what rate you want to
sample at and 3) where you want to save the files to.

``` r
#CHANGE THIS LINE
path = "~/scan/Well__C_009/Cal520"

#path to functions.R file
functions = "~/Documents/GitHub/intensity_analysis/R/startup/functions.R"

#CHANGE TO TRUE FOR WHATEVER EXPERIMENT YOU DID AND FALSE FOR EXPERIMENT YOU DIDNT DO
fluovolt = FALSE
fluo8 = TRUE

#CHANGE THIS LINE
rate = 6

#paths to FIJI macros used to measure ROIs
macro1 <- "~/Documents/GitHub/intensity_analysis/R/macros/create_stack_measure_all_rois.ijm"

#FIJI path
fiji_executable <- "/Applications/Fiji.app/Contents/MacOS/ImageJ-macosx"

#CHANGE THIS LINE
move_folder <- "~/FOLDER_WHERE_YOU_WANT_TO_MOVE_FILES"
```

After changing the correct parameters, you can highlight the code in
`intensity_analysis.R` and run!

## Walkthrough of What’s Happening

The pipeline takes images from the folder where your experimental images
are and moves them to a new folder (at the sampling rate that you
defined). For example, if you acquired the images at 45hz (45 frames per
sec) then if you want to sample at 5hz (or 5 frames per second), your
defined rate should be 9 (which would grab every 9 frames).

Next, the pipeline runs the FIJI macro
`create_stack_measure_all_rois.ijm`. This macro opens all of the files
you moved as a virtual stack and then runs a photobleaching algorithmn
on the virtual stack. The code then saves both images as virtual stacks
to the same folder where the moved images are.

<img src="inst/images/folder%20example.png" width="432" />

Next the code, moves the cellpose mask you created from the folder you
define (see below) and moves it to the folder where your moved images
are. **NOTE: The code will only recognize the naming convention where
the mask has the name of the the first image of your experiment (should
have 00000000 to signify the first frame) followed by ‘\_cp_mask.png’**

``` javascript
//CHANGE THIS LINE OF CODE IN THE FIJI.IJM TO SPECIFY WHERE THE CELLPOSE MASKS ARE
mask_folder = "~/Desktop/cellpose_masks"; 
masks = getFileList(mask_folder);
```

Next, the code runs the [LabelsToROI](https://labelstorois.github.io/)
FIJI plugin. This will open the LabelsToROI gui and prompt the user to
enter the correct images.

**See steps below to select the correct images**

1.  Select ‘Single Image’

    <img src="inst/images/single_image.png" width="271" />

2.  For ‘Path to original image’ select the bleach corrected virtual
    stack should have the ending ‘\_corrected.tif’

3.  For ‘Path to label image’ select the cellpose mask that should have
    the ending ‘\_cp_mask.png’

4.  Hit ‘Next’ on the GUI

    <img src="inst/images/image_select_and_next.png" width="271" />

5.  **Wait for the GUI to run and open the virtual stack with the ROIs
    overlayed**

    <img src="inst/images/overlayedROI.png" width="262" />

6.  Finally, hit ‘OK’ on the ‘Action Required’ panel

    <img src="inst/images/prompt.png" width="380" />

Finally, the code will run and generate a .csv file that has the
measurements of the [mean
intensity](https://forum.image.sc/t/how-does-imagej-calculate-intensity-mean-gray-value/11874)
of each ROI at every time point. The macro will automatically quit and
proceed to the next steps.

Finally, the code runs 2 functions. The first function calculates the
delta F/F and takes the average fluorescence of the baseline (5 seconds)
and subtracts that from all measurements. The second function calculates
the time at every measurement.

``` r
#calculates the delta F/F
calculate_DFF(new_folder_path,hz)

#calculates the time at every measurement
write_time(dff_file)
```

The code is shown below and outputs 2 different .csv files
**‘DFF_data.csv’** and **‘DFF_data_modified.csv’** where the
**‘DFF_data.csv’** is the calculated delta F/F values and the
’**DFF_data_modified.csv’** is the file with the calculated time in the
first column.
