function MAIN_Wiggle_PCA
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
%Wiggles = N.Wiggles; Maxima = N.Maxima; Minima = N.Minima; Widths =
%N.Widths; Centers = N.Centers; Sizes = N.Sizes;
Wiggles1 = N1.Wiggles; Centers1 = N1.Centers; Minima1 = N1.Minima;
MeanMin1 = [mean([Minima1(1:(length(Minima1)-1),1) Minima1(2:length(Minima1),1)],2) mean([Minima1(1:(length(Minima1)-1),2) Minima1(2:length(Minima1),2)],2)];
%
N2 = load(LoadName2); % load data
Wiggles2 = N2.Wiggles; Centers2 = N2.Centers; Minima2 = N2.Minima;
MeanMin2 = [mean([Minima2(1:(length(Minima2)-1),1) Minima2(2:length(Minima2),1)],2) mean([Minima2(1:(length(Minima2)-1),2) Minima2(2:length(Minima2),2)],2)];
%
N3 = load(LoadName3); % load data
Wiggles3 = N3.Wiggles; Centers3 = N3.Centers; Minima3 = N3.Minima;
MeanMin3 = [mean([Minima3(1:(length(Minima3)-1),1) Minima3(2:length(Minima3),1)],2) mean([Minima3(1:(length(Minima3)-1),2) Minima3(2:length(Minima3),2)],2)];
%
N4 = load(LoadName4); % load data
Wiggles4 = N4.Wiggles; Centers4 = N4.Centers; Minima4 = N4.Minima;
MeanMin4 = [mean([Minima4(1:(length(Minima4)-1),1) Minima4(2:length(Minima4),1)],2) mean([Minima4(1:(length(Minima4)-1),2) Minima4(2:length(Minima4),2)],2)];

N5 = load(LoadName5); % load data
Wiggles5 = N5.Wiggles; Centers5 = N5.Centers; Minima5 = N5.Minima;
MeanMin5 = [mean([Minima5(1:(length(Minima5)-1),1) Minima5(2:length(Minima5),1)],2) mean([Minima5(1:(length(Minima5)-1),2) Minima5(2:length(Minima5),2)],2)];
%
N6 = load(LoadName6); % load data
Wiggles6 = N6.Wiggles; Centers6 = N6.Centers; Minima6 = N6.Minima;
MeanMin6 = [mean([Minima6(1:(length(Minima6)-1),1) Minima6(2:length(Minima6),1)],2) mean([Minima6(1:(length(Minima6)-1),2) Minima6(2:length(Minima6),2)],2)];
%
N7 = load(LoadName7); % load data
Wiggles7 = N7.Wiggles; Centers7 = N7.Centers; Minima7 = N7.Minima;
MeanMin7 = [mean([Minima7(1:(length(Minima7)-1),1) Minima7(2:length(Minima7),1)],2) mean([Minima7(1:(length(Minima7)-1),2) Minima7(2:length(Minima7),2)],2)];


AllWiggles = vertcat(Wiggles1, Wiggles2, Wiggles3, Wiggles4, Wiggles5, Wiggles6, Wiggles7);
AllCenters = vertcat(Centers1, Centers2, Centers3, Centers4, Centers5, Centers6, Centers7);
AllMeanMin = vertcat(MeanMin1, MeanMin2, MeanMin3, MeanMin4, MeanMin5, MeanMin6, MeanMin7);


%% Preparation of data
Number = size(AllWiggles,1);

SWiggles1 = AllWiggles(:,:,1); % initialise
SWiggles2 = AllWiggles(:,:,1); % initialise

for i=1:Number; % shift wiggles so that each center lies on (0/0)
    SWiggles1(i,:) = AllWiggles(i,:,1) - AllMeanMin(i,1);
    SWiggles2(i,:) = AllWiggles(i,:,2) - AllMeanMin(i,2);
end


%% Calculate and plot mean
figure; plot(SWiggles1',SWiggles2');

MeanWX = mean(SWiggles1,1);
MeanWY = mean(SWiggles2,1);
figure; plot(MeanWX,MeanWY); title('Average wiggle'); xlabel('m'); ylabel('m')


%% Shrink data set if wanted
SWiggles1 =  SWiggles1(:,1:5:100); % change the size of the array
SWiggles2 =  SWiggles2(:,1:5:100);


% %% Singular Value Decomposition
% [U1,S1,V1] = svd(SWiggles1);
% [U2,S2,V2] = svd(SWiggles2);


%% PCA and Plot
[vecX,varianceX] = PCAprocedure(SWiggles1);
[vecY,varianceY] = PCAprocedure(SWiggles2);


%% Reconstruct eigenwiggles
%X
percent_explainedX = 100*varianceX/sum(varianceX);
XCutoff = (percent_explainedX>=10);
SingValMatX = diag(sqrt(varianceX.*XCutoff));
XX = SingValMatX*vecX';
XXX = mean(XX,1);

%Y
percent_explainedY = 100*varianceY/sum(varianceY);
YCutoff = (percent_explainedY>=10);
SingValMatY = diag(sqrt(varianceY.*YCutoff))*1.5;
YY = SingValMatY*vecY';
YYY = mean(YY,1);

figure; plot(XXX,YYY); title('Strongest variation'); xlabel('m'); ylabel('m')
figure; plot(mean(SWiggles1,1),mean(SWiggles2,1),'r','LineWidth',3); title('Average wiggle and eigenwiggle variation'); xlabel('m'); ylabel('m')
hold on
plot(XX(1,:)+mean(SWiggles1,1),YY(1,:)+mean(SWiggles2,1),'--b','LineWidth',2);
plot(XX(1,:)+mean(SWiggles1,1),YY(2,:)+mean(SWiggles2,1),':b','LineWidth',2);
plot(XX(2,:)+mean(SWiggles1,1),YY(1,:)+mean(SWiggles2,1),'--g','LineWidth',2);
plot(XX(2,:)+mean(SWiggles1,1),YY(2,:)+mean(SWiggles2,1),':g','LineWidth',2);

clear all



%% 
% XX = scoreX*diag(sqrt(varianceX))*vecX';
% YY = scoreY*diag(sqrt(varianceY))*vecY';
% XXX = mean(XX,1);
% YYY = mean(YY,1);
% 
% figure; plot(XXX,YYY); title('Strongest variation'); xlabel('m'); ylabel('m')
% figure; plot(XXX+mean(SWiggles1,1),YYY+mean(SWiggles2,1)); title('Average wiggle and variation'); xlabel('m'); ylabel('m')
% 

% %X
% percent_explainedX = 100*varianceX/sum(varianceX);
% XCutoff = (percent_explainedX>=10);
% ReconstructX = vecX(:,XCutoff)*varianceX(XCutoff); 
% %Y
% percent_explainedY = 100*varianceY/sum(varianceY);
% YCutoff = (percent_explainedY>=10);
% ReconstructY = vecY(:,YCutoff)*varianceY(YCutoff); 
% 
% figure; plot(ReconstructX,ReconstructY); title('Strongest variation'); xlabel('m'); ylabel('m')
% figure; plot(ReconstructX'+mean(SWiggles1,1),ReconstructY'+mean(SWiggles2,1)); title('Average wiggle and variation'); xlabel('m'); ylabel('m')
% %plot(SWiggles1',SWiggles2');


% SWiggles1 = (SWiggles1 - repmat(AllCenters(:,1),[1 size(SWiggles1,2)]));
% SWiggles2 = (SWiggles2 - repmat(AllCenters(:,2),[1 size(SWiggles2,2)]));
% 
% SWiggles1 = bsxfun(@minus,SWiggles1,AllCenters(:,1)); %# subtract the mean
% SWiggles2 = bsxfun(@minus,SWiggles2,AllCenters(:,2)); %# subtract the mean


















