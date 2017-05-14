function MAIN_Analyse_Edges
% Sript designed to analyse the shape of wiggles on plant cell walls (TEM
% images) that make up a diffraction grating. The direction and amount of
% variation from the average shape is evaluated.


%%%INPUTS%%%
basename = 'GreilumEDGE3';
%Nr. of files \ pieces of this image
Number = 5;
% define relative parameter for the filter-window size
WinParameter = 9;
% define size for min. extrema difference
Delta = 8*1e-8;
% choose nr. of points per wiggle
NrPointsPerSection = 100;
% part (e.g. quarter) of height of wiggle that is used to average width
HPart = 3;


%% Load data of one image and analyse
% initialise
Wiggles = zeros(1,NrPointsPerSection,2); Sizes = zeros(1,5); Widths = zeros(1,2,2); Centers = zeros(1,2); Maxima = zeros(1,2); Minima = zeros(1,2);

for n = 1:Number;
    imagenr = n;

    % Load program to format and describe edges
    [wiggles, maxima, minima, widths, centers, sizes] = SingleOutWiggles(basename, imagenr, WinParameter, Delta, NrPointsPerSection, HPart);
    %sizes(n,:) = [Height Width Length DisplacementMax DisplacementWidth]

    % append data of this loop to previous data
    Wiggles = vertcat(Wiggles,wiggles); Sizes = vertcat(Sizes,sizes); Widths = vertcat(Widths,widths); Centers = vertcat(Centers,centers); Maxima = vertcat(Maxima,maxima); Minima = vertcat(Minima,minima); 

end

% delete initialisation
Wiggles(1,:,:) = []; Sizes(1,:) = []; Widths(1,:,:) = []; Centers(1,:) = []; Maxima(1,:) = []; Minima(1,:) = [];


%% Save as matlab file
save([basename '.mat'], 'Wiggles', 'Maxima', 'Minima', 'Widths', 'Centers', 'Sizes');