function MAIN_Plot_Results_OneImage
% Plot the results stored in the .mat file


%% Load data of one image and plot

%%%INPUTS%%%
Basename = 'GreilumEDGE3toby';

% load matlab file
LoadName1 = [Basename '.mat'];
N = load(LoadName1); % load data
%Wiggles = N.Wiggles; Maxima = N.Maxima; Minima = N.Minima; Widths = N.Widths; Centers = N.Centers;
Sizes = N.Sizes;
clear N LoadName1

% Plot
figure('Name',Basename,'NumberTitle','off')
subplot(2,3,1); hist(Sizes(:,1))
title(['Height mean ' num2str(mean(Sizes(:,1))) ', std ' num2str(std(Sizes(:,1)))])
subplot(2,3,2); hist(Sizes(:,2))
title(['Width mean ' num2str(mean(Sizes(:,2))) ', std ' num2str(std(Sizes(:,2)))])
subplot(2,3,3); hist(Sizes(:,3))
title(['Length mean ' num2str(mean(Sizes(:,3))) ', std ' num2str(std(Sizes(:,3)))])
subplot(2,3,4); hist(Sizes(:,4))
title(['DisplacementMax mean ' num2str(mean(Sizes(:,4))) ', std ' num2str(std(Sizes(:,4)))])
subplot(2,3,5); hist(Sizes(:,5))
title(['DisplacementWidth mean ' num2str(mean(Sizes(:,5))) ', std ' num2str(std(Sizes(:,5)))])
subplot(2,3,6); title(['Number analysed wigggels: ' num2str(length(Sizes(:,1)))])

%Sizes = zeros(1,5); 
%sizes(n,:) = [Height Width Length DisplacementMax DisplacementWidth];
%Wiggles = zeros(1,NrPointsPerSection,2); Widths = zeros(1,2,2); Centers = zeros(1,2); Maxima = zeros(1,2); Minima = zeros(1,2);


clear all
