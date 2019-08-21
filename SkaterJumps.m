%%%%%%% Importing and analyzing data from TMM %%%%%%

%%%%% TODO: export the Takeoff and Landing data at 1kHz with force to avoid
%%%%% losing some granularity. Calculate Peak Power, and Work eccentric and
%%%%% concentric based on the COM power.

clear
addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\TMM Files')  
%LR
forceData = importForces('df bball skater 1 - TriangleForces.txt');
kinData = importKinetics('df bball skater 1 - TriangleKinetics.txt');

%Lace
forceData = importForces('df sl bball skater 2 - TriangleForces.txt');
kinData = importKinetics('df sl bball skater 2 - TriangleKinetics.txt');

%Tongue Asym panel
forceData = importForces('df t bball skater 2 - TriangleForces.txt');
kinData = importKinetics('df t bball skater 2 - TriangleKinetics.txt');

%Dual Panel
forceData = importForces('df l bball skater 2 - TriangleForces.txt');
kinData = importKinetics('df l bball skater 2 - TriangleKinetics.txt');



%% Conversion and creating variables
forceData.ForceZ3 = -1 * forceData.ForceZ3;
forceData.shear3 = abs(forceData.ForceY1) + abs(forceData.ForceX1);
forceData.ForceZ1 = -1 * forceData.ForceZ1;
forceData.shear4 = abs(forceData.ForceY1) + abs(forceData.ForceX1);

forceData.forceZ1 =  -1 * forceData.ForceZ1;
plot(abs(forceData.ForceZ1))

%% Peak Ankle Power metrics
findpeaks(kinData.LAnklePower, 'MinPeakHeight', 100)
[anklePks, ankleLocs] = findpeaks(kinData.LAnklePower, 'MinPeakHeight', 100);


%% Calculation of the true zeros with heuristic. Find where the baseline is
%between baseline - 2 and baseline + 2 and the force value 5 indices ahead is greater than 10.
%Then remove indices that are too close together.
baseline_signal = mean(forceData.ForceZ1(10:100));
baseline_noise = std(forceData.ForceZ1(10:100));

landing_prelim = find((forceData.ForceZ1 < baseline_signal + 1) & (forceData.ForceZ1 > baseline_signal - 1)); %find all instances where the force signal is 0
counter_var = 1; %initialize a counter variable to be used as an index below
takeoff_int = 0;
for n = 1:(length(landing_prelim) - 10)
    tmp_index = landing_prelim(n);
    if (std(forceData.ForceZ1(tmp_index:tmp_index+10)) > (baseline_noise * 3))% & (forceData.ForceZ1(tmp_index + 3) > 0))  % If Stdev increases substantially, mark as a takeoff. Not sure why this is finding landings too
        takeoff_int(counter_var) = landing_prelim(n); %put this location into the zeros
        counter_var = counter_var +1; %Update this index
    end
end
counter2 = 1; %initialize another counter variable
true_takeoffs = 0;
for land = 1:(length(takeoff_int)-1)
   if takeoff_int(land + 1) - takeoff_int(land) > 100
       true_takeoffs(counter2) = takeoff_int(land);
       counter2 = counter2 +1;
   end
end

figure
plot(forceData.ForceZ1)
hold on
for zlocation = 1:length(true_takeoffs)
    line([true_takeoffs(zlocation) true_takeoffs(zlocation)], [0 800], 'Color','b'); 
end
%% Find the true landings
landing_prelim = find((forceData.ForceZ1 < (baseline_signal +2) ) & (forceData.ForceZ1 > (baseline_signal -2))); %find all instances where the force signal is ~0
counter_var = 1; %initialize a counter variable to be used as an index below
landing_int = 0;
for n = 10:(length(landing_prelim))
    tmp_index = landing_prelim(n);
    if (std(forceData.ForceZ1(tmp_index-10 : tmp_index) > 5 )) & (forceData.ForceZ1(tmp_index) < 5) %if the difference between two zero locations is large enough, set that value to be a strike
        landing_int(counter_var) = landing_prelim(n + 1); %put this location into the zeros
        counter_var = counter_var +1; %Update this index
    end
end

counter2 = 1; %initialize another counter variable
true_landing = 0;
for land = 1:(length(landing_int)-1)
   if landing_int(land + 1) - landing_int(land) > 100
       true_landing(counter2) = landing_int(land);
       counter2 = counter2 +1;
   end
end

figure
plot(forceData.ForceZ1)
hold on
for zlocation = 1:length(true_takeoffs)
    line([true_takeoffs(zlocation) true_takeoffs(zlocation)], [0 800], 'Color','b'); 
end
for zlocation = 1:length(true_landing)
    line([true_landing(zlocation) true_landing(zlocation)], [0 800], 'Color','r'); 
end

no_landings = length(true_landing);
Time_On_FP = (true_landing(1:no_landings) - true_takeoffs(1:no_landings)) ./ 1000; 
Time_On_FP = Time_On_FP';

%% Shear RFD

figure
plot(forceData.shear4)
print('Click the approximate start and peak for each landing')
[locs, vals] = ginput(length(anklePks)*2); %Change this to be smaller
RFD = zeros(5,1);
for hit = 1:5
    RFD(hit) = vals(hit*2) / ((locs(hit*2)-locs((hit*2)-1))/100)
end

%% Time to complete

TimeToComplete = (true_landing(end) - true_takeoffs(1) ) / 1000


%% Collate results
%Time_On_FP(5) = 0;
output = horzcat(anklePks, Time_On_FP, RFD)