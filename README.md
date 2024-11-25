# Synthetic-Cell-Segmentation
Synthetic Cell Image Generator
This MATLAB project generates synthetic microscopy images with labeled cells. The generated images are designed for simulating yeast or other cellular fluorescence imaging experiments. The code provides control over cell properties, image dimensions, and noise characteristics to make the simulation realistic.
________________________________________
Features
•	Fluorescence Image: Outputs a uint16 image with simulated fluorescence intensities.
•	Labeled Image: Outputs a uint8 image where each cell is assigned a unique label (1–255), with the background set to 0.
•	Customizable Parameters:
o	Image size (width, height)
o	Number of cells
o	Cell fluorescence intensity
o	Cell size and shape
o	Noise level
________________________________________
Inputs
The generateSyntheticFluorescence function accepts the following inputs:
Parameter	Description	Example Values
width	Width of the image (in pixels).	512
height	Height of the image (in pixels).	512
numCells	Number of cells to generate in the image.	10
fluorescenceLevel	Average fluorescence intensity for cells (uint16).	2000
cellSizeRange	Range of cell sizes (in pixels) as a 2-element array [minSize, maxSize].	[20, 40]
cellShapes	Shape of the cells: 'circle', 'ellipse', or 'random'.	'circle'
noiseLevel	Level of random Gaussian noise applied to the fluorescence image.	50
________________________________________
Outputs
The function returns two outputs:
1.	Fluorescence Image (fluorescenceImage): A uint16 matrix representing the fluorescence intensity of the generated cells.
2.	Labeled Image (labeledImage): A uint8 matrix where cells are labeled incrementally starting from 1, and the background is labeled as 0.
________________________________________
Example Usage
matlab
Copy code
% Generate a synthetic cell image with 10 circular cells
% Image size: 512x512, Cell fluorescence: 2000, Cell size: 20-40 pixels, Noise: 50
[fluorescenceImage, labeledImage] = generateSyntheticFluorescence(512, 512, 10, 2000, [20, 40], 'circle', 50);

% Display the results
figure;
subplot(1, 2, 1);
imshow(fluorescenceImage, []);
title('Fluorescence Image');
subplot(1, 2, 2);
imshow(label2rgb(labeledImage, 'jet', 'k', 'shuffle'));
title('Labeled Image');
________________________________________
Functions
The main function relies on the following helper functions:
1.	createCircularMask: Generates a circular mask for a given position and radius.
2.	createEllipticalMask: Generates an elliptical mask for a given position, major, and minor radius.
3.	createRandomBlob: Generates a random blob mask simulating irregular cell shapes.
________________________________________
Dependencies
•	MATLAB (R2022 or later recommended)
•	Image Processing Toolbox (for poly2mask and label2rgb)
________________________________________

References:
1.	Gonzalez, R. C., & Woods, R. E. (2018). Digital Image Processing (4th Edition). Pearson.
o	A foundational textbook covering image processing concepts, including noise modeling and shape generation.
2.	Russ, J. C. (2016). The Image Processing Handbook (7th Edition). CRC Press.
o	A comprehensive reference for understanding the principles behind synthetic image generation and fluorescence microscopy simulation.
3.	General practices in MATLAB's Image Processing Toolbox Documentation:
o	Provides detailed explanations for functions like poly2mask and label2rgb used in this code. 
License
Synthetic cell image generator inspired by image processing techniques, implemented using MATLAB. Created as an educational resource for simulating cell images. Feel free to use and modify it for educational and research purposes.
