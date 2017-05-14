function SplitAndSort(Basename, MinMagnitude)
% function to determain connected pieces, scale image and sort values by
% distance

% load curve (matlab file)
LoadName1 = [Basename '_straightened'];
N = load(LoadName1); % load data
fnormal = N.fnormal;
clear N LoadName1

% load scale (matlab file)
LoadName2 = [Basename '_scale'];
S = load(LoadName2); % load data
PixelPerUM = S.PixelPerUM; % pixel is equivalent to x values
clear S LoadName2

% plot(fnormal(:,1),fnormal(:,2),'.'); hold on;
% plot(fnormal(:,1),fnormal(:,2),'r'); hold off;


%% order the x-values and shift to zero
fxsorted = sortrows(fnormal);
CY = min(fxsorted(:,2)); % find minimum y value
[CX,~] = min(fxsorted(:,1)); % find minimum x value
fxsorted = [fxsorted(:,1)-CX fxsorted(:,2)-CY]; % shift to zero if neccessary
clear CX CY fnormal

% plot(1:length(fxsorted),fxsorted(:,1),'b'); hold on;
% plot(1:length(fxsorted),fxsorted(:,2),'r'); hold off;


%% Find connected pieces in the array
MinPeakPixelDistance = ceil(MinMagnitude*PixelPerUM);
XDist = fxsorted(2:length(fxsorted),1) - fxsorted(1:(length(fxsorted)-1),1); % calculate x-distance of neighboring points x(n)-x(n-1)
IndDist = find(XDist>MinPeakPixelDistance); % find idicees for gaps in the array that are greater than the minimum feature size
IndDist = [0; IndDist; length(fxsorted)]; % add first and last value

NrFragments = length(IndDist)-1
% plot(1:(length(fxsorted)),fxsorted(:,1),'b'); hold on;
% plot(2:(length(fxsorted)),XDist,'g'); hold off;
clear XDist

% for all connected pieces, sort, scale and save:
PieceInd = zeros((length(IndDist)-1),2); % initialise
for n=1:(length(IndDist)-1)
    % defince piece
    PieceInd(n,:) = [IndDist(n)+1 (IndDist(n+1))]; % read out piece border indicees
    PieceN = fxsorted(PieceInd(n,1):PieceInd(n,2),:);

    
    %% Resort the values into an order
    fsortedN = SortDistance(PieceN);

% plot(1:length(fsortedN),fsortedN(:,1)-min(fsortedN(:,1)),'b'); hold on;
% plot(1:length(fsortedN),fsortedN(:,2),'r'); hold off;


    %% Scale X and Y to meter instead of pixel
    fN = fsortedN*(PixelPerUM^-1)*1E-6;

% plot(1:length(fN),fN(:,1)-min(fN(:,1)),'b'); hold on;
% plot(1:length(fN),fN(:,2),'r'); hold off;
    

    %% save into ASCI file
    FILEname = [Basename '_piece_' int2str(n) '.txt'];
    save(FILEname, 'fN', '-ASCII');

end

clear all