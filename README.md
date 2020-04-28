# wind_damage_detection

This is the files that could be used to analyze thermal images for thresholding based internal damage detection. The dataset could be made available upon request. Here is a short description of the list of files.

### detect_damages_thermal.m
This script is used to follow damage progresstion process on the blade after detecting blade locations. It is the main script to call for controlled experiments on real blades.

### detect_damages_blade.m
Simpler version of the detect_damages_thermal.m with less figures to be plot and gets the plot data out.

### detect_damages_specimen.m
Dynamic script to read the videos of specimen and process and generate corresponding results.

### detect_damages_thermal_modifier.m
Reads flies by files to read the videos of specimen and process and generate corresponding results.

### test.m
This is the function to detect the blade edges and also threshold the damages on top of the blade.

### test_modifier.m
This is a simpler version of the test.m to only detect the damages by thresholding on the specimen

### Bor_create.m
To draw a rectangle as specified in the input on the image

### polyplot.m 
polyplot plots a polynomial fit to scattered x,y data. This function can be used to easily add a linear trend line or other polynomial  fit to a data plot. 

### whitejet.m
It is a unique color map for plotting developed by Biomedical Engineering Group (University of Valladolid), Spain

Here is an example result after processing. 

![Example results on specimen](https://github.com/Shihav/wind_damage_detection/blob/master/HGA04A-03_final_0510.png)



