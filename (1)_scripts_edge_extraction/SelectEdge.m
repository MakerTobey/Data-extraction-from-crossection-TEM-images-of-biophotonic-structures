function SelectEdge(Name,RemoveBlobs) 
% program to select object of interest

%%% Follow the instructions appearing in command window.

%% import figure and settings
BW = imread([Name '.tif']); % input edges
plot_size = get(0,'ScreenSize'); % input screensize


%% edit edges & save
if RemoveBlobs
    BW1 = bwareaopen(BW,100); % remove small blobs
    imwrite(BW1,[Name '-blobs.tif'],'tif'); % save image for quality check
else
    BW1 = BW;
end

%% select area of interest freehand & save
disp('Please select the area of interest free hand.')
figure, imshow(BW1); % show all edges
set(figure(1), 'Color', [1 1 1], 'Position', plot_size, 'Visible', 'on'); % set figure to screensize
manualMask = imfreehand; % make window interactive for selection
% from here on, include selection into image
posns = getPosition(manualMask);
close % close figure
[m,n,~] = size(BW1);
includeMask = poly2mask(posns(:,1),posns(:,2),m,n);
BW2 = BW1 & includeMask;
imwrite(BW2,[Name '_selection.tif'],'tif'); % save result


%% close edge sections & save
% m = 1; % nr. of times, morphological operation is applied on B&W image
% BW3 = bwmorph(BW2,'close',m); % morphological operation
% imwrite(BW3,[Name '_selection_close.tif'],'tif'); % save result
% BW3 = bwmorph(BW3,'bridge',m); % morphological operation
% imwrite(BW3,[Name '_selection_bridge.tif'],'tif'); % save result

clear all
