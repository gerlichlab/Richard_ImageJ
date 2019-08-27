//create a folder called same as image in the image directory
img_dir=getInfo("image.directory");
print(img_dir);
img_name=getTitle();
splitDir= img_dir  + "\\Scc1_EdU_Hoechst_to40_" +img_name ;
print(splitDir); 
File.makeDirectory(splitDir); 

setBatchMode(true);

// create a dialog window
Dialog.create("Choose your channels");
Dialog.addNumber("Scc1:", 2);
Dialog.addNumber("f-ara-EdU:", 1);
Dialog.addNumber("Hoechst", 3);
Dialog.addNumber("minimal linewidth", 1);
Dialog.addNumber("maximal linewidth", 20);
Dialog.show();
channel_Scc1 = Dialog.getNumber();
channel_EdU = Dialog.getNumber();
channel_Hoechst = Dialog.getNumber();
min_linewidth = Dialog.getNumber();
max_linewidth = Dialog.getNumber();

//count ROIs in manager and get array for all
num_roi=roiManager("count");
ROI_array = newArray("0");;
for (i=1;i<roiManager("count");i++){ 
    ROI_array = Array.concat(ROI_array,i); 
}
print(num_roi);
roiManager("save", splitDir + "\\positions"+ ".zip");
for (linewidth = min_linewidth; linewidth < max_linewidth+1; linewidth=linewidth+1){
	roiManager("select", ROI_array);
	roiManager("Set Line Width", linewidth);
	for (j=0; j<num_roi; j++){ 
		close("Plot of " + img_name);
		selectWindow(img_name);
		roiManager("Select", j );
		//setLineWidth(linewidth);
		Stack.setChannel(3);			//Change to Scc1 channel
		run("Clear Results");
		// Get profile and display values in "Results" window
		profile = getProfile();
		run("Plot Profile");
		Plot.getValues(x, y);
		for (i=0; i<x.length-1; i++){
			setResult("Distance",i,x[i]);
			setResult("Scc1", i, profile[i]);
		}
		close();
		selectWindow(img_name);
		roiManager("Select", j );
		//setLineWidth(linewidth);
		Stack.setChannel(1);			//Change to EdU Channel
		profile = getProfile();
		run("Plot Profile");
		Plot.getValues(x,z);
		for (i=0; i<x.length-1; i++){
			setResult("Distance",i,x[i]);
			setResult("f-ara-EdU", i, profile[i]);
		}
		close();
		selectWindow(img_name);
		roiManager("Select", j );
		//setLineWidth(linewidth);
		Stack.setChannel(4);			//Change to Hoechst Channel
		profile = getProfile();
		run("Plot Profile");
		Plot.getValues(x,z);
		for (i=0; i<x.length-1; i++){
			setResult("Distance",i,x[i]);
			setResult("Hoechst", i, profile[i]);
			setResult("Linewidth", i, linewidth);
		}
		updateResults;
		close();
		save_dir = splitDir + "\\Profilplot_"+ (j+1) + "_Linewidth" +linewidth +".csv";
		saveAs("Measurements",save_dir);
	}
}
roiManager("Deselect");
roiManager("Delete");
close(img_name);
//close();