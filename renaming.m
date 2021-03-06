%Renaming image files for ENGS24 Final Project
%Written by Ben Martin

%clear the environment
clear, clc;

%set the debug flag
debug = false;

%Set a flag for the running loop
notDone = true;

while notDone
    %If in debug mode, quit after the first pass
    if debug
        notDone = false;
    end
    
    % array of image names in user-selected folder
    picpath_raw = uigetdir;
    picpath = strcat(picpath_raw, '\*.jpg');
    picarr = dir(picpath);
    picnames = string({picarr.name});
    
    %Get the renaming settings from the user
    title = 'Enter "Quit" in first box to exit';
    prompt = {'Enter your initials', 'Enter the alloy number', 'Enter the temperature', 'Enter the sample number'};
    renSet = inputdlg(prompt,title);
    
    %Store the input settings in variables
    initials = cell2mat(renSet(1));
    alloy = cell2mat(renSet(2));
    temp = cell2mat(renSet(3));
    sample = cell2mat(renSet(4));
    
    %Quit out of the loop if the user inputs quit
    if strcmp(initials,'Quit')
        notDone = false;
        break;
    end
    
    %Go through each file in the directory and rename them according to
    %what we wanted
    for index = 1:length(picnames)
        oldName = strcat(picpath_raw,'\',picnames(index));
        newName = strcat(picpath_raw,'\',initials,'_',alloy,'_',temp,'F_',sample,'_',num2str(index),'.jpg');
        movefile(oldName,newName);
    end
end
close all;