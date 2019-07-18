%%%%%%% Importing and analyzing data from TMM %%%%%%

%%%%% TODO: export the Takeoff and Landing data at 1kHz with force to avoid
%%%%% losing some granularity. Calculate Peak Power, and Work eccentric and
%%%%% concentric based on the COM power.

clear
addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\TMM Files')  
%LR
forceData = importForces('CMJ_LR - TriangleForces.txt');
kinData = importKinetics('CMJ_LR - TriangleKinetics.txt');
%Lace
forceData = importForces('CMJ_laces - TriangleForces.txt');
kinData = importKinetics('CMJ_laces - TriangleKinetics.txt');
%Tongue Asym panel
forceData = importForces('CMJ_triangle - TriangleForces.txt');
kinData = importKinetics('CMJ_triangle - TriangleKinetics.txt');
%Dual Panel
forceData = importForces('CMJ_panels - TriangleForces.txt');
kinData = importKinetics('CMJ_panels - TriangleKinetics.txt');

%forceData = importForces('TriangleTest - TriangleForces.txt');
%kinData = importKinetics('TriangleTest - TriangleKinetics.txt');



%% Conversion and creating variables
forceData.ForceZ1 = -1 * forceData.ForceZ1;
forceData.shear1 = abs(forceData.ForceY1) + abs(forceData.ForceX1);
forceData.ForceZ2 = -1 * forceData.ForceZ2;
forceData.shear2 = abs(forceData.ForceY2) + abs(forceData.ForceX2);

%Calculate time on FP
Takeoffs = find(forceData.Takeoff);
Landings = find(forceData.Landing);

if length(Landings) > length(Takeoffs)
    Landings = Landings(1:length(Takeoffs));
else
    Takeoffs = Takeoffs(1:length(Landings));
end

Time_On_FP = (Takeoffs - Landings) ./ 100;
Time_On_FP = Time_On_FP(Time_On_FP > 0.3);

%% exploration plots
zeroLocs = find(kinData.Landing);

%Vertical forces
figure
plot(forceData.ForceZ1)
hold on
plot(forceData.ForceZ2)
legend('Left','Right')

%Shear forces
figure
plot(forceData.shear1)
hold on
for zLoc = 1:length(zeroLocs)
    line([zeroLocs(zLoc) zeroLocs(zLoc)], [0 800], 'Color','k'); 
end

figure
plot(kinData.COMPower(zeroLocs(1)/10:(zeroLocs(1)/10)+100))
hold on
plot(kinData.COMPower(zeroLocs(2)/10:(zeroLocs(2)/10)+100))

figure
plot(kinData.LAnklePower)

% Calculate work 
sum(kinData.COMPower(zeroLocs(2)/10:(zeroLocs(2)/10)+100))