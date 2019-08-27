
if (nImages==1) {
			info= split(getImageInfo(),'\n');
			for (i=0; i<lengthOf(info); i++) {
				if (startsWith(info[i],"Path")) {
					Beadimagepath=substring(info[i],6,lengthOf(info[i]));
					//("Using \""+Beadimagepath+"\" as reference bead image.");
				}
			}
	
	} else {
		exit("Please open only your bead reference image and restart the macro");
		}


TitleBead=getTitle();	
print("Beadimage is \""+TitleBead+"\"");
cut=lengthOf(TitleBead)-4;
TitleBead2=substring(TitleBead,0,cut);

getDimensions(Width, Height, ChannelCount, SliceCount, FrameCount);
print("Number of Channels: "+ChannelCount);

//exit;

Dialog.create("Batch");
	Dialog.addMessage("Please enter the Channels to register.");
	Dialog.addNumber("Target Channel: ", 1);
	Dialog.addNumber("Source Channel1: ", 2);
	Dialog.addNumber("Source Channel2: ", 3);
	Dialog.addNumber("Source Channel3: ", 0);

Dialog.show();
	TargetChannel=Dialog.getNumber();
	SourceChannel1=Dialog.getNumber();
	SourceChannel2=Dialog.getNumber();
	SourceChannel3=Dialog.getNumber();


print("Source Channel 1 = "+ SourceChannel1);
print("Source Channel 2 = "+ SourceChannel2);
print("Source Channel 3 = "+ SourceChannel3);
print("Target Channel = "+ TargetChannel);


DirBatch = getDirectory("Choose a Source Folder with images to register.");
DirSave = getDirectory("Choose a Destination Folder.");

//Do Gaussian Blur//
run("Gaussian Blur 3D...", "x=1 y=1 z=2");
run("Split Channels");



//exit
//***ALIGN FIRST SOURCE CHANNEL***
//RENAME CHANNEL IMAGES

//Select Window Source
selectWindow("C"+SourceChannel1+"-"+TitleBead);
//find brightest Slice 
  if (nSlices>1) run("Clear Results");
      getVoxelSize(w, h, d, unit);
      n = getSliceNumber();
      for (i=1; i<=nSlices; i++) {
          setSlice(i);
          getStatistics(area, mean, min, max, std);
          row = nResults;
          if (nSlices==1)
              setResult("Area ("+unit+"^2)", row, area);
          setResult("Mean ", row, mean);
          setResult("Std ", row, std);
          setResult("Min ", row, min);
          setResult("Max ", row, max);
  
      }
      setSlice(n);
      updateResults();

      a=1;
      ResultCompare=0;
     for (i=1; i<=nResults; i++) {
          ResultStd=getResult("Std ", i-1);
  	  print(ResultStd);
  	  if (ResultStd >ResultCompare)
  	  {print(a);
  	  BrightestSlice_Source1=a;
          ResultCompare=(ResultStd);
          }
  	  a=a+1; 
      }
print(a);
print("Brightest Slice Source 1 = "+ BrightestSlice_Source1);
setSlice(BrightestSlice_Source1);

run("Duplicate...", "title=Source1");
//exit;

//Select Window Target
selectWindow("C"+TargetChannel+"-"+TitleBead);
//find brightest Slice 
  if (nSlices>1) run("Clear Results");
      getVoxelSize(w, h, d, unit);
      n = getSliceNumber();
      for (i=1; i<=nSlices; i++) {
          setSlice(i);
          getStatistics(area, mean, min, max, std);
          row = nResults;
          if (nSlices==1)
              setResult("Area ("+unit+"^2)", row, area);
          setResult("Mean ", row, mean);
          setResult("Std ", row, std);
          setResult("Min ", row, min);
          setResult("Max ", row, max);
  
      }
      setSlice(n);
      updateResults();

      a=1;
      ResultCompare=0;
     for (i=1; i<=nResults; i++) {
          ResultStd=getResult("Std ", i-1);
  	  print(ResultStd);
  	  if (ResultStd >ResultCompare)
  	  {print(a);
  	  BrightestSlice_Target=a;
          ResultCompare=(ResultStd);
          }
  	  a=a+1; 
      }
