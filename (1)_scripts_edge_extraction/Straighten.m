function Straighten(Name,order,basename)
% Function to create a straightened function/array (fnormal) out of an
% image of curved edges (img). The input curve is straightened normal to a
% fittet polynomial of the input order (order) and saved into a matlab file
% (basename_normal.m).

%% import edges
img = imread([Name '.tif']);


%% get coordinates of edge (value 1) in black and white image
[y, x] = find(img == 1); 
x = -x; %flip axsis the right way round


%% rotate data along eigen-axis (linear main direction - no scaling)
COV = cov([x y]); % 2D covairance matrix
[V, L] = eig(COV); % eigenvectors and eigenvalues diag(L)
[~, idx] = sort(diag(L), 'descend'); % sort eigenvalues according to the amount of variance they explain for
frotated = [x y] * V(:, idx); % koordinate transform into the direction of most data points (= rotation without scaling)


%% describe data in terms of normal distance from a polynomial fit of the cell shape
p = polyfit(frotated(:,1), frotated(:,2), order); % fit polynomial to the rotated pattern. Use a polinomial of the order "order".

    % plot the polynomial to see if the choice of its order was appropriate:
    xp = (min(frotated(:,1)):max(frotated(:,1)))'; %  to display the polynomial, create an x-value array between the highest and the lowest x-value of the polynomial
    yp = polyval(p, xp); % read out associated y-values
    figure, plot(frotated(:,1),frotated(:,2),'.') % plot data (dotted)
    title(sprintf('Polynomial fit of the order %d',order));
    hold on; plot(xp,yp,'r'); hold off % plot points on polinomial (line in red)
    
% create a high resolution of points following the polynomial function
xp = (min(frotated(:,1))-50:.25:max(frotated(:,1))+50)'; % resolution 0.25 pixel and 50 additional pixels on each side of the image
yp = polyval(p, xp); % read out associated y-values

% create derivation and array to describe scaled x-values along polynomial
dp = diff([xp yp]); % derivation of the polynomial (numeric difference function)
% T = [0 1; -1 0]; dp = dp*T; % swap x and y and change sign of y deriviation
XPcum = [0;cumsum(sqrt(sum(dp.^2,2)))]; % new x-achsis values: cummulative distance between polynomial data points
dp = [dp(1,:);dp]; % add an element to compensate for the loss of one value during derivation/difference calculation

% for each datapoint, find new y- (and x-, see above) value normal to polynomial
fnormal = frotated; % initialise
for n = 1:length(x) % for each datapoint
    Difference = [xp yp] - repmat(frotated(n,:),length(xp),1); % difference of point n to each point on the polynomial
    [minval, ind] = min(sum(Difference.^2,2)); % find the point of the polynomial with minimal quadratic distance
    Sign = sign( [-dp(ind,2) dp(ind,1)] * (frotated(n,:)-[xp(ind) yp(ind)])' ); % evaluate signum according the point's position relative to the polynomial and flip x-sign if the polinomial is localy ascending
    NormalDistance = sqrt(minval) * Sign; % evaluate distance and add signum
    fnormal(n,1) = XPcum(ind);
    fnormal(n,2) = NormalDistance;
end

    % plot
    figure, plot(fnormal(:,1), fnormal(:,2), 'm.')
    title('Final wiggles after calculation of a normal distance from the polynomial fit')


%% save calculated matrices
savefile = [basename '_straightened' '.mat'];
save(savefile, 'fnormal')

% clear workspace
clear all
%clear xp yp x y V L dp XPcum Difference NormalDistance Sign p COV idx ind minval frotated
