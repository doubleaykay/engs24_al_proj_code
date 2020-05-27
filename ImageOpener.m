%This script is for identifying the radii of holes in our ENGS 24 project
[imgFileName,imgFilePath] = uigetfile('*.jpg');
image = imread(strcat(imgFilePath,imgFileName));
imshow(rgb2gray(image))
distLine = imdistline;
circleDia = distLine.getDistance
[center, radius] = imfindcircles(rgb2gray(image),[120, 135],'ObjectPolarity', 'dark', 'Sensitivity', 0.99, 'EdgeThreshold',0.1)
h = viscircles(center, radius);

%Need to add user radius guessing
%Need to add a loop that allows the user to select a new image after the
%first one is finished
%Need to store the radius
%Need to scale the radius to a real length based on a calibration factor