% simulate inhibtion of cFos by fosB
% calculate map similarity for different dt

% Created by Thomas Oertner, 2021

size=100; % number of cells = size^2
timesteps=200; % duration of simulation ('hours')
plotOn=1; % do you want to see the simulation live? (slow, but fun)
val=[0.57,4.5,0.9]; %DG   (activity, cFos decay (%/h), fosB inhibition) 
%val=[7,15,100]; %CA1  (activity, cFos decay (%/h), fosB inhibition) 

cells=zeros(size,size);
cfos=zeros(size,size);
fosB=zeros(size,size);
tape=zeros(3,timesteps); % keep a record on tape

timelapse=zeros(size,size,timesteps); % large array
cfosMemory=zeros(size,size,timesteps); % large array

for i=1:timesteps
    activeCells=rand(size,size); % each cell has a random activity level between 0 and 1
    activeCells=activeCells>((100-val(1))/100); %binary map of most active ('bursting') cells (DG 0.7%, CA1 8%)
    cfos=activeCells.*(fosB < val(3)); %active cells express cFos only when fosB is low (<0.9)
    cells=(cells.*((100-val(2))/100))+cfos; %cFos expression decays exponentially (DG 4% per time step, CA1 15%)
    % half life = ln 2 / decay constant = 17.3 time units
    if i<10  % this is a cludge, we first have to build up some fosB memory before we can go back in time.
        fosB=(fosB.*0.992)+cfos; %fosB decays slowly (0.7% per time step)
    else
        fosB=(fosB.*0.992)+cfosMemory(:,:,i-3); %delayed fosB expression
    end
    cfosMemory(:,:,i)=cfos;
    timelapse(:,:,i)=cells>0.5;  %Memory of cFos expression patterns (binarized at 0.5)
    tape(1,i)=sum(sum(activeCells));
    tape(2,i)=sum(sum(cells>0.1));
    tape(3,i)=sum(sum(fosB));
    
    if plotOn 
        figure(5);
        subplot(2,2,1);
        imagesc(activeCells,[0 1]);
        title('random activity');
        
        subplot(2,2,3);
        imagesc(cells,[0 1]);
        title('cFos map');
        
        subplot(2,2,4);
        imagesc(fosB,[0 1]);
        title('fosB map');
    end
    
end

figure(8);
%plot(tape(1,:)./size^2);
hold on;
plot(tape(2,:)./size^2);
%plot((tape(3,:)./5)./size^2);

olap=zeros(1,timesteps);
expect=zeros(1,timesteps);
for j=2:timesteps
    e1=sum(sum(timelapse(:,:,200))); %how many neurons express cFos?
    % We are using frame 200 as reference, the system has to stabilize first...
    e2=sum(sum(timelapse(:,:,j)));
    expect(1,j)=(e1/size^2)*(e2/size^2);  %expected overlap (fraction of total cells)
    ol=sum(sum(timelapse(:,:,200).* timelapse(:,:,j))); %actual overlap
    olap(1,j)=ol/size^2; % actual overlap (fraction of total cells)
end
overchance=olap./expect;
figure(9);
hold on;
overchance=overchance(1,200:end);
x=[1:1:length(overchance)];
plot(x,overchance);
XTicksDistance = 6;
title('overlap/chance');
grid on;