print(a);
print("Brightest Target = "+ BrightestSlice_Target);
setSlice(BrightestSlice_Target);

Zshift_Source1=(BrightestSlice_Target-BrightestSlice_Source1);
print("Z Shift Source 1 = "+Zshift_Source1);

run("Duplicate...", "title=Target_Channel");

//exit

//open ROI Manager
run("ROI Manager...");
roiManager("Reset");
//roiManager("Delete");

selectWindow("Source1");



//REGISTRATION FIRST SOURCE CHANNEL OF BEADS
run("Descriptor-based registration (2d/3d)", "first_image=Source1 second_image=Target_Channel brightness_of=[Interactive ...] approximate_size=[Interactive ...] type_of_detections=[Interactive ...] transformation_model=[Homography (2d)] images_pre-alignemnt=[Not prealigned] number_of_neighbors=3 redundancy=1 significance=3 allowed_error_for_ransac=5 choose_registration_channel_for_image_1=1 choose_registration_channel_for_image_2=1 create_overlayed add_point_rois");

//exit;

//SAVE LANDMARKS
selectWindow("Target_Channel");
roiManager("Add");
roiManager("Select", 0);
roiManager("Rename", "Target_Ch"+TargetChannel+"_for_S1");


selectWindow("Source1");

//rename("Source_Channel_"+SourceChannel1);
run("ROI Manager...");
roiManager("Add");
roiManager("Select", 1);
roiManager("Rename", "S1_Ch"+SourceChannel1);
//exit

close("overlay*");

if (ChannelCount>2){
	//***ALIGN SECOND SOURCE CHANNEL***
	//RENAME CHANNEL IMAGES
	close("Target_Channel");
				

	//Select Window Source
	selectWindow("C"+SourceChannel2+"-"+TitleBead);
	//find brightest Slice 
  if (nSlices>1) run("Clear Results");
      getVoxelSize(w, h, d, unit);
      n = getSliceNumber();
      for (i=1; i<=nSlices; i++) {
          setSlice(i);
          getStatistics(area, mean, min, max, std);
          row = nResults;
          if (nSlices==1)
              setResult("Area ("+unit+"^2)", row, area);
          setResult("Mean ", row, mean);
          setResult("Std ", row, std);
          setResult("Min ", row, min);
          setResult("Max ", row, max);
  
      }
      setSlice(n);
      updateResults();

      a=1;
      ResultCompare=0;
     for (i=1; i<=nResults; i++) {
          ResultStd=getResult("Std ", i-1);
  	  print(ResultStd);
  	  if (ResultStd >ResultCompare)
  	  {print(a);
  	  BrightestSlice_Source2=a;
          ResultCompare=(ResultStd);
          }
  	  a=a+1; 
      }
print(a);
print("Brightest Slice Source 2 = "+ BrightestSlice_Source2);

Zshift_Source2=(BrightestSlice_Target-BrightestSlice_Source2);
print("Z Shift Source 2 = "+Zshift_Source2);

setSlice(BrightestSlice_Source2);

	run("Duplicate...", "title=Source2");


	//Select Window Target
	selectWindow("C"+TargetChannel+"-"+TitleBead);
	setSlice(BrightestSlice_Target);
	run("Duplicate...", "title=Target_Channel");


	selectWindow("Source2");
//exit;

	//REGISTRATION SECOND SOURCE CHANNEL OF BEADS
	run("Descriptor-based registration (2d/3d)", "first_image=Source2 second_image=Target_Channel brightness_of=[Interactive ...] approximate_size=[Interactive ...] type_of_detections=[Interactive ...] transformation_model=[Homography (2d)] images_pre-alignemnt=[Not prealigned] number_of_neighbors=3 redundancy=1 significance=3 allowed_error_for_ransac=5 choose_registration_channel_for_image_1=1 choose_registration_channel_for_image_2=1 create_overlayed add_point_rois");
//exit

	selectWindow("Target_Channel");
	roiManager("Add");
	roiManager("Select", 2);
	roiManager("Rename", "Target_Ch"+TargetChannel+"_for_S2");
	

	selectWindow("Source2");
	run("ROI Manager...");
	roiManager("Add");
	roiManager("Select", 3);
	roiManager("Rename", "S2_Ch"+SourceChannel2);

	close("overlay*");


	if (ChannelCount >3){
		//***ALIGN THIRD SOURCE CHANNEL***
		//RENAME CHANNEL IMAGES
		close("Target_Channel");
		
		//Select Window Source
		selectWindow("C"+SourceChannel3+"-"+TitleBead);
		//find brightest Slice 
  if (nSlices>1) run("Clear Results");
      getVoxelSize(w, h, d, unit);
      n = getSliceNumber();
      for (i=1; i<=nSlices; i++) {
          setSlice(i);
          getStatistics(area, mean, min, max, std);
          row = nResults;
          if (nSlices==1)
          	setResult("Area ("+unit+"^2)", row, area);
          	setResult("Mean ", row, mean);
          	setResult("Std ", row, std);
          	setResult("Min ", row, min);
          	setResult("Max ", row, max);
  
      }
      setSlice(n);
      updateResults();

      a=1;
      ResultCompare=0;
     for (i=1; i<=nResults; i++) {
          ResultStd=getResult("Std ", i-1);
  	  print(ResultStd);
  	  if (ResultStd >ResultCompare)
  	  {print(a);
  	  BrightestSlice_Source3=a;
          ResultCompare=(ResultStd);
          }
  	  a=a+1; 
      }
print(a);
print("Brightest Slice Source 3 = "+ BrightestSlice_Source3);

Zshift_Source3=(BrightestSlice_Target-BrightestSlice_Source3);
print("Z Shift Source 3 = "+Zshift_Source3);

setSlice(BrightestSlice_Source3);
		run("Duplicate...", "title=Source3");

		//Select Window Target
		selectWindow("C"+TargetChannel+"-"+TitleBead);
		setSlice(BrightestSlice_Target);
		run("Duplicate...", "title=Target_Channel");


		selectWindow("Source3");


	//exit;
		//REGISTRATION THIRD SOURCE CHANNEL OF BEADS
		run("Descriptor-based registration (2d/3d)", "first_image=Source3 second_image=Target_Channel brightness_of=[Interactive ...] approximate_size=[Interactive ...] type_of_detections=[Interactive ...] transformation_model=[Homography (2d)] images_pre-alignemnt=[Not prealigned] number_of_neighbors=3 redundancy=1 significance=3 allowed_error_for_ransac=5 choose_registration_channel_for_image_1=1 choose_registration_channel_for_image_2=1 create_overlayed add_point_rois");

		selectWindow("Target_Channel");
		roiManager("Add");
		roiManager("Select", 4);
		roiManager("Rename", "Target_Ch"+TargetChannel+"_for_S3");


		selectWindow("Source3");
		run("ROI Manager...");
		roiManager("Add");
		roiManager("Select", 5);
		roiManager("Rename", "S3_Ch"+SourceChannel3);
		//roiManager("Save", Beadimagepath+"-ROIs.zip");
	}
}
		roiManager("Save", Beadimagepath+"-ROIs.zip");

		
//CALCULATE SLICES TO INSERT FOR Z-ALIGNMENT

//Define Slices to add for Target
Slice_Target_pos=(0);
Slice_Target_neg=(0);
 for (i=1; i<ChannelCount; i++) {
 	if(i==1)
	shift=(Zshift_Source1);       
	else if(i==2)
	shift=(Zshift_Source2);       
	else if(i==3)
	shift=(Zshift_Source3);
           
         	if(shift>0 && shift>Slice_Target_pos){
          	Slice_Target_pos=(shift);
       		}
       
          	if(shift<0 && shift<Slice_Target_neg){
          	Slice_Target_neg=(shift);
          	}
          	
 
        print(shift);
  	print("i = "+i);
      }
print("Zshift_Source"+i);
print("Slice Target pos = "+Slice_Target_pos);
print("Slice Target neg = "+abs(Slice_Target_neg));

