% This script is for identifying the radii of holes in our ENGS 24 project
% Ben Martin, Anoush Khan

% Need to add user radius guessing
% Need to store the radius
% Need to scale the radius to a real length based on a calibration factor

run = true;
while run = true
    % execute code
    % prompt user to select JPG image
    [imgFileName,imgFilePath] = uigetfile('*.jpg');

    % open selected image and start processing
    image = imread(strcat(imgFilePath,imgFileName));
    imshow(rgb2gray(image))
    distLine = imdistline;
    circleDia = distLine.getDistance
    [center, radius] = imfindcircles(rgb2gray(image),[120, 135],'ObjectPolarity', 'dark', 'Sensitivity', 0.99, 'EdgeThreshold',0.1)
    h = viscircles(center, radius);
    
    % ask if user wants to continue
    inp = input('Do another image? y/n: ', 's');
    if inp = 'y'
        run = true;
    elseif inp = 'n'
        run = false;
    end
end