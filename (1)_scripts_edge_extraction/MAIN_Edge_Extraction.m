function MAIN_Edge_Extraction
% Sript designed to ectract the edges in TEM images to determine the shape
% of wiggles on plant cell walls that make up a diffraction grating. The
% edges are extracted, cleaned, straightened and sorted.
%%% This script works half-manualy to insure quality. Please follow the
%%% instructions. Copy sections into the command line to execute or use
%%% 'evalluate cell' button at the top menu (Ctr+Enter).


%% Read in microscope image and perform edge detection
%%%INPUTS%%%
Name = 'Oenothera stricta 16'; % INPUT NAME OF TEM-IMAGE
SaveNameEdge = 'OenotheraEDGE16'; % CHOOSE NAME TO SAVE
% This program is (arbitrarily) set to work with images in the .tif format.

I = imread([Name '.tif']); % import image
[BW,threshold] = edge(I,'canny',[0.01 0.05],sqrt(2)*4.0); % edge detection: Canny method; worked best in comparison
% disp(['Threshold ' num2str(threshold)]); % display threshold
% previous: ,[0.0001 0.065],sqrt(2)*2.5; ,[0.025 0.15],sqrt(2)*1.5); ,[0.005 0.038],sqrt(2)*3.7); [0.04 0.15],sqrt(2)*1.0) ; [0.05 0.15],sqrt(2)*1.5
imwrite(BW,[SaveNameEdge '.tif'],'tif'); % save image
clear I BW threshold


%%% CHECK QUALITY OF EDGES!
% If the quality is not good enough, play around with the edge detection
% settings "threshold" and "sigma" in "edge(I,'canny',thresh,sigma)"


%% Select edges of interest interactively
%%%INPUTS%%%
NameE = SaveNameEdge;%'GreilumEDGE2'; % INPUT NAME OF EDGE IMAGE, use from above or redefine
RemoveBlobs = 0; % 0 equals no, 1 equals yes

SelectEdge(NameE,RemoveBlobs); % function must be located in working directory
%%% Follow the instructions appearing in command window.

%%% CHOOSE BEST IMAGE!
% The image selection is filtered and saved (Name_selection.tif), but also
% further treated with a closing and a bridging algorithm. Use best image.

%%% IMPROVE MANUALLY IN AN IMAGE EDITOR!
% Remove all remaining artefacts. Compare to original image to see what
% does not belong to the targeted wiggles.


%% Extract scale of the image
%%%INPUTS%%%
% Name = 'Greilum mesh grid 2'; % INPUT NAME OF TEM-IMAGE or comment out to use above setting
Basename = SaveNameEdge;% 'GreilumEDGE3'; % INPUT BASIC NAME FOR MATLAB FILE
LengthScale = 5; % LENGTH OF THE SCALE-BAR IN THE IMAGE IN µm

GetScale(Name,LengthScale,Basename) % function must be located in working directory
%%% Follow the instructions appearing in command window.


%% Create a straightened function out of the image of curved edges
%%%INPUTS%%%
NameS = [SaveNameEdge 'edt2'];% 'GreilumEDGE2edt'; % INPUT NAME OF IMAGE
% Use the manually cleaned image of your edge selection
Basename = SaveNameEdge; %'GreilumEDGE2';% INPUT BASIC NAME FOR MATLAB FILE
Order = 7; %edt1:10; edt2:7 % ORDER OF POLYNOMAIL TO BE FITTED TO THE CELL SHAPE
% Roughly choose a number that fitts the number of local maxima and minma
% of the cell shape visible in the TEM image. Adjust if neccessary.

Straighten(NameS,Order,Basename); % function must be located in working directory


%% Scale, split function into connected pieces, sort values:
%%%INPUTS%%%
MinMagnitude = 0.4; % MIN. ORDER OF MAGNITUDE OF WIGGLES IN µm
% Basename = 'GreilumEDGE2'; % INPUT BASIC NAME FOR MATLAB FILE

SplitAndSort(Basename, MinMagnitude); % function must be located in working directory


%% The End
% Now the analysis of the extracted, cleaned, straightened and sorted edges
% can begin in another program.


