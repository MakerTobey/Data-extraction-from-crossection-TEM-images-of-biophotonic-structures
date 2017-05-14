function frepaired = RepairSorting(fsorted)
% Resort the sorted pieces (by their x value) if y-gaps make problems

% define distance for gaps:
MinGap = 50;

% find x-gaps much grater than average, indicating a wrong sorting.
XDist = fsorted(2:length(fsorted),1) - fsorted(1:(length(fsorted)-1),1); % calculate x-distance of neighboring points x(n)-x(n-1)
IndDist = find(abs(XDist)>mean(XDist)*MinGap); % find idices for gaps in the array that are greater than the minimum feature size
IndDist = [0; IndDist; length(fsorted)]; % add first and last value
IndEnds = [IndDist(1:(length(IndDist)-1))+1; IndDist(2:(length(IndDist)))]; % save indicees of start and end points
IndHalf = length(IndDist)-1; % define index after which the end (not start) values start in the array

frepaired = [fsorted(:,1) zeros(length(fsorted),1)]; % initialise
ftemp = fsorted; % initialise

% plot inputs
%plot(ftemp(IndEnds,1),ftemp(IndEnds,2),'.'); hold on
%plot(fsorted(:,1),fsorted(:,2),'b')

[~,I] = min(ftemp(IndEnds,1)); % find minimum x value
% create first entry
if I<=IndHalf % see if picked start of next piece
    LEngth = (IndEnds(I+IndHalf)-IndEnds(I)+1);
    frepaired(1:LEngth,:) = fsorted(IndEnds(I):IndEnds(I+IndHalf),:);
    LastInd = [I I+IndHalf]; % initialise
else % if end was picked - reverse piece
    LEngth = length(IndEnds(I-IndHalf):IndEnds(I));
    frepaired(1:LEngth,:) = fsorted(IndEnds(I):-1:IndEnds(I-IndHalf),:);
    LastInd = [I I-IndHalf]; % initialise
end % look again from the new end
Occupied = LEngth; % initialise
ftemp(IndEnds(LastInd),1) =  inf;% set x value of sorted element to infinity

% for all connected pieces, sort around y-gaps
for m=2:(length(IndDist)-1)
    % from end of piece, find end or start of any pice that nearest
    [~,I] = min(ftemp(IndEnds,1)); % find next minimum x value
    if I<=IndHalf % see if picked start of next piece
        LEngth = (IndEnds(I+IndHalf)-IndEnds(I)+1);
        frepaired(Occupied+1:Occupied+LEngth,:) = fsorted(IndEnds(I):IndEnds(I+IndHalf),:);
        LastInd = [I I+IndHalf];
    else % if end was picked - reverse piece
        LEngth = length(IndEnds(I-IndHalf):IndEnds(I));
        frepaired(Occupied+1:Occupied+LEngth,:) = fsorted(IndEnds(I):-1:IndEnds(I-IndHalf),:);
        LastInd = [I I-IndHalf];
    end % look again from the new end
    Occupied = Occupied + LEngth; % count how many indicees are occupied yet
    ftemp(IndEnds(LastInd),1) =  inf;% set x value of sorted element to infinity
end

% plot outputs
% plot(frepaired(:,1),frepaired(:,2),'r')

clear fraw D A LastInd XDist INP IndDist IndEnds IndHalf Occupied ftemp fsorted LEngth MinGap