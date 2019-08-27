// opens interactive window to access different Channelnumbers and linewidth
Dialog.create("Choose your channels");
Dialog.addNumber("Scc1:", 2);
Dialog.addNumber("f-ara-EdU:", 1);
Dialog.addNumber("Hoechst", 3);
Dialog.addNumber("linewidth", 5);
Dialog.show();
channel_Scc1 = Dialog.getNumber();
channel_EdU = Dialog.getNumber();
channel_Hoechst = Dialog.getNumber();
linewidth = Dialog.getNumber();

//create a folder called same as image in the image directory
img_dir=getInfo("image.directory");
print(img_dir);
img_name=getTitle();
splitDir= img_dir  + "/Scc1_EdU_Hoechst_" +img_name ;
print(splitDir); 
File.makeDirectory(splitDir); 


setBatchMode(true);
num_roi=roiManager("count");
print(num_roi);
roiManager("save", splitDir + "/positions"+ ".zip");

//Capture lineprofiles for Scc1, Hoechst and f-ara-EdU channel individually
for (j=0; j<num_roi; j++){ 
	close("Plot of " + img_name);
	selectWindow(img_name);
	roiManager("Select", j );
	roiManager("Set Line Width", linewidth);
	Stack.setChannel(channel_Scc1);			//Change to Scc1 channel
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
	roiManager("Set Line Width", linewidth);
	Stack.setChannel(channel_EdU);			//Change to EdU Channel
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
	roiManager("Set Line Width", linewidth);
	Stack.setChannel(channel_Hoechst);			//Change to Hoechst Channel
	profile = getProfile();
	run("Plot Profile");
	Plot.getValues(x,z);
	for (i=0; i<x.length-1; i++){
		setResult("Distance",i,x[i]);
		setResult("Hoechst", i, profile[i]);
	}
	updateResults;
	close();
	save_dir = splitDir + "\\Profilplot_"+ (j+1) + ".csv";
	saveAs("Measurements",save_dir);
}
roiManager("Deselect");
roiManager("Delete");
close(img_name);
//close();