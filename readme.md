# Final Project
-------------------------------------
Inpainting based on 3 paper
-------------------------------------
This source code is highly referencing to below:

http://white.stanford.edu/teach/index.php/Object_Removal
https://github.com/jruales/Graphcut-Textures
-------------------------------------
Algorithm:

	Step1: Select region in output area with highest filling priority[A. Criminisi 2004]

	Step2: Select most similar patch to this region using matching similar patch method[Kaiming He and Jian Sun 2006]
	
	Step3: Using Graph-Cut algorithm to fit new patch into selected region[Vivek Kwatra 2008]


files:
	code:
		-findseam.m
			[mask, outputImagePatchLabels] = findseam(patchOnBackground, patchOnBackgroundMask, outputImage, outputImagePatchLabels, offset, patch)
			inputs:
				-patchOnBackground: candidate patch(most similar patch in)
				-patchOnBackgroundMask: candidate patch mask on outputimage area
				-outputImage: outputimage you want to show
				-outputImagePatchLabels: unfilled region of outputImage
				-patch: candidate patch
			outputs:
	            -mask: output a mask showing which portion of the input image should be added to output area
	            -outputImagePatchLabels: display different layer of input
		-findlocation.m
			[toFill,Hp,rows,cols] = findlocation(origImg,mask,psz)
			inputs:
				-origImg: Masked image
				-mask: masked region
				-psz: patch size of toFill region
			outputs:
				-toFill: mask of offset location
				-Hp: highest priority patch that should be replaced by new patch
				-rows: rows of pixels that should be replaced by new patch
				-cols: columns of pixels that should be replaced by new patch
		-MatchingSimilarPatches.m
			[matchpatch,shifted] ==MatchingSimilarPatches(toFill,targetPatch,Patch,t,step)
			inputs: 
				-toFill: mask of offset location
				-targetPatch: offset location patch
				-Patch: Input patch
				-t: threshold of similarity
				-step: moves each iteration
			output:
				-matchpatch: most similar patch
				-shifted: the position of most similar patch in input image
		-inpaint.m
			[outputImage,outputImagePatchLabels] = inpaint(inputimage,mask,patchsize,t)
			inputs: 
				-inputimage: original image
				-mask: a mask to define a unknown region
				-patchsize: patch size to put for each iteration
				-t: threshold of similarity
			output:
				-matchpatch: most similar patch
				-shifted: the position of most similar patch in input image
		-*test.m
			tests on different images, can run it manually
	data:
		-original data used for testing
	resultdata: 
		-images error percentage results among different models
			-file start with fail means where my implementation did really bad
		-16 images result using mask2
		-other methods results
	test:
		-*test.m
			tests on different images, can run it manually
			-tested patch size
			-tested error percentage
			-plot comparision images
			-mat data saved for different models

Conclusion:
	Numerical: Usually as good as other method, but sensitive to patch size and each iteration's result, and probably need a better matching similarity patch method
	Visually: More consistent than other model

Paper reference:
	A. Criminisi. Region Filling and Object Removal by Exemplar-Based Image Inpainting, 2004
	Vivek Kwatra, Arno Schodl, Irfan Essa, Greg Turk, Aaron Bobick. Graph-cut Textures: Image and Video Synthesis Using Graph Cuts, 2008
	Kaiming He and Jian Sun. Statistics of Patch Offsets for Image Completion, 2006


	


	



