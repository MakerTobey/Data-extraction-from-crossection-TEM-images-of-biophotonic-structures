function MAIN_Plot_Results
% Plot the results stored in the .mat file



%% Load data of all images get combined values

%%%INPUTS%%%
Name = 'Mentzelia striations'; % overall name
LoadName1 = 'Mentzilia2';
LoadName2 = 'Mentzilia3';
LoadName3 = 'Mentzilia4';
LoadName4 = 'Mentzilia5';
LoadName5 = 'Mentzilia7';
LoadName6 = 'MentzeliaEDGE1';
LoadName7 = 'MentzeliaEDGE5';
LoadName8 = 'MentzeliaEDGE6';
LoadName9 = 'MentzeliaEDGE7';
LoadName10 = 'MentzeliaEDGE8';

% load matlab files
N1 = load(LoadName1); % load data
%Wiggles = N.Wiggles; Maxima = N.Maxima; Minima = N.Minima; Widths = N.Widths; Centers = N.Centers;
Sizes1 = N1.Sizes;
%
N2 = load(LoadName2); % load data
Sizes2 = N2.Sizes;
%
N3 = load(LoadName3); % load data
Sizes3 = N3.Sizes;
%
N4 = load(LoadName4); % load data
Sizes4 = N4.Sizes;
%
N5 = load(LoadName5); % load data
Sizes5 = N5.Sizes;
%
N6 = load(LoadName6); % load data
Sizes6 = N6.Sizes;
%
N7 = load(LoadName7); % load data
Sizes7 = N7.Sizes;
%
N8 = load(LoadName8); % load data
Sizes8 = N8.Sizes;
%
N9 = load(LoadName9); % load data
Sizes9 = N9.Sizes;
%
N10 = load(LoadName10); % load data
Sizes10 = N10.Sizes;

AllSizes = vertcat(Sizes1, Sizes2, Sizes3, Sizes4, Sizes5, Sizes6, Sizes7, Sizes8, Sizes9, Sizes10);


%% Plot
FullName = [Name '; ' num2str(length(AllSizes(:,1))) ' wigggels analysed'];
figure('Name',FullName,'NumberTitle','off')

subplot(1,3,1); hist(AllSizes(:,1)); xlim([0 2*1e-6]);
h1 = findobj(gca,'Type','patch');
set(h1,'EdgeColor','w');
title(['Height mean ' num2str(mean(AllSizes(:,1)),2) ', std ' num2str(std(AllSizes(:,1)),2)])

%%%%%%%%%%%%%%%%%%%%%
WIDTH = AllSizes(:,2);
WIDTH(WIDTH<0.05E-6) = [];
%%%%%%%%%%%%%%%%% DELETE ZEROS
subplot(1,3,2); hist(WIDTH); xlim([0 1.5*1e-6]);
h2 = findobj(gca,'Type','patch');
set(h2,'EdgeColor','w');
title(['Width mean ' num2str(mean(WIDTH),2) ', std ' num2str(std(WIDTH),2)])

subplot(1,3,3); hist(AllSizes(:,3)); xlim([0 2.5*1e-6]);
h3 = findobj(gca,'Type','patch');
set(h3,'EdgeColor','w');
title(['Period mean ' num2str(mean(AllSizes(:,3)),2) ', std ' num2str(std(AllSizes(:,3)),2)])


%% Plot distortion of wiggles
FullName2 = [Name ' distortion; ' num2str(length(AllSizes(:,1))) ' wigggels analysed'];
figure('Name',FullName2,'NumberTitle','off')

subplot(1,2,1); hist(AllSizes(:,4)); xlim([-40 40]);
h4 = findobj(gca,'Type','patch');
set(h4,'EdgeColor','w');
title(['Mean tilt ' num2str(mean(AllSizes(:,4)),2) '°, std ' num2str(std(AllSizes(:,4)),2)])

subplot(1,2,2); hist(AllSizes(:,5)); xlim([-5*1e-7 5*1e-7]);
h5 = findobj(gca,'Type','patch');
set(h5,'EdgeColor','w');
title(['Displacement width mean ' num2str(mean(AllSizes(:,5)),2) ', std ' num2str(std(AllSizes(:,5)),2)])


clear all
