%%%%%%% Importing and analyzing data from TMM %%%%%%

%%%%% TODO: export the Takeoff and Landing data at 1kHz with force to avoid
%%%%% losing some granularity. Output contains the three variables time on
%%%%% FP, Peak Shear force, and RFD shear during the propulsive phase. 

clear
addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\TMM Files')  
forceData = importForces('C:\Users\Daniel.Feeney\Dropbox (Boa)\AgilityPerformance\NB Hierro\dualdial triangle 1 - TriangleForces.txt');

noLandings = 4;
%% Conversion and creating variables
forceData.ForceZ = -1 * forceData.LForceZ;
forceData.shear = abs(forceData.LForceY) + abs(forceData.LForceX);
%% set thresholds for when true force is applied
forceData.ForceZ(forceData.ForceZ<10) = 0;
forceData.shear(forceData.shear<10) = 0; 

plot(forceData.ForceZ)
plot(forceData.shear)


%% find takeoffs and landings

allZeros = find(forceData.ForceZ == 0);
landing = zeros(1,noLandings);
counterVar = 1;
for i = 1:length(allZeros)
    
    tmp_zero = allZeros(i); %Grab this zero to use as an index
    if forceData.ForceZ(tmp_zero + 1) > 1;
        landing(counterVar) = tmp_zero;
        counterVar = counterVar + 1; 
    end

end

% Take off
TO = zeros(1,noLandings);
counterVar = 1;
for i = 2:length(allZeros)
    
    tmp_zero = allZeros(i); %Grab this zero to use as an index
    if forceData.ForceZ(tmp_zero - 1) > 1;
        TO(counterVar) = tmp_zero;
        counterVar = counterVar + 1; 
    end

end


Time_On_FP = (TO - landing) ./ 1000; Time_On_FP = Time_On_FP';
[shearPeaks, shearLocs] = findpeaks(forceData.shear, 'minpeakHeight', 300, 'minpeakdistance',1000)

RFD_shear = zeros(1,noLandings);
for jump = 1:noLandings
    RFD_shear(jump) = (forceData.shear(shearLocs(jump)) - forceData.shear(shearLocs(jump)-100)) / 0.1;
end

output = [Time_On_FP, shearPeaks, RFD_shear']


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%