#path to functions.R file
raw_data = "/Volumes/Seagate Portable Drive/Emily/20240516_fluovolt_fluo8_senktide_nkb_SP/Rao_lab_voltage_fluidics_20240516114631/scan/Well__D_002/FluoVolt/"
functions = "/Users/emilykellogg/Documents/GitHub/intensity_analysis/R/startup/functions.R"

#paths to fiji macros used to measure ROIs
macro1 <- "/Users/emilykellogg/Documents/GitHub/intensity_analysis/R/macros/calculate_intensity_from_mask.ijm"
macro2 <- "/Users/emilykellogg/Documents/GitHub/intensity_analysis/R/macros/test_macro.ijm"
macro3 <- "/Users/emilykellogg/Documents/GitHub/intensity_analysis/R/macros/create_stack_measure_all_rois.ijm"

#fiji path
fiji_executable <- "/Applications/Fiji.app/Contents/MacOS/ImageJ-macosx"

#where you will save files to analyze
move_folder <- "/Volumes/LaCie/VALA_TEST_IMAGES"