function fsorted = SortDistance(fraw)
% Resort the values into an order

A = dot(fraw,fraw,2); % vector dot product for the vector calculation of distances below
D = sqrt(bsxfun(@plus,A,A')-2*(fraw*fraw')); % matrix containing all pairwise distances

fsorted = fraw; % initialise
[~,I] = min(fraw(:,1)); % find minimum x value
fsorted(1,:) = fraw(I,:); % create first entry

LastInd = I; % initialise
D(:,LastInd) = inf; % set distance of sorted element to infinity

for m=2:length(fraw);
    [~,I] = min(D(LastInd,:)); % find minima
    fsorted(m,:) = fraw(I,:);
    D(:,I) = Inf(length(fraw),1); % set distance of sorted element to infinity
    if mod(m,4)==0 % only every 4 runs
        LastInd = I; % use the new index for distance meansurements
    end % this way points with noise are included better
end

clear fraw D A LastInd