%% Collate the point estimates from the golf study
clear
cd 'C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019\AllSubjectPoints'
files = dir('*.txt');
outputDat = zeros(14,length(files));
addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019') 
counter = 1;
for file = files'
    outputDat(1:14,counter) = importPoints(file.name);
    tmp_metadata = strsplit(convertCharsToStrings(file.name),' ');
    subjectNo(counter) = tmp_metadata(1,1);
    conditionNo(counter) = tmp_metadata(1,2);
    trial(counter) = tmp_metadata(1,3);
    counter = counter +1;
end

outputDat = outputDat';
subjectNo = subjectNo'; conditionNo = conditionNo'; trial = trial';

finalDat = array2table(outputDat(:,1:13), 'VariableNames', {'LAnklePower','RAnkklePower',...
    'LHipPower','RHipPower','RearGRF','RHipAbduction', 'LHipAbduction','LAnkleEversion',...
    'RAnkleEversion','FrontGRF','PeakRFDVert','PeakRFDshearX','PeakRFDshearY'});
finalDat.subID = [subjectNo]; finalDat.condition = [conditionNo]; finalDat.trial = [trial];