%% CMJ force analysis Agility 

clear
addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\TMM Files')  
forceData = importForces('C:\Users\Daniel.Feeney\Dropbox (Boa)\AgilityPerformance\NB Hierro\dualdial cmj 1 - TriangleForces.txt');

%%
%plot(forceData.LForceZ2)

forceData.ForceZ = -1 * forceData.LForceZ2;

%% set thresholds for when true force is applied
forceData.ForceZ(forceData.ForceZ<10) = 0;
plot(forceData.ForceZ)

allZeros = find(forceData.ForceZ == 0);
landing = zeros(1,6);
counterVar = 1;
for i = 1:length(allZeros)
    
    tmp_zero = allZeros(i); %Grab this zero to use as an index
    if forceData.ForceZ(tmp_zero + 1) > 1;
        landing(counterVar) = tmp_zero;
        counterVar = counterVar + 1; 
    end

end

% Take off
TO = zeros(1,6);
counterVar = 1;
for i = 2:length(allZeros)
    
    tmp_zero = allZeros(i); %Grab this zero to use as an index
    if forceData.ForceZ(tmp_zero - 1) > 1;
        TO(counterVar) = tmp_zero;
        counterVar = counterVar + 1; 
    end

end


Time_On_FP = (TO - landing) ./ 1000;
RFD_vert = zeros(1,6);
[vertPeaks, vertLocs] = findpeaks(forceData.ForceZ, 'minpeakHeight', 800, 'minpeakdistance',1000)
for jump = 1:length(vertPeaks)
    RFD_vert(jump) = (forceData.ForceZ(vertLocs(jump)) - forceData.ForceZ(vertLocs(jump)-100)) / 0.1;
end
if length(vertPeaks < 6)
    vertPeaks(6) = 0;
end

output = [Time_On_FP', vertPeaks, RFD_vert']


