function GetScale(Name,LengthScale,Basename)
% program to select scale in the image in two stepps and calculate the
% value pixel/mm

%% import figure and settings
I = imread([Name '.tif']); % input edges


%% crop the image for a closeup of the scale section
disp('Please roughly select the scale-bar part of the image for a closeup, then double click.')
Section = imcrop(I);
close % close figure


%% crop more exactly & save
disp('Please select the scale-bar of the image as exact as possible, then double click.')
imshow(Section, 'InitialMagnification', 500)
ScaleBar = imcrop;
imwrite(ScaleBar,[Name '_scale_selection.tif'],'tif'); % save result
close % close figure


%% save size of image
disp(['The value pixel per \mu m has been saved in the file: ' Name '_scale.m'])
PixelSizeOfScaleBar = size(ScaleBar);
PixelPerUM = PixelSizeOfScaleBar(2)/LengthScale;
savefile = [Basename '_scale' '.mat'];
save(savefile, 'PixelPerUM');

clear all