% This script is for identifying the radii of holes in our ENGS 24 project
% Ben Martin, Anoush Khan

% TODO ===
% Need to scale the radius to a real length based on a calibration factor

% clear environment (comment if not needed)
clear, clc
%Declare variables
minRad = 1;
maxRad = 1;
sens = 0.85;
thresh = 0.7;
calibrationFactor = 1;
run = true;
% prompt user to select JPG image
[imgFileName,imgFilePath] = uigetfile('*.jpg');
imFig = figure;
% open selected image and start processing
img = imread(strcat(imgFilePath,imgFileName));
%Store the img array in a graphics object property that the callback
%function can find and access
imFig.UserData = img;
h = refreshImg(img);
%Get the calibration factor on startup
calibrationFactor = getUserSpaCalib(h);
%Start a circle detection options window
opFig = uifigure('Name', 'Detection Options', 'Position', [50 50 200 330]);
%Add option sliders that the user can control
radPan = uipanel(opFig, 'Title', 'Approximate Radius to Search', 'Position', [25 25 150 75]);
radSlider = uislider(radPan, 'Limits', [50 500], 'MajorTicks', [50 150 250 350 500]);
radSlider.Position = [15 radSlider.Position(4)+30 120 radSlider.Position(4)];
%Tag so the callback function can find and get the data from it
radSlider.Tag = 'RadSlide';
sensPan = uipanel(opFig, 'Title', 'Sensitivity', 'Position', [25 110 150 75]);
sensSlider = uislider(sensPan, 'Limits', [0 1]);
sensSlider.Position = [15 sensSlider.Position(4)+30 120 sensSlider.Position(4)];
sensSlider.Tag = 'SensSlide';
edgePan = uipanel(opFig, 'Title', 'Edge Gradient Threshold', 'Position', [25 195 150 75]);
edgeThresholdSlider = uislider(edgePan, 'Limits', [0 1]);
edgeThresholdSlider.Position = [15 edgeThresholdSlider.Position(4)+30 120 edgeThresholdSlider.Position(4)];
edgeThresholdSlider.Tag = 'ThresholdSlide';
%Add a button the user can push in order to do a circle check
%Callback function actually runs the circle finding algorithim 
checkBtn = uibutton(opFig, 'Text', 'Run Check', 'Position', [opFig.Position(3)/2-50 opFig.Position(4)-40 100 30], 'ButtonPushedFcn', @searchForCircleBtn);
while run == true
    % ask if user wants to continue
    inp = input('Do another image? y/n: ', 's');
    if inp == 'y'
        close all;
        run = true;
        % execute code
        % prompt user to select JPG image
        [imgFileName,imgFilePath] = uigetfile('*.jpg');
        imFig = figure;
        % open selected image and start processing
        img = imread(strcat(imgFilePath,imgFileName));
        imFig.UserData = img;
        h = refreshImg(img);
    elseif inp == 'n'
        run = false;
        close all;
        close(opFig);
    else
        run = false;
        close all;
        close(opFig);
    end
end

%Button push callback function
function searchForCircleBtn(checkBtn,event)
    imgFigure = findobj(0,'Type','figure');
    img = imgFigure.UserData;
    sensSlide = findobj(checkBtn.Parent,'Tag','SensSlide');
    sens = sensSlide.Value;
    threshSlide = findobj(checkBtn.Parent,'Tag','ThresholdSlide');
    thresh = threshSlide.Value;
    radSlide = findobj(checkBtn.Parent,'Tag','RadSlide');
    minRad = floor(radSlide.Value)-25;
    maxRad = minRad + 50;
    %Loop through different settings until only 1 circle is found, or until
    %we've tried a sufficient number of times
    onlyOne = 0;
    iterationCount = 0;
    giveUpFlag = 0;
    while (onlyOne == 0 && iterationCount < 10 && giveUpFlag == 0)
        %Increase a counter to escape loop after 10 attempts
        iterationCount = iterationCount + 1;
        [center, radius] = imfindcircles(rgb2gray(img),[minRad maxRad],'ObjectPolarity', 'dark', 'Sensitivity', sens, 'EdgeThreshold', thresh);
        if size(center)==1
            %We did it! We found 1 circle and 1 circle only!
            onlyOne = 1;
            %Display the current settings that worked
            disp(sens);
            disp(thresh);
        else
            %Adjust settings and try again
            if size(center)==0
                %We found no circles, try increasing sensitivity
                [giveUpFlag,sens] = adjustSettings(sens,0);
            else
                %We found too many circles, try decreasing sensitivity
                [giveUpFlag,sens] = adjustSettings(sens,1);
            end
        end
        viscircles(center, radius);
    end
    %Tell the user that automatically adjust settings to find a circle
    %didn't work
    if (giveUpFlag == 1 || iterationCount == 10)
        h = refreshImg(img);
        errordlg('The program was unable to detect a circle in this image after either a)reaching the most extreme settings possible or b)making too many attempts. Please use the draggable tool to input the radius manually.','Manual Data Collection Required');
    else
        disp(radius);
    end
end

%Adjusts the settings in a "smart" way to try and get circles more often
function [givenUp,osens] = adjustSettings(isens,mode)
    %Try lowering sensitivity if we found too many circles, increasing if
    %we found too few
    %Mode 1 is too many cirlces
    if mode == 1
        osens = isens - 0.05;
    else
        osens = isens + 0.05;
    end
    %Set a givenUp flag if we've reached the most extreme settings we can
    givenUp = 0;
    if osens > 1 || osens < 0
        givenUp = 1;
    end
end

%Recreates the image and the distance line
function h = refreshImg(img)
    imshow(rgb2gray(img));
    h = imdistline;
end

function calibFact = getUserSpaCalib(line)
    %Prompt the user to set the spatial calibration
    definput = 200;
    answer = input('Enter the real distance of the line in micrometers: ','s');
    answer = str2double(answer);
    if isnan(answer)||answer<=0
        errordlg('Spatial calibration factor must be a positive number','Bad input detected');
        answer = definput;
    end
    %Returns a value in nm per pixel
    calibFact = answer/getDistance(line);
    disp(calibFact);
end