function [coefs,variance] = PCAprocedure(SWiggles)
%function to be used for X and Y values to:
%remove outlyers
%perform PCA
%plot results


%% Remove 5% of most extreme data points
%%% Hotelling's T2 - statistical measure of the multivariate distance of each observation from the center of the data set. This is an analytical way to find the most extreme points in the data.
% Example: % [st2, index] = sort(t2,'descend'); % Sort in descending order. % extreme = index(1)
Perc5 = round(size(SWiggles,1)/20); % determine 5%
[~,~,~,t2] = princomp(SWiggles); %[coefs,scores,variances,t2]
[~, index] = sort(t2,'descend'); % Sort in descending order.
NotExtreme = [1:size(SWiggles,1)]; % initialise
NotExtreme(index(1:Perc5)) = []; % delete extremes from index vector
SWiggles = SWiggles(NotExtreme,:); % redefine initial data to exclude the extreme 5%


%% Plot matrix as boxplot
figure; boxplot(SWiggles);%,'orientation','horizontal','labels',categories);


%% Perform PCA
[coefs,~,variance,~] = princomp(SWiggles); %[coefs,score,variance,t2]
%[coefs,score,variance,~]
%c3 = coefs(:,1:3) % display first three components (coefficients of the linear combinations of the original variables that generate the principal components)


%% Display original data in principal component coordinate system (princomp computes the scores to have mean zero)
% figure; plot(score(:,1),score(:,2),'+');
% xlabel('1st Principal Component')
% ylabel('2nd Principal Component')
% % gname%(names) % interactively select points, which index value or name (from a vector) will be displayed. Press "Return" to finish labeling.


%% Display explained amount of variance
percent_explained = 100*variance/sum(variance);
figure; pareto(percent_explained)
xlabel('Principal Component')
ylabel('Variance Explained (%)')


