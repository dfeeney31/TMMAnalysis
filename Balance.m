%%%%% Balance %%%%%%
clear

addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\TMM Files') 
%% Force data
forceData = importForces('C:\Users\Daniel.Feeney\Dropbox (Boa)\Hike Work Research\Data\BalanceMeasures\Brett_Balance_DD_2 - Forces.txt');
%momentData = importMoments('C:\Users\Daniel.Feeney\Dropbox (Boa)\Hike Work Research\Data\BalanceMeasures\df blind rt1 - JointMoments.txt');
%powerData = importPowers('C:\Users\Daniel.Feeney\Dropbox (Boa)\Hike Work Research\Data\BalanceMeasures\df blind rt1 - Powers.txt');

balanceStart = 200;
balanceLen = 800; %Set length of steady portion
%% 

%Break into componentry
ForceZ = -1 * forceData.RForceZ; %Vertical force
ForceZ(ForceZ < 10) = 0;
ForceY = forceData.RForceY; %ML Force
ForceX = forceData.RForceX; %AP force

% Find landing by finding the location of the first non 0 value and
% subtracting one index from there
trueLanding = find(ForceZ,1) - 1;
figure
plot(ForceZ)
hold on
plot(ForceY)
plot(ForceX)
legend('Z','Y','X')

%plot(forceData.LCOPx - mean(forceData.LCOPx), forceData.LCOPy - mean(forceData.LCOPy))
rms(forceData.RCOPx - mean(forceData.RCOPx)); %RMS of the demeaned x and y COP data
rms(forceData.RCOPy - mean(forceData.RCOPy));
% Calculate COP velocity
COPvX = diff(forceData.RCOPx) / 0.01; rms(COPvX);
COPvY = diff(forceData.RCOPy) / 0.01; rms(COPvX);


% output = [rms(forceData.RCOPx(10:balanceLen) - mean(forceData.RCOPx(10:balanceLen))), rms(forceData.RCOPy(10:balanceLen) - mean(forceData.RCOPy(10:balanceLen))),...
%     rms(COPvX(10:balanceLen)),rms(COPvX(10:balanceLen)), sum(abs(diff(forceData.RCOPx(10:balanceLen)))), sum(abs(diff(forceData.RCOPy(10:balanceLen)))),...
%     mean(abs(COPvX(10:balanceLen))), mean(abs(COPvY(10:balanceLen)))];

output = [rms(forceData.RCOPx(balanceStart:balanceLen) - mean(forceData.RCOPx(balanceStart:balanceLen))), rms(forceData.RCOPy(balanceStart:balanceLen) - mean(forceData.RCOPy(balanceStart:balanceLen))),...
    rms(COPvX(balanceStart:balanceLen)),rms(COPvX(balanceStart:balanceLen)), sum(abs(diff(forceData.RCOPx(balanceStart:balanceLen)))), sum(abs(diff(forceData.RCOPy(balanceStart:balanceLen)))),...
    mean(abs(COPvX(balanceStart:balanceLen))), mean(abs(COPvY(balanceStart:balanceLen)))];
%% Powers
% AnklePower = powerData.RAnklePower;
% KneePower = powerData.RKneePower;
% HipPower = powerData.RHipPower;
% % 
% figure
% plot(AnklePower)
% title('Joint Powers')
% hold on
% plot(KneePower)
% legend('Ankle','Knee')
% ylim([-60 80])
% 
% output = [rms(forceData.LCOPx(1:1000) - mean(forceData.LCOPx(1:1000))), rms(forceData.LCOPy(1:1000) - mean(forceData.LCOPy(1:1000))),...
%     rms(COPvX(1:1000)),rms(COPvX(1:1000)), sum(abs(diff(forceData.LCOPx(1:1000)))), sum(abs(diff(forceData.LCOPy(1:1000)))),...
%     mean(abs(COPvX(1:1000))), mean(abs(COPvY(1:1000))),sum(abs(AnklePower(1:1000))), sum(abs(KneePower(1:1000)))]

%% Torques
% plot(momentData.RightAnkleMomentFrontal)
% plot(momentData.RightAnkleMomentSagittal)
% plot(momentData.RightAnkleMomentTransverse)

%% joint angle data
KKdat = BrettBalanceDD1PowersMomentsAngles;

figure
plot(KKdat.RHipFlexion)
hold on
plot(KKdat.RHipAbduction)
plot(KKdat.RHipRoation)
legend('Flexion','Abduction','Rotation')

figure
plot(KKdat.RAnkleDorsiflexion)
hold on
plot(KKdat.RAnkleAbduction)
plot(KKdat.RAnkleInversion)
legend('Flexion','Abduction','Rotation')