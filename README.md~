# VNet
https://sagarhukkire.github.io/Vnet-Cafffe_Guide/
#################################################################################################
- Step 1: Install Dependencies and Libraries 
+ Run CaffeInstallation.sh and PythonLibraryInstallation.sh (Order of which to run first does not matter)

+ To run the 2 files, open up a Terminal, locate the file, and type:
			./filename.sh 
in order to execute the command that download and install dependencies

###################################################################################################
- Step 2: Running the Network and Detecting the ON and OFF surfaces 
+ First, put all the images to be processed (STD Tiff stacks of chAT Bands) into the ImagesHere folder.

+ Then, open Matlab and run the script RunMe.m

+ After the Matlab script has finished running, the 2 chAT surfaces will be stored in SurfacesDectected Folder, plus a Tiff file containing the Network prediction overlay on top of the Original Tiff file.

+ Manually verify that the overlays are correct. If yes, import the 2 chAT surfaces, stored as filename_ON.mat and filename_OFF.mat into Sumbul RGC code to continue with the Warping step.

+ These two .mat files contain the 2 surfaces that would have been returned by Sumbul's firSurfaceToSACAnnotation function.

######################################################################################################
- Step 3: Clean Up
+ Make sure to delete or remove the images in ImageHere so that you can use the network again with other images.

+ Delete all the Detected Surfaces in DetectedSurfaces that are no longer needed also.

+ Delete all the Tiff files from ResultsON and ResultsOFF folder as well, if no longer needed,

########################################################################################################
Notes: In the case where the overlays are not correct, manually annotated the data, and store the Annotated files (xls or txt format) in the VNet/Dataset/Annotations folder so that the network can train itself with the new data.


 

 
 



 

