%% balace looping through directory %%
clear
addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\TMM Files') % add path to source code

% The files should be named sub_balance_Config_trialNo - Forces.txt
input_dir = 'C:\Users\Daniel.Feeney\Dropbox (Boa)\Hike Work Research\Data\BalanceMeasures';% Change to correct filepath

cd(input_dir)
files = dir('*.txt');
dataList = {files.name};
dataList = sort(dataList);
[f,~] = listdlg('PromptString','Select data files for all subjects in group','SelectionMode','multiple','ListString',dataList);
NumbFiles = length(f);

outputAllConfigs = {'SubName','Config','TrialNo','RMSx','RMSy', 'RMSvx', 'RMSvy', 'DistX', 'DistY', 'AvgVX', 'AvgVY'};

%Define constants
balanceStart = 200; %how far into the trial should the balance be taken?
balanceLen = 600; %length of epoch to add from balanceStart
steadyPortion = balanceStart+balanceLen; %Set length of steady portion by adding the index of starting with the length
fThresh = 10; %Threshold to set force to 0 if below fThresh.

%% loop through chosen files 
for s = 1:NumbFiles

    fileName = dataList{f(s)};
    fileLoc = [input_dir '\' fileName];
    forceData = importForces(fileLoc);
    splitFName = strsplit(fileName,'_'); subName = splitFName{1};
    configName = splitFName{3};
    trialNo = strsplit(splitFName{4},'-'); trialNo = str2num(trialNo{1});
   
    
    %Break into X,Y,Z and 
    ForceZ = -1 * forceData.RForceZ; %Vertical force
    ForceZ(ForceZ < fThresh) = 0;
    ForceY = forceData.RForceY; %ML Force
    ForceX = forceData.RForceX; %AP force
    
    %RMS of the demeaned x and y COP data
    rms(forceData.RCOPx - mean(forceData.RCOPx)); 
    rms(forceData.RCOPy - mean(forceData.RCOPy));
    
    % Calculate COP velocity
    COPvX = diff(forceData.RCOPx) / 0.01; rms(COPvX);
    COPvY = diff(forceData.RCOPy) / 0.01; rms(COPvX);
    
    % concatenate features
    KinData = [rms(forceData.RCOPx(balanceStart:steadyPortion) - mean(forceData.RCOPx(balanceStart:steadyPortion))), rms(forceData.RCOPy(balanceStart:steadyPortion) - mean(forceData.RCOPy(balanceStart:steadyPortion))),...
        rms(COPvX(balanceStart:steadyPortion)),rms(COPvX(balanceStart:steadyPortion)), sum(abs(diff(forceData.RCOPx(balanceStart:steadyPortion)))), sum(abs(diff(forceData.RCOPy(balanceStart:steadyPortion)))),...
        mean(abs(COPvX(balanceStart:steadyPortion))), mean(abs(COPvY(balanceStart:steadyPortion)))];
    
    % Tidy up and add to previous data
    KinData = num2cell(KinData);
    KinData = horzcat(subName,configName,trialNo, KinData); %modulate this to subject name and config
    outputAllConfigs = vertcat(outputAllConfigs, KinData);

end

% Convert cell to a table and use first row as variable names
T = cell2table(outputAllConfigs(2:end,:),'VariableNames',outputAllConfigs(1,:))
% Write the table to a CSV file
writetable(T,'balanceTestFile.csv')