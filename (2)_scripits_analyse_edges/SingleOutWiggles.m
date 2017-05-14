function [wiggles, maxima, minima, widths, centers, sizes] = SingleOutWiggles(basename, imagenr, WinParameter, Delta, NrPointsPerSection, HPart)
% function to:
% Smooth out curve and make frequenzy analysis.
% Locate wiggles (minima) and throw out border wiggles. It
% returns an array containing all seperate wiggles, represented by an equal
% number of points.
% It also returns a vector with maxima, one with minima and one index
% vector telling how the parts were put together.

% %sizes(n,:) = [Height Width Length DisplacementMax DisplacementWidth]


% load matlab file
fileToRead = [basename '_piece_' int2str(imagenr) '.txt'];
Data = importdata(fileToRead);

clear fileToRead


%% Repair sorting in case y-gaps from the maual cleanup make problems
frepaired = RepairSorting(Data);

clear Data


%% Filter x and y seperatelly to smooth curve
window = hamming(WinParameter,'symmetric');
window = window/sum(window); % normalize
% wvtool(win)
fsmooth = frepaired; % initialise
fsmooth(:,1) = conv(frepaired(:,1), window, 'same');
fsmooth(:,2) = conv(frepaired(:,2), window, 'same');

% plot smoothed/filtered curve
figure;
hold on;
plot(frepaired(:,1),frepaired(:,2),'k');
%plot(fsmooth(:,1),fsmooth(:,2),'r');
%hold off;

% Alternative:
% fsmooth2 = frepaired; % initialise
% fsmooth2(:,1) = smooth(frepaired(:,1),'rlowess');
% fsmooth2(:,2) = smooth(frepaired(:,2),'rlowess');
% plot(fsmooth2(:,1),fsmooth2(:,2),'g');

clear frepaired window


%% Detect extrema
[maxtab, mintab] = peakdet(fsmooth(:,2), Delta, 1:size(fsmooth(:,2)));
maxtab = maxtab(:,1); % use indicees only
mintab = mintab(:,1);

% extract coordiantes of Maxima and Minima
maxima = fsmooth(maxtab,:);
minima = fsmooth(mintab,:);

% plot extrema
%figure;
%hold on;
%plot(fsmooth(maxtab,1),fsmooth(maxtab,2),'.');
%plot(fsmooth(mintab,1),fsmooth(mintab,2),'.');
%plot(fsmooth(:,1),fsmooth(:,2),'r');
% hold off;


%% Cut off end-pixels before first and after last minimum
[~, IFirstMin] = min(fsmooth(mintab,1));
[~, ILastMin] = max(fsmooth(mintab,1));
EndLastMin = (mintab(ILastMin)+1):length(fsmooth);
OffsetFirstMin = 1:(mintab(IFirstMin)-1);

% delete points
fclean = fsmooth; % initialise
fclean([EndLastMin OffsetFirstMin],:) = [];

% clean up maxima vector
indEnd = find(maxtab>mintab(ILastMin,1));
indStart = find(maxtab<mintab(IFirstMin,1));
maxtab([indStart indEnd],:) = [];

% shift indicees for Extrema
maxtab= maxtab-length(OffsetFirstMin);
mintab= mintab-length(OffsetFirstMin);

% plot good part of smoothed curve and extrema on that section
plot(fclean(:,1),fclean(:,2),'r');
plot(fclean(maxtab,1),fclean(maxtab,2),'d','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',6);
plot(fclean(mintab,1),fclean(mintab,2),'d','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',6);
%hold off;

clear fsmooth IFirstMin ILastMin


%% Make wiggle vector and sizes vector
wiggles = zeros(length(maxtab),NrPointsPerSection,2); % initialise
sizes = zeros(length(maxtab),5); % initialise
widths = zeros(length(maxtab),2,2); % initialise
centers = zeros(length(maxtab),2); % initialise

for n=1:length(maxtab)
    temp = fclean(mintab(n):mintab(n+1),:); % extract one wiggle
    
    
    %% Wiggles: Generate fixed number of evenly spaced points along curve section to save wiggles
    % Interpolates new points at any fractional point along the curve
    % defined by a list of points in 2 or more dimensions.
    t = 0:(1/(NrPointsPerSection-1)):1;
    wiggles(n,:,:) = interparc(t,temp(:,1),temp(:,2));

    % plot evenly spaced points
    plot(wiggles(n,:,1),wiggles(n,:,2),'x');
    
    
    %% Sizes: Find height and width, length and displacement of wiggles
    Min1 = fclean(mintab(n),:);
    Min2 = fclean(mintab(n+1),:);
    Max = fclean(maxtab(n),:);
    MeanMin = mean([Min1; Min2]);
    
    % length: distance of minima.
    Length = norm(Min1 - Min2);

    % Height: distance of maximum to mean of minima
    Height = norm(Max - MeanMin);
    H = (Max - MeanMin) / norm(Max - MeanMin);  % normalised vector
    B = [H(2) -H(1)]; % normalised base-vector perpendicular to H but not necessarily equal N
    
    % x-displacement: angle between vertical and the connection between mean of minma and maximum
    DisplacementMax = asind( (MeanMin(1)-Max(1)) /Height); % arcsin in degr
%     % x-displacement: x-offset between mean of minma and maximum
%     DisplacementMax = MeanMin(1) - Max(1);
    
    % Width:
    % coordinate-transform points into relative positions to center point
    % in coordinate system aligned with height vector
    Center = MeanMin + ((Height/2)*H); % will be used further down!
    RelativePos = [(wiggles(n,:,1)' - Center(1))  (wiggles(n,:,2)' - Center(2))];
    TransfH = RelativePos*H';
    TransfB = RelativePos*B';
    % range of "Y values" to be used for averaging width (HPart-fraction-
    % interval of height)
    H1 = ((Height/HPart)/2);
    H2 = -((Height/HPart)/2);
    % split values in points for left and right. Assumtion: x-values don't overlap.
    % Choose only those points, that are within the height range on the left and on the right of the maximum
    TransfB2 = TransfB((TransfH<=H1)&(TransfH>=H2));
    [~, IndXDist] = max(TransfB2(2:length(TransfB2),1) - TransfB2(1:(length(TransfB2)-1),1)); % calculate max of x-distance of neighboring points x(n)-x(n-1)
    IndexVec = [ones(1,IndXDist) ones(1,length(TransfB2)-IndXDist)+1];
%alternative, but sorting works less well: IndexVec = kmeans(RelativePos(((TransfH<=H1)&(TransfH>=H2)),:)*1E9,2,'dist','sqeuclidean');
    WholeIndexVec = 1:size(TransfB); % initialise (important! so it doesn't become a vector that can only store logical values)
    WholeIndexVec(not((TransfH<=H1)&(TransfH>=H2))) = 0;
    WholeIndexVec(WholeIndexVec>0) = IndexVec;
    % Add average X components
    L = mean(TransfB(WholeIndexVec==1));
    R = mean(TransfB(WholeIndexVec==2));
    Width = abs(R - L);
    DisplacementWidth = R + L;
    
    sizes(n,:) = [Height Width Length DisplacementMax DisplacementWidth];
    
    % plot mean-min and regions for averaging the width
    plot(MeanMin(1),MeanMin(2),'d','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
     % reconstruct side-points
     Left = (TransfB(WholeIndexVec==1)*B) + (TransfH(WholeIndexVec==1)*H);
     Right =  (TransfB(WholeIndexVec==2)*B) + (TransfH(WholeIndexVec==2)*H);
    plot(Center(1)+Left(:,1),Center(2)+Left(:,2),'g.','MarkerSize',7);
    plot(Center(1)+Right(:,1),Center(2)+Right(:,2),'y.','MarkerSize',7);
%     % plot height-region of wiggles
%     plot(wiggles(n,((TransfH<=H1)&(TransfH>=H2)),1),wiggles(n,((TransfH<=H1)&(TransfH>=H2)),2),'g.','MarkerSize',7);

    
    %% define coordinates of widths and centers of wiggle
    centers(n,:) = Center;
    widths(n,:,1) = centers(n,:) + (B*L); % left
    widths(n,:,2) = centers(n,:) + (B*R); % right

    % plot widths and ceners
    plot(centers(n,1),centers(n,2),'d','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',5);
    plot(widths(n,1,1),widths(n,2,1),'s','MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',5);
    plot(widths(n,1,2),widths(n,2,2),'s','MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',5);

    
end

hold off; % terminate hold of plot

clear temp t maxtab mintab H1 H2 RelatvePosS1L RelatvePosS1R RelativePosS Center
clear L R MeanMin fclean H TransfH TransfB WholeIndexVec IndexVec TransfB2 IndXDist


%% FFT
% plot(fft(frepaired(:,1)),'r'); hold on
% plot(fft(frepaired(:,2)),'g');

%% more code
% watershed

