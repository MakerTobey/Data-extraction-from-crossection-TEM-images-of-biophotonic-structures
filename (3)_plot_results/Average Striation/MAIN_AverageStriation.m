function MAIN_AverageStriation
% Plot the results stored in the .mat file

%% Load data of all images get combined values

%%%INPUTS%%%
Name = 'Greilum striation shape'; % overall name
LoadName1 = 'GreilumEDGE234';
LoadName2 = 'GreilumEDGE6';
LoadName3 = 'GreilumEDGE7';
LoadName4 = 'GreilumEDGE8';
LoadName5 = 'GreilumEDGE9';
LoadName6 = 'GreilumEDGE10';
LoadName7 = 'GreilumEDGE12';

% load matlab files
N1 = load(LoadName1); % load data
Wiggles1 = N1.Wiggles; Centers1 = N1.Centers;
%
N2 = load(LoadName2); % load data
Wiggles2 = N2.Wiggles; Centers2 = N2.Centers;
%
N3 = load(LoadName3); % load data
Wiggles3 = N3.Wiggles; Centers3 = N3.Centers;
%
N4 = load(LoadName4); % load data
Wiggles4 = N4.Wiggles; Centers4 = N4.Centers;

N5 = load(LoadName5); % load data
Wiggles5 = N5.Wiggles; Centers5 = N5.Centers;
%
N6 = load(LoadName6); % load data
Wiggles6 = N6.Wiggles; Centers6 = N6.Centers;
%
N7 = load(LoadName7); % load data
Wiggles7 = N7.Wiggles; Centers7 = N7.Centers;


AllWiggles = vertcat(Wiggles1, Wiggles2, Wiggles3, Wiggles4, Wiggles5, Wiggles6, Wiggles7);
AllCenters = vertcat(Centers1, Centers2, Centers3, Centers4, Centers5, Centers6, Centers7);


%% Preparation of data
Number = size(AllWiggles,1);

SWiggles1 = AllWiggles(:,:,1); % initialise
SWiggles2 = AllWiggles(:,:,1); % initialise

for i=1:Number; % shift wiggles so that each center lies on (0/0)
    SWiggles1(i,:) = AllWiggles(i,:,1) - AllCenters(i,1);
    SWiggles2(i,:) = AllWiggles(i,:,2) - AllCenters(i,2);
end

MeanWX = mean(SWiggles1*1E6,1);
MeanWY = mean(SWiggles2*1E6,1);

% conversion to coordinates from leftmost point
MeanWX = MeanWX - MeanWX(1);
MeanWY = MeanWY - MeanWY(1);

%% Calculate and plot mean

figure; plot(SWiggles1',SWiggles2'); axis equal;

figure; h2 = plot(MeanWX,MeanWY); title(['Average ' Name]); xlabel('\mum'); ylabel('\mum');
axis([-0.1 1.6 -0.1 1.6], 'equal'); %axis equal;
set(h2,'Color','blue','LineWidth',2)