Slice_Source1_pos=(Slice_Target_pos-Zshift_Source1);
Slice_Source1_neg=abs(Slice_Target_neg-Zshift_Source1);

print(Slice_Source1_pos);
print(Slice_Source1_neg);

	if(ChannelCount>2)  {
  		Slice_Source2_pos=(Slice_Target_pos-Zshift_Source2);
  		Slice_Source2_neg=abs(Slice_Target_neg-Zshift_Source2);
 	
		print("Slice Source2 pos = "+Slice_Source2_pos);
		print("Slice Source2 neg = "+Slice_Source2_neg);
	}

	if(ChannelCount>3){
		Slice_Source3_pos=(Slice_Target_pos-Zshift_Source3);
		Slice_Source3_neg=abs(Slice_Target_neg-Zshift_Source3);

		print("Slice Source3 pos = "+Slice_Source3_pos);
		print("Slice Source3 neg = "+Slice_Source3_neg);
	}
	
Slice_Target_neg=abs(Slice_Target_neg);

//exit

//APPLY TRANSFORMATION TO BEADIMAGE CHANNELS

selectWindow("Target_Channel");
roiManager("Select", 0);
run("Landmark Correspondences", "source_image=Source1 template_image=Target_Channel transformation_method=[Moving Least Squares (non-linear)] alpha=1 mesh_resolution=32 transformation_class=Similarity interpolate");
rename("Transformed_Ch"+SourceChannel1);


if(ChannelCount >2){
	selectWindow("Target_Channel");
	roiManager("Select", 2);
	run("Landmark Correspondences", "source_image=Source2 template_image=Target_Channel transformation_method=[Moving Least Squares (non-linear)] alpha=1 mesh_resolution=32 transformation_class=Similarity interpolate");
	rename("Transformed_Ch"+SourceChannel2);

if(ChannelCount >3){
		selectWindow("Target_Channel");
		roiManager("Select", 4);
		run("Landmark Correspondences", "source_image=Source3 template_image=Target_Channel transformation_method=[Moving Least Squares (non-linear)] alpha=1 mesh_resolution=32 transformation_class=Similarity interpolate");
		rename("Transformed_Ch"+SourceChannel3);
	}
}

selectWindow("Target_Channel");
run("Duplicate...", "title=title");
rename("Transformed_Ch"+TargetChannel);

//exit
/////////////////////////
//ITERATE ALIGNMENT OVER SOURCECHANNEL1
 //Select Window Target
close("Transformed_Ch*");
close("Source*");

selectWindow("C"+SourceChannel1+"-"+TitleBead);
setSlice(1);
run("Duplicate...", " ");
rename("DummyStack");
selectWindow("C"+SourceChannel1+"-"+TitleBead);
//exit
 if (nSlices>1) run("Clear Results");
      n = nSlices();
      print("Slicenumber= "+n);
      setBatchMode(true);
      for (i=1; i<=n; i++) {
          selectWindow("C"+SourceChannel1+"-"+TitleBead);
          setSlice(i);
          run("Duplicate...", "title=Source1");  
  	  roiManager("Select", 1);
  	  selectWindow("Target_Channel");
	  roiManager("Select", 0);
	  run("Landmark Correspondences", "source_image=Source1 template_image=Target_Channel transformation_method=[Moving Least Squares (non-linear)] alpha=1 mesh_resolution=32 transformation_class=Similarity interpolate");
	  rename("Stackalign"+i);
	  close("Source1"); 
	  run("Concatenate...", "  title=[DummyStack] image1=DummyStack image2=Stackalign"+i+" image3=[-- None --]");
	  close("Stackalign"+i);
	  //exit
      }
setSlice(1);
run("Delete Slice");      
//exit
      setBatchMode(false);
   
rename("Transformed_Ch"+SourceChannel1);
//exit
//ADD SCLICES FOR Z ALIGNMENT SOURCECHANNEL1

setSlice(SliceCount);
     if(Slice_Source1_pos>0){
        for(a=1; a<=Slice_Source1_pos; a++) {
        	run("Add Slice", "add=slice");
        }
	}
	
run("Reverse");
     if(Slice_Source1_neg>0){
        for(a=1; a<=Slice_Source1_neg; a++) {
        	run("Add Slice", "add=slice");	
        }
	}
run("Reverse");

close("Source*");
//exit;  



if(ChannelCount >2){
selectWindow("C"+SourceChannel2+"-"+TitleBead);	
  if (nSlices>1) run("Clear Results");
      n = nSlices();
      print(n);
      setBatchMode(false);
      for (i=1; i<=n; i++) {
          selectWindow("C"+SourceChannel2+"-"+TitleBead);
          setSlice(i);
          run("Duplicate...", "title=Source1");  
  	  roiManager("Select", 3);
  	  selectWindow("Target_Channel");
	  roiManager("Select", 2);
	  run("Landmark Correspondences", "source_image=Source1 template_image=Target_Channel transformation_method=[Moving Least Squares (non-linear)] alpha=1 mesh_resolution=32 transformation_class=Similarity interpolate");
	  rename("Stackalign"+i);
	  close("Source1"); 
      }  
      
run("Images to Stack", "name=Stack title=Stackalign use");
rename("Transformed_Ch"+SourceChannel2);

//ADD SCLICES FOR Z ALIGNMENT SOURCECHANNEL2
if(ChannelCount>2){ 
	setSlice(SliceCount);
     		if(Slice_Source2_pos>0){
        	for(a=1; a<=Slice_Source2_pos; a++) {
        	run("Add Slice", "add=slice");
        }
	}
	
	run("Reverse");
     		if(Slice_Source2_neg>0){
       		 for(a=1; a<=Slice_Source2_neg; a++) {
        	run("Add Slice", "add=slice");	
        }
	}
	run("Reverse");
}
//exit;        
} 


if(ChannelCount >3){
selectWindow("C"+SourceChannel3+"-"+TitleBead);	
  if (nSlices>1) run("Clear Results");
      n = nSlices();
      print(n);
      setBatchMode(false);
      for (i=1; i<=n; i++) {
          selectWindow("C"+SourceChannel3+"-"+TitleBead);
          setSlice(i);
          run("Duplicate...", "title=Source1");  
  	  roiManager("Select", 5);
  	  selectWindow("Target_Channel");
	  roiManager("Select", 4);
	  run("Landmark Correspondences", "source_image=Source1 template_image=Target_Channel transformation_method=[Moving Least Squares (non-linear)] alpha=1 mesh_resolution=32 transformation_class=Similarity interpolate");
	  rename("Stackalign"+i);
	  close("Source1"); 
      }  
      
run("Images to Stack", "name=Stack title=Stackalign use");
rename("Transformed_Ch"+SourceChannel3);
       
} 

//ADD SCLICES FOR Z ALIGNMENT SOURCECHANNEL3
if(ChannelCount>3){ 
	
	setSlice(SliceCount);
     		if(Slice_Source3_pos>0){
        	for(a=1; a<=Slice_Source2_pos; a++) {
        	run("Add Slice", "add=slice");
        }
	}
	
	run("Reverse");
     		if(Slice_Source3_neg>0){
       		 for(a=1; a<=Slice_Source3_neg; a++) {
        	run("Add Slice", "add=slice");	
        }
	}
	run("Reverse");
}   
        
////////////////////////////
	//Select Window Target
	selectWindow("C"+TargetChannel+"-"+TitleBead);
	//ADD SCLICES FOR Z ALIGNMENT TARGET

	setSlice(SliceCount);
     		if(Slice_Target_pos>0){
        	for(a=1; a<=Slice_Target_pos; a++) {
        	run("Add Slice", "add=slice");		
        }
	}
	
	run("Reverse");
     		if(Slice_Target_neg>0){
        		for(a=1; a<=Slice_Target_neg; a++) {
        		run("Add Slice", "add=slice");        	
        }
	}
	run("Reverse");


//run("Duplicate...", "title=Transformed_Ch"+TargetChannel);
	rename("Transformed_Ch"+TargetChannel);




if(ChannelCount==2){
run("Merge Channels...", "c1=Transformed_Ch1 c2=Transformed_Ch2 create");

}

else if(ChannelCount==3){
run("Merge Channels...", "c1=Transformed_Ch1 c2=Transformed_Ch2 c3=Transformed_Ch3 create");

}
else if(ChannelCount==4){
run("Merge Channels...", "c1=Transformed_Ch1 c2=Transformed_Ch2 c3=Transformed_Ch3 c4=Transformed_Ch4 create");

}

selectWindow("Composite");
saveAs("TIFF", Beadimagepath+"-aligned");
print("Bead alignment complete");


run("Close All");
//exit;
//exit


//************************************RUNNING THE BATCH OF IMAGES*********************************************************
//************************************************************************************************************************

list = getFileList(DirBatch);
setBatchMode(true);
for (i=0; i<list.length; i++) {
	showProgress(i+1, list.length);
	//open(DirBatch+list[i]);
	openImage=DirBatch+list[i];
	print(openImage);
	run("Bio-Formats Importer", "open=["+openImage+"] color_mode=Default view=Hyperstack stack_order=XYCZT use_virtual_stack");
	
//exit
	TitleImage=getTitle();
	cut=lengthOf(TitleImage)-4;
	TitleImage2=substring(TitleImage,0,cut);

	
	run("Split Channels");

//close("Transformed_Ch*");
//close("Source*");
  selectWindow("C"+TargetChannel+"-"+TitleImage);
  run("Duplicate...", "title=Target_Channel"); 
  roiManager("Select", 0);
	  	
	selectWindow("C"+SourceChannel1+"-"+TitleImage);
 	  if (nSlices>1) run("Clear Results");
      		n = nSlices();
      		//print(n);
      		//setBatchMode(true);
      	  for (a=1; a<=n; a++) {
          	selectWindow("C"+SourceChannel1+"-"+TitleImage);
          	setSlice(a);
          	run("Duplicate...", "title=Source1"); 
  	  	roiManager("Select", 1);
  	  	//selectWindow("C"+TargetChannel+"-"+TitleImage);
  	  	//run("Duplicate...", "title=Target_Channel"); 
	  	//roiManager("Select", 0);
	  	run("Landmark Correspondences", "source_image=Source1 template_image=Target_Channel transformation_method=[Moving Least Squares (non-linear)] alpha=1 mesh_resolution=32 transformation_class=Similarity interpolate");
	  	rename("Stackalign"+a);
	  	close("Source1"); 
	  	//close("Target_Channel");
      }
      
   
	run("Images to Stack", "name=Stack title=Stackalign use");

	rename("Transformed_Ch"+SourceChannel1);



	if(ChannelCount>2){

  		selectWindow("Target_Channel");
   		roiManager("Select", 2);

		selectWindow("C"+SourceChannel2+"-"+TitleImage);
 	 	if (nSlices>1) run("Clear Results");
      	n = nSlices();
      	//print(n);
      	//setBatchMode(false);
      	for (a=1; a<=n; a++) {
          	selectWindow("C"+SourceChannel2+"-"+TitleImage);
          	setSlice(a);
          	run("Duplicate...", "title=Source1"); 
  	 	 	roiManager("Select", 3); 
	 	 	run("Landmark Correspondences", "source_image=Source1 template_image=Target_Channel transformation_method=[Moving Least Squares (non-linear)] alpha=1 mesh_resolution=32 transformation_class=Similarity interpolate");
		  	rename("Stackalign"+a);
		  	close("Source1"); 
	  	
    	 }
      
   
		run("Images to Stack", "name=Stack title=Stackalign use");
		rename("Transformed_Ch"+SourceChannel2);
		close("Source*");

	}
      

	if(ChannelCount>3){
 		selectWindow("Target_Channel");
   		roiManager("Select", 4);

		selectWindow("C"+SourceChannel3+"-"+TitleImage);
 	  if (nSlices>1) run("Clear Results");
      n = nSlices();
      //print(n);
      //setBatchMode(false);
      for (a=1; a<=n; a++) {
        	selectWindow("C"+SourceChannel3+"-"+TitleImage);
			setSlice(a);
			run("Duplicate...", "title=Source1"); 
			roiManager("Select", 5);
  	  		//selectWindow("Target_Channel");
	  		//roiManager("Select", 2);
	  		run("Landmark Correspondences", "source_image=Source1 template_image=Target_Channel transformation_method=[Moving Least Squares (non-linear)] alpha=1 mesh_resolution=32 transformation_class=Similarity interpolate");
	  		rename("Stackalign"+a);
	  		close("Source1"); 
	  	
      }
      
   
	run("Images to Stack", "name=Stack title=Stackalign use");
	rename("Transformed_Ch"+SourceChannel3);
	close("Source*");    
	}


//Select Window Target
//ADD SCLICES FOR Z ALIGNMENT TARGET


	selectWindow("C"+TargetChannel+"-"+TitleImage);
	getDimensions(dummy, dummy, dummy, SliceCount, dummy);
	setSlice(SliceCount);
     	if(Slice_Target_pos>0){
        	for(a=1; a<=Slice_Target_pos; a++) {
        		run("Add Slice", "add=slice");		
        	}
		}
	
	run("Reverse");
     	if(Slice_Target_neg>0){
        	for(a=1; a<=Slice_Target_neg; a++) {
        		run("Add Slice", "add=slice");        	
    		}
		}
	run("Reverse");

	rename("Transformed_Ch"+TargetChannel);


//ADD SCLICES FOR Z ALIGNMENT SOURCECHANNEL1

	selectWindow("Transformed_Ch"+SourceChannel1);
	setSlice(SliceCount);
     	if(Slice_Source1_pos>0){
        	for(a=1; a<=Slice_Source1_pos; a++) {
        		run("Add Slice", "add=slice");
        	}
		}
	
	run("Reverse");
     	if(Slice_Source1_neg>0){
        	for(a=1; a<=Slice_Source1_neg; a++) {
        		run("Add Slice", "add=slice");	
        	}
		}
	run("Reverse");

//ADD SCLICES FOR Z ALIGNMENT SOURCECHANNEL2
	if(ChannelCount>2){ 
		selectWindow("Transformed_Ch"+SourceChannel2);
		setSlice(SliceCount);
     		if(Slice_Source2_pos>0){
        		for(a=1; a<=Slice_Source2_pos; a++) {
        		run("Add Slice", "add=slice");
        		}
			}
	
		run("Reverse");
     		if(Slice_Source2_neg>0){
       			for(a=1; a<=Slice_Source2_neg; a++) {
        		run("Add Slice", "add=slice");	
        		}
			}
		run("Reverse");
	}


//ADD SCLICES FOR Z ALIGNMENT SOURCECHANNEL3
	if(ChannelCount>3){ 
	selectWindow("Transformed_Ch"+SourceChannel3);
	setSlice(SliceCount);
     		if(Slice_Source3_pos>0){
        		for(a=1; a<=Slice_Source2_pos; a++) {
        		run("Add Slice", "add=slice");
        		}
			}
	
		run("Reverse");
     		if(Slice_Source3_neg>0){
       			for(a=1; a<=Slice_Source3_neg; a++) {
        		run("Add Slice", "add=slice");	
        		}
			}
		run("Reverse");
	}


	if(ChannelCount==2){
		run("Merge Channels...", "c1=Transformed_Ch1 c2=Transformed_Ch2 create");
	}

	else if(ChannelCount==3){
	run("Merge Channels...", "c1=Transformed_Ch1 c2=Transformed_Ch2 c3=Transformed_Ch3 create");

	}
	else if(ChannelCount==4){
	run("Merge Channels...", "c1=Transformed_Ch1 c2=Transformed_Ch2 c3=Transformed_Ch3 c4=Transformed_Ch4 create");

	}
	//exit;
	selectWindow("Composite");
	rename(TitleImage2+"_registered");
	saveAs("TIFF", DirSave+list[i]+"_registered");
	print("Processed Image \""+TitleImage+"\"");	
	run("Close All");

}

print("Batch Registration complete");
