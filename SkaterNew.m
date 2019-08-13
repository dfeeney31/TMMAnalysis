

clear
addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\TMM Files')  
%LR
forceData = importForces('df bball skater 1 - TriangleForces.txt');
kinData = importKinetics('df bball skater 1 - TriangleKinetics.txt');

%% Ankle power

plot(kinData.LAnklePower)
[pkAnkle, lcAnkle] = findpeaks(kinData.LAnklePower, 'MinPeakHeight', 100);

