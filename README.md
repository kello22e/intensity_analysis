
## Intensity Analysis for VALA Data

This is a pipeline in R and FIJI to analyze data from either calcium or
voltage data collected on the VALA.

## How To Run The Pipeline

To run the pipeline you need to edit the `parameter.R` and the file
`intensity_analysis.R`, specifically you need to 1) add the path to the
folder where the images from the experiment are 2) what rate you want to
sample at and 3) where you want to save the files to.

``` r
#path to to the Cal520 or Fluovolt folder in each experiment folder
path = "~/Rao_lab_voltage_fluidics_20240516122405/scan/Well__C_009/Cal520"

#path to functions.R file
functions = "~/Documents/GitHub/intensity_analysis/R/startup/functions.R"

#rate at which experiment was acquired
fluovolt = 45
fluo8 = 30

#rate at which you want to sample from the experiment
rate = 6

#paths to FIJI macros used to measure ROIs
macro1 <- "~/Documents/GitHub/intensity_analysis/R/macros/create_stack_measure_all_rois.ijm"

#FIJI path
fiji_executable <- "/Applications/Fiji.app/Contents/MacOS/ImageJ-macosx"

#where you will save files to analyze
move_folder <- "~/FOLDER_WHERE_YOU_WANT_TO_MOVE_FILES"
```

In the `intensity_analysis.R`, you need to edit this line of code below
and change ‘aq_rate’ variable to the correct experiment - either fluo8
or fluovolt.

``` r
#2 --- SAMPLE AT RATE OF CHOICE, MOVE FILE TO NEW FOLDER IN HARD DRIVE
aq_rate = fluo8
sample_rate <- rate
```

After changing the correct parameters, you can highlight the code in
`intensity_analysis.R` and run!

Note that the `echo = FALSE` parameter was added to the code chunk to
prevent printing of the R code that generated the plot.
