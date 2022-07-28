% The kernel density estimate
% of the observed distribution is compared against
% the distribution expected from random pairs
% (100 Monte Carlo samples) to identify statistically
% significantly overrepresented regions.

% The script expects in the workspace a two-column matrix named "A" with intensity value pairs (cFos,
% deltaFosB immunofluorescence) from many neurons. Use Matlab's Import Data
% function to load the contents of an Excel file to the workspace (output type: numeric matrix).

% Created by Thomas Oertner, 2022


% Create a two-column vector of points at which to evaluate the density.
if 0 %CA1
    gridx1 = -10:1:80;
    gridx2 = -50:1:20;
else %DG
    gridx1 = -10:1:80;
    gridx2 = -20:1:50;
end

[x1,x2] = meshgrid(gridx1, gridx2);
x1 = x1(:);
x2 = x2(:);
xi = [x1 x2];

% randomize pairs (once)
B=A(:,1);
C=A(:,2);
sB=B(randperm(length(B)));
sC=C(randperm(length(C)));
sA=[sB sC];

% Plot the estimated density of the sample data.
figure(67);
colormap jet;
subplot(1,3,1);
ksdensity(A,xi,'BoundaryCorrection','reflection');
s = findobj(gca,'Type','surface');
s.EdgeColor = 'none';
view(2);
axis tight;
title ('actual data');
xlabel cFos;
ylabel deltaFosB;
s=subplot(1,3,2);
ksdensity(sA,xi,'BoundaryCorrection','reflection');
s = findobj(gca,'Type','surface');
s.EdgeColor = 'none';
view(2);
axis tight;
title ('scrambled data');
xlabel cFos;
ylabel deltaFosB;


 [fA,xA]=ksdensity(A,xi,'BoundaryCorrection','reflection');
 [fB,xB]=ksdensity(sA,xi,'BoundaryCorrection','reflection');
 h=[length(gridx2),length(gridx1)];
% fAA=reshape(fA,h);
% fBB=reshape(fB,h);
% f=fAA-fBB;
% subplot(1,3,3);
% surf(f,'EdgeColor','none');
% view(2);
% colorbar;
% axis tight;
% title ('actual - scrambled');
% xlabel cFos;
% ylabel deltaFosB;



% randomize pairs many times to calculate Z score
B=A(:,1);
C=A(:,2);
runs=100;
sG=zeros(runs,length(gridx2),length(gridx1));

for i=1:runs
    sB=B(randperm(length(B)));
    sC=C(randperm(length(C)));
    G=[sB sC];
    [fG,xG]=ksdensity(G,xi,'BoundaryCorrection','reflection');
    fG=reshape(fG,h);
    sG(i,:,:)=fG;
end

scram=squeeze(mean(sG,1));
subplot(1,3,2);
surf(gridx1, gridx2, scram,'EdgeColor','none');
view(2);
axis tight;
title ('scrambled data');
xlabel cFos;
ylabel deltaFosB;

fAA=reshape(fA,h);
sG(1,:,:)=fAA; % add the acutal data to the many scambled versions
[Z,mu,sigma] = zscore(sG);
subplot(1,3,3);
P=squeeze(Z(1,:,:));  % the Z-score of the actual data compared to the scrambeled versions
P(1,1)=10; % hack to fix the color scale
P(1,2)=-10;
surf(gridx1, gridx2, P,'EdgeColor','none');
view(2);
colorbar;
axis tight;
title ('Z score');
zlabel Z-score;
xlabel cFos;
ylabel deltaFosB;


