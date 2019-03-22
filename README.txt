Loading and visualisation functions for Cooking Dataset: this software allows users to access 
RGB and Kinematic streams.

Functions loadDataset and loadAction allow the user to load and save the Cooking Dataset in a 
different setting with respect to the structures provided with this code. LoadAction will give 
the user the possibility to load only part of the Cooking Dataset by specifying and action, a 
marker, or an instance.

Syntax:
	- loadDataset(folder, 'training') and loadDataset(folder, 'test') will group MoCap data of all 
		actions for the set indicated into one single structure.
	- loadAction(folder, action) and loadAction(folder, action, 'ALL') return a struct containing 
		data of all markers for the action specified.
	- loadAction(folder, action, marker) returns a struct containing data of the marker specified 
		for the action in 'action'.
	- loadAction(folder, action, 'ALL', instance) returns a struct containing data of all markers 
		at the specified instance of  the action.
	- loadAction(folder, action, marker, instance) returns a struct containing data of a single 
		marker at the specifies instance of the action.

The function segmentAction will extract the single instances of action from the complete MoCap 
streams. Same function can be used to segment the scenes in different actions.

Three types of visualisation functions are available:
	- visualiseAction, for 3D plot of each marker's trajectory 
	- visualiseSkeleton, for a simulation of the arm executing the complete action using MoCap data
	- initSynch and synchronizedView for a joint view of RGB and Kinematic data
	
The user can find the list of the actions and a numerical description of the dataset in tabella.ods.
	


