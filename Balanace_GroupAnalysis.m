%% balace looping through directory %%
clear
addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\TMM Files') % add path to source code

subject = {'BV'}; % Change to Subject Name
% Data files should be named SubjectNameMovementShoe - Report
input_dir = 'C:\Users\Daniel.Feeney\Dropbox (Boa)\Hike Work Research\Data\BalanceMeasures';% Change to correct filepath

shoes = {'DD', 'Lace', 'SD'}; %Shoe names, in ALPHABETICAL ORDER. Remember to change legend at bottom to correct number of shoes.
line = {'-k','-g', '-b'}; % Add enough line colors for each shoe.

cd(input_dir)
files = dir('*.txt');
dataList = {files.name};
dataList = sort(dataList);
[f,~] = listdlg('PromptString','Select data files for all subjects in group','SelectionMode','multiple','ListString',dataList);
NumbFiles = length(f);

outputAllConfigs = {'SubName','Config','RMSx','RMSy', 'RMSvx', 'RMSvy', 'DistX', 'DistY', 'AvgVX', 'AvgVY'};

%% loop through chosen files 
for s = 1:NumbFiles

    fileName = dataList{f(s)};
    fileLoc = [input_dir '\' fileName];
    forceData = importForces(fileLoc);
    splitFName = strsplit(fileName,'_'); subName = splitFName{1};
    configName = splitFName{3};
    %Define constants
    balanceStart = 200;
    balanceLen = 800; %Set length of steady portion
    fThresh = 10; %Newtons to zero force below
    
    %Break into X,Y,Z and 
    ForceZ = -1 * forceData.RForceZ; %Vertical force
    ForceZ(ForceZ < fThresh) = 0;
    ForceY = forceData.RForceY; %ML Force
    ForceX = forceData.RForceX; %AP force
    
    rms(forceData.RCOPx - mean(forceData.RCOPx)); %RMS of the demeaned x and y COP data
    rms(forceData.RCOPy - mean(forceData.RCOPy));
    % Calculate COP velocity
    COPvX = diff(forceData.RCOPx) / 0.01; rms(COPvX);
    COPvY = diff(forceData.RCOPy) / 0.01; rms(COPvX);
  
    KinData = [rms(forceData.RCOPx(balanceStart:balanceLen) - mean(forceData.RCOPx(balanceStart:balanceLen))), rms(forceData.RCOPy(balanceStart:balanceLen) - mean(forceData.RCOPy(balanceStart:balanceLen))),...
        rms(COPvX(balanceStart:balanceLen)),rms(COPvX(balanceStart:balanceLen)), sum(abs(diff(forceData.RCOPx(balanceStart:balanceLen)))), sum(abs(diff(forceData.RCOPy(balanceStart:balanceLen)))),...
        mean(abs(COPvX(balanceStart:balanceLen))), mean(abs(COPvY(balanceStart:balanceLen)))];
    
    KinData = num2cell(KinData);
    KinData = horzcat(subName,configName,KinData); %modulate this to subject name and config
    outputAllConfigs = vertcat(outputAllConfigs, KinData);

end