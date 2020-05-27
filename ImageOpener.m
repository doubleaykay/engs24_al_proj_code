% This script is for identifying the radii of holes in our ENGS 24 project
% Ben Martin, Anoush Khan

% TODO ===
% Need to add user radius guessing
% Need to store the radius
% Need to scale the radius to a real length based on a calibration factor

% clear environment (comment if not needed)
clear, clc

run = true;
% prompt user to select JPG image
[imgFileName,imgFilePath] = uigetfile('*.jpg');
imFig = figure;
% open selected image and start processing
img = imread(strcat(imgFilePath,imgFileName));
imshow(rgb2gray(img))
distLine = imdistline;
%Declare variables
minRad = 1;
maxRad = 1;
sens = 0.85;
thresh = 0.7;
%Start a circle detection options window
opFig = uifigure('Name', 'Detection Options', 'Position', [50 50 200 330]);
%Add option sliders that the user can control
radPan = uipanel(opFig, 'Title', 'Approximate Radius to Search', 'Position', [25 25 150 75]);
radSlider = uislider(radPan, 'Limits', [11 500], 'ValueChangedFcn',@(radSlider,event) updateRad(radSlider, minRad, maxRad));
radSlider.Position = [15 radSlider.Position(4)+30 120 radSlider.Position(4)];
sensPan = uipanel(opFig, 'Title', 'Sensitivity', 'Position', [25 110 150 75]);
sensSlider = uislider(sensPan, 'Limits', [0 1], 'ValueChangedFcn',@(sensSlider,event) updateSens(sensSlider, sens));
sensSlider.Position = [15 sensSlider.Position(4)+30 120 sensSlider.Position(4)];
edgePan = uipanel(opFig, 'Title', 'Edge Gradient Threshold', 'Position', [25 195 150 75]);
edgeThresholdSlider = uislider(edgePan, 'Limits', [0 1], 'ValueChangedFcn',@(edgeThresholdSlider,event) updateThresh(edgeThresholdSlider, thresh));
edgeThresholdSlider.Position = [15 edgeThresholdSlider.Position(4)+30 120 edgeThresholdSlider.Position(4)];
%Add a button the user can push in order to do a circle check
checkBtn = uibutton(opFig, 'Text', 'Run Check', 'Position', [opFig.Position(3)/2-50 opFig.Position(4)-40 100 30], 'ButtonPushedFcn', @(checkBtn,event) searchForCircleBtn(minRad, maxRad, sens, thresh, img));
while run == true
    disp(minRad);
    disp(maxRad);
    disp(sens);
    disp(thresh);
    % ask if user wants to continue
    inp = input('Do another image? y/n: ', 's');
    if inp == 'y'
        run = true;
        % execute code
        % prompt user to select JPG image
        [imgFileName,imgFilePath] = uigetfile('*.jpg');
        imFig = figure;
        % open selected image and start processing
        img = imread(strcat(imgFilePath,imgFileName));
        imshow(rgb2gray(img))
        distLine = imdistline;
    elseif inp == 'n'
        run = false;
        close all;
    else
        run = false;
        close all;
    end
end

%Button push callback function
function searchForCircleBtn(minRad, maxRad, sens, thresh, img)
    [center, radius] = imfindcircles(rgb2gray(global img),[global minRad global maxRad],'ObjectPolarity', 'dark', 'Sensitivity', sens, 'EdgeThreshold', thresh);
    h = viscircles(center, radius);
    disp(radius);
end

%Slider value change callback functions
function updateSens(sensSlider, sens)
    global sens = sensSlider.Value;
end

function updateThresh(edgeThresholdSlider, thresh)
    global thresh = edgeThresholdSlider.Value;
end

function updateRad(radSlider, minRad, maxRad)
    global maxRad = ceil(radSlider.Value)+10;
    global minRad = ceil(radSlider.Value)-10;
    disp(maxRad);
    disp(minRad);
end