%%%%%%% Importing and analyzing data from TMM %%%%%%

%%%%% TODO: export the Takeoff and Landing data at 1kHz with force to avoid
%%%%% losing some granularity. Calculate Peak Power, and Work eccentric and
%%%%% concentric based on the COM power.

clear
addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\TMM Files')  
%LR
forceData = importForces('C:\Users\Daniel.Feeney\Dropbox (Boa\AgilityPerformance\AdiBasketball\df bball skater 1 - TriangleForces.txt');
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

%% Calculation of the true zeros with heuristic. Find where the baseline is
%between -3 and +1 and the force value 5 indices ahead is greater than 10.
%Then remove indices that are too close together.
landings_prelim = find((forceData.ForceZ1 < 1) & (forceData.ForceZ1 > -3)); %find all instances where the force signal is 0
counter_var = 1; %initialize a counter variable to be used as an index below
landing_int = 0;
for n = 1:(length(landings_prelim) - 10)
    tmp_index = landings_prelim(n);
    if  (landings_prelim(n + 1) - landings_prelim(n) < 20) %if the difference between two zero locations is large enough, set that value to be a strike
        landing_int(counter_var) = landings_prelim(n + 1); %put this location into the zeros
        counter_var = counter_var +1; %Update this index
    end
end
counter2 = 1; %initialize another counter variable
true_landings = 0;
for land = 1:(length(landing_int)-1)
   if landing_int(land + 1) - landing_int(land) > 100
       true_landings(counter2) = landing_int(land);
       counter2 = counter2 +1;
   end
end

%% Find the true take offs
takeoff_prelim = find((forceData.ForceZ1 < 1) & (forceData.ForceZ1 > -3)); %find all instances where the force signal is ~0
counter_var = 1; %initialize a counter variable to be used as an index below
takeoff_int = 0;
for n = 1:(length(takeoff_prelim) - 10)
    tmp_index = takeoff_prelim(n);
    if (takeoff_prelim(n + 1) - takeoff_prelim(n) > 20)%if the difference between two zero locations is large enough, set that value to be a strike
        takeoff_int(counter_var) = takeoff_prelim(n + 1); %put this location into the zeros
        counter_var = counter_var +1; %Update this index
    end
end
counter2 = 1; %initialize another counter variable
true_takeoff = 0;
for land = 1:(length(takeoff_int)-1)
   if takeoff_int(land + 1) - takeoff_int(land) > 100
       true_takeoff(counter2) = takeoff_int(land);
       counter2 = counter2 +1;
   end
end

figure
plot(forceData.ForceZ1)
hold on
for zlocation = 1:length(true_landings)
    line([true_landings(zlocation) true_landings(zlocation)], [0 800], 'Color','b'); 
end
for zlocation = 1:length(true_takeoff)
    line([true_takeoff(zlocation) true_takeoff(zlocation)], [0 800], 'Color','k'); 
end

Time_On_FP = (true_takeoff - true_landings) ./ 1000; Time_On_FP = Time_On_FP';

%% exploration plots
zeroLocs = find(kinData.Landing);

%Vertical forces
figure
plot(forceData.ForceZ1)
hold on
plot(forceData.ForceZ2)
legend('Left','Right')

% Calcualte RFD propulsive
figure
plot(forceData.ForceZ1)
[locs, vals] = ginput(10);
RFD = zeros(5,1);
for hit = 1:5
    RFD(hit) = vals(hit*2) / ((locs(hit*2)-locs((hit*2)-1))/100)
end


figure
plot(kinData.COMPower(zeroLocs(1)/10:(zeroLocs(1)/10)+100))
hold on
plot(kinData.COMPower(zeroLocs(2)/10:(zeroLocs(2)/10)+100))

figure
plot(kinData.LAnklePower)

% Calculate work 
sum(kinData.COMPower(zeroLocs(2)/10:(zeroLocs(2)/10)+100))