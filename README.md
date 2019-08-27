# Richard_ImageJ

## transcibe_toTIF

A imageJ macro that automatically saves images to .tif format.
All images need to be put in one folder. The script saves all to a directory of your choice

## Profilplot_Scc1_EdU_Hoechst
A imageJ macro that extracts profileplots along a linescan for three channels, namely Scc1, f-ara-EdU and Hoechst.

Load a multichannel hyperstack picture (after chromatic correction) in ImageJ. 
Draw lineplots in the image. Draw as many lineplots as you wish. Then start the macro
The macro creates a new folder called similar as the image in the image directory. All results for this image are saved there.
It saves the ROI of the lines as a .zip file.
The line profiles are extrated for each line individually in the previous annotated channels. 
The result is saved as a .csv file. The columns are Scc1, f-ara-EdU, Hoechst.
