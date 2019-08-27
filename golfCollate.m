<<<<<<< HEAD
%% Collate the point estimates from the golf study
clear
cd 'C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019\DH'
files = dir('*.txt');
outputDat = zeros(11,length(files));
addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019') 
counter = 1;
for file = files'
    outputDat(:,counter) = importPoints(file.name);
    counter = counter +1;
end

outputDat = outputDat';
finalDat = array2table(outputDat(:,1:10), 'VariableNames', {'LAnklePower','RAnkklePower',...
=======
%% Collate the point estimates from the golf study
clear
cd 'C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019\DH'
files = dir('*.txt');
outputDat = zeros(11,length(files));
addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019') 
counter = 1;
for file = files'
    outputDat(:,counter) = importPoints(file.name);
    counter = counter +1;
end

outputDat = outputDat';
finalDat = array2table(outputDat(:,1:10), 'VariableNames', {'LAnklePower','RAnkklePower',...
>>>>>>> d2603d5d9304ae0a99f637b747c2859177545c34
    'LHipPower','RHipPower','RearGRF','RHipAbduction', 'LHipAbduction','LAnkleEversion','RAnkleEversion','FrontGRF'});