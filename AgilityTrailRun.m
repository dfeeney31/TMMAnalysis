%%%%%%% Importing and analyzing data from TMM for Agility Trail skater movement %%%%%%

%%%%% FP, Peak Shear force, and RFD shear during the propulsive phase. 

clear
addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\TMM Files')  
forceData = importForces('C:\Users\Daniel.Feeney\Dropbox (Boa)\Endurance Protocol Trail Run\DaveLongProtocolAgility\DaveDualModSkate2_T4 - TriangleForces.txt');


%% Conversion and creating variables
forceData.ForceZ = -1 * forceData.LForceZ;
forceData.shear = abs(forceData.LForceY) + abs(forceData.LForceX);

forceData.ForceZ2 = -1 * forceData.RForceZ2;
forceData.shear2 = abs(forceData.RForceY2) + abs(forceData.RForceX2);
%% set thresholds for when true force is applied
forceData.ForceZ(forceData.ForceZ<15) = 0;
forceData.shear(forceData.shear<15) = 0; 
forceData.ForceZ2(forceData.ForceZ2<15) = 0;
forceData.shear2(forceData.shear2<15) = 0; 

%% find takeoffs and land

allZeros = find(forceData.ForceZ == 0);
landing = zeros(1,2);
for i = 1:length(allZeros)
    tmp_zero = allZeros(i); %Grab this zero to use as an index
    if forceData.ForceZ(tmp_zero + 1) > 1;
        landing(1) = tmp_zero;
    end
end


% Take off
TO = zeros(1,2);
for i = 2:length(allZeros)
    
    tmp_zero = allZeros(i); %Grab this zero to use as an index
    if forceData.ForceZ(tmp_zero - 1) > 1;
        TO(1) = tmp_zero;
    end

end

sum(forceData.ForceZ(landing:TO))
sum(forceData.shear(landing:TO))
%% do the same for second force plate
allZeros = find(forceData.ForceZ2 == 0);
for i = 1:length(allZeros)

    tmp_zero = allZeros(i); %Grab this zero to use as an index
    if forceData.ForceZ2(tmp_zero + 1) > 1;
        landing(2) = tmp_zero;
    end

end

for i = 2:length(allZeros)
    
    tmp_zero = allZeros(i); %Grab this zero to use as an index
    if forceData.ForceZ2(tmp_zero - 1) > 1;
        TO(2) = tmp_zero;
    end

end

%% 

Time_On_FP = (TO - landing) ./ 1000; 
[shearPeaks, shearLocs] = findpeaks(forceData.shear, 'minpeakHeight', 250, 'minpeakdistance',1000)
[shearPeaks2, shearLocs2] = findpeaks(forceData.shear2, 'minpeakHeight', 250, 'minpeakdistance',1000)
shearPeaks(2) = shearPeaks2;

RFD_shear = zeros(1,2);
RFD_shear(1) = (forceData.shear(shearLocs(1)) - forceData.shear(shearLocs(1)-100)) / 0.1;
RFD_shear(2) = (forceData.shear(shearLocs(1)) - forceData.shear(shearLocs(1)-100)) / 0.1;

output = [Time_On_FP', shearPeaks', RFD_shear']


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%