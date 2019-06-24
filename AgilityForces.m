%%%%%%% Importing and analyzing data from TMM %%%%%%

%%%%% TODO: export the Takeoff and Landing data at 1kHz with force to avoid
%%%%% losing some granularity. Calculate Peak Power, and Work eccentric and
%%%%% concentric based on the COM power.... but we need better data before
%%%%% we can do this. 


forceData = importForces('TriangleTest - TriangleForces.txt');
kinData = importKinetics('TriangleTest - TriangleKinetics.txt');

%% Conversion and creating variables
forceData.ForceZ = -1 * forceData.ForceZ;
forceData.shear = abs(forceData.ForceY) + abs(forceData.ForceX);

%Calculate time on FP
Takeoffs = find(kinData.Takeoff);
Landings = find(kinData.Landing);
Takeoffs = Takeoffs(2:end);

Time_On_FP = (Takeoffs - Landings) ./ 100;

%% exploration plots
plot(kinData.Landing)

zeroLocs = find(kinData.Landing) * 10;

%Vertical forces
plot(forceData.ForceZ)

%Shear forces
figure
plot(forceData.shear)
hold on
for zLoc = 1:length(zeroLocs)
    line([zeroLocs(zLoc) zeroLocs(zLoc)], [0 800], 'Color','k'); 
end

plot(kinData.COMPower(zeroLocs(1)/10:(zeroLocs(1)/10)+100))

plot(kinData.COMPower(zeroLocs(2)/10:(zeroLocs(2)/10)+100))

