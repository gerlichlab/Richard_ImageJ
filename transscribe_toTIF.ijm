// "BatchProcessFolders"
//
// This macro batch transcribes all files in a folder and any
// subfolders in that folder from to tifs. In this example, it runs the Subtract 
// Background command of TIFF files. For other kinds of processing,
// edit the processFile() function at the end of this macro.

requires("1.33s"); 
sourcedir = getDirectory("Choose a source Directory ");
DirSave = getDirectory("Choose a Destination Folder.");
setBatchMode(true);
count = 0;
countFiles(sourcedir);
n = 0;
openFiles(sourcedir);
//print(count+" files processed");
while (nImages>0) {
	originalName = getTitle();
	run("Duplicate...", "duplicate");
	saveAs("Tiff", DirSave + "/" +originalName);
	close();
	close(originalName);


function countFiles(sourcedir) {
	list = getFileList(sourcedir);
	for (i=0; i<list.length; i++) {
		if (endsWith(list[i], "/"))
		  countFiles(""+dir+list[i]);
		else
		  count++;
		}
}

function openFiles(sourcedir) {
	list = getFileList(sourcedir);
	for (i=0; i<list.length; i++) {
		//test if file or directory
		if (endsWith(list[i], "/"))
			processFiles(""+sourcedir+list[i]);
		
		else {
			// open filepath
			showProgress(n++, count);
			path = sourcedir+list[i];
			open(path);
			}
		}
	}
}


//function processPicture(path) {
	//originalName = getTitle();
	//run("Duplicate...", "duplicate");
	//saveAs("Tiff", DirSave + "/" +originalName);
	//close();
	//close(originalName);
	//}
