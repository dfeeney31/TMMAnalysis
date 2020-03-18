%%%%% Single leg landing data %%%%%%
clear

addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\TMM Files') 
%% Force data
forceData = importForces('C:\Users\Daniel.Feeney\Dropbox (Boa)\Hike Work Research\Data\BalanceMeasures\PreProtocolWork\df single leg 4rt - Forces.txt');
momentData = importMoments('C:\Users\Daniel.Feeney\Dropbox (Boa)\Hike Work Research\Data\BalanceMeasures\PreProtocolWork\df single leg 4rt - JointMoments.txt');
powerData = importPowers('C:\Users\Daniel.Feeney\Dropbox (Boa)\Hike Work Research\Data\BalanceMeasures\PreProtocolWork\df single leg 4rt - Powers.txt');
powerData = importPowers('C:\Users\Daniel.Feeney\Dropbox (Boa)\GolfPerformance\AdiHammer_Feb2020\adiHammer_Performance_Feb2020\Data\Chris_Hammer_4 - Powers.txt')

%Break into componentry
ForceZ = -1 * forceData.LForceZ; %Vertical force
ForceZ(ForceZ < 10) = 0;
ForceY = forceData.LForceY; %ML Force
ForceX = forceData.LForceX; %AP force

% Find landing by finding the location of the first non 0 value and
% subtracting one index from there
trueLanding = find(ForceZ,1) - 1;
figure
plot(ForceZ(trueLanding:end))
title('forces')
hold on
plot(ForceY(trueLanding:end))
plot(ForceX(trueLanding:end))
legend('Z','Y','X')

%%% Temporary comparison %%%
% forceData2 = importForces('C:\Users\Daniel.Feeney\Dropbox (Boa)\Hike Work Research\Data\BalanceMeasures\df single leg 5rt loose - Forces.txt');
% ForceZ2 = -1 * forceData2.LForceZ; ForceZ2(ForceZ2 < 10) = 0;
% ForceY2 = forceData2.LForceY; %ML Force
% ForceX2 = forceData2.LForceX; %AP force
% trueLanding2 = find(ForceZ2,1) - 1;

% figure
% plot(ForceZ(trueLanding:end))
% title('Z Force')
% hold on
% plot(ForceZ2(trueLanding2:end))
% legend('Tight', 'Loose')
% 
% figure
% plot(ForceY(trueLanding:end))
% title('Y Force')
% hold on
% plot(ForceY2(trueLanding2:end))
% legend('Tight', 'Loose')
% 
% figure
% plot(ForceX(trueLanding:end))
% title('X Force')
% hold on
% plot(ForceX2(trueLanding2:end))
% legend('Tight', 'Loose')
% consider looking at SD or CV for quiet standing for an epoch for all
% conditions too 
%% Moment data
%Plotting joint moment time series
figure
plot(momentData.RightAnkleMomentFrontal)
title('Ankle Moments')
ylabel('Moment (N*m)')
hold on
plot(momentData.RightAnkleMomentSagittal)
plot(momentData.RightAnkleMomentTransverse)
legend('Frontal','Saggital','Transverse')
% 
% figure
% plot(momentData.RightHipMomentFrontal)
% title('Hip Moments')
% ylabel('Moment (N*m)')
% hold on
% plot(momentData.RightHipMomentSagittal)
% plot(momentData.RightHipMomentTransverse)
% legend('Frontal','Saggital','Transverse')
% 
% figure
% plot(momentData.RightKneeMomentFrontal)
% title('Knee Moments')
% ylabel('Moment (N*m)')
% hold on
% plot(momentData.RightKneeMomentSagittal)
% plot(momentData.RightKneeMomentTransverse)
% legend('Frontal','Saggital','Transverse')

%% Power Data
AnklePower = powerData.RAnklePower(trueLanding:end);
KneePower = powerData.RKneePower(trueLanding:end);
HipPower = powerData.RHipPower(trueLanding:end);

%Plotting
% figure
% plot(powerData.L5X)
% title('COM Velocity')
% ylabel('Velocity (m/s)')
% hold on
% plot(powerData.L5Y)
% plot(powerData.L5Z)
% legend('X','Y','Z')
% 
figure
plot(AnklePower)
title('Joint Powers')
hold on
plot(KneePower)
plot(HipPower)
legend('Ankle','Knee','Hip')
xlim([0 100])
ylim([-2000 1000])
%% Feature extraction from each trial

%Time to stabilize
win_len = 50; %window length for steady standing
subBW = 700;
for i = trueLanding:(length(ForceZ)-50)
   avgF(i) = mean(ForceZ(i-win_len/2:i+win_len/2)); 
   sdF(i) = std(ForceZ(i-win_len/2:i+win_len/2));
end

%plot(avgF)
%plot(sdF)

stabilized = zeros(1,100);
counter = 1;
for step = 1:length(avgF)
   if (avgF(step) > (0.95*subBW)) & (avgF(step)< (1.05*subBW)) & (sdF(step) < 25)
        stabilized(counter) = step;
        counter = counter + 1;
   end
end

stable = (stabilized(1) - trueLanding) / 100;

pkZ = max(ForceZ(trueLanding:stabilized(1)));

stab_Z = std(ForceZ(stabilized(1):stabilized(1)+300));
stab_Y = std(ForceY(stabilized(1):stabilized(1)+300));
stab_X = std(ForceX(stabilized(1):stabilized(1)+300));

%% Power data
for ind = 3:20
   if (AnklePower(ind) <= 0) & (AnklePower(ind+1) >= 0)
       EndAnkle = ind;
       break
   end
end
NegAnkleWork = sum(AnklePower(1:EndAnkle));
%Pos ankle work
for ind = 10:20
   if (AnklePower(ind) >= 0) & (AnklePower(ind+1) <= 0)
       EndAnkleP = ind;
       break
   end
end
PosAnkleWork = sum(AnklePower(EndAnkle:EndAnkleP));

for ind = 3:20
   if (KneePower(ind) <= 0) & (KneePower(ind+1) >= 0)
       EndKnee = ind;
   end
end
NegKneeWork = sum(KneePower(1:EndKnee));

for ind = 3:20
   if (HipPower(ind) <= 0) & (HipPower(ind+1) >= 0)
       EndHip = ind;
   end
end
NegHipWork = sum(HipPower(4:EndHip));

%% Moment data
KneeInternalRotationM = momentData.RightKneeMomentTransverse(trueLanding:end);
KneeAbductionM = momentData.RightKneeMomentSagittal(trueLanding:end);

KneeRotM = max(-1 * KneeInternalRotationM(1:(stable*100)));
KneeAbM = max(-1 * KneeAbductionM(1:(stable*100)));

KneeRotM2 = max(KneeInternalRotationM(1:(stable*100)));
KneeAbM2 = max(KneeAbductionM(1:(stable*100)));

RAnkleFrontal = momentData.RightAnkleMomentFrontal(trueLanding:end);
RAnkleSaggital = momentData.RightAnkleMomentSagittal(trueLanding:end);
RAnkleTransverse = momentData.RightAnkleMomentTransverse(trueLanding:end);

RAnkleFront = max(RAnkleFrontal(1:(stable*100))); RAnkleFrontNeg = max(-1 * RAnkleFrontal(1:(stable*100)));
RAnkleSag = max(RAnkleSaggital(1:(stable*100))); RAnkleSagNeg = max(-1 * RAnkleSaggital(1:(stable*100)));
RAnkleTrans = max(RAnkleTransverse(1:(stable*100))); RAnkleTransNeg = max(-1 * RAnkleTransverse(1:(stable*100)));

%% group together
output = [stable,pkZ, stab_Z, stab_Y, stab_X, abs(NegAnkleWork), abs(PosAnkleWork), abs(NegKneeWork), abs(NegHipWork), KneeRotM, KneeAbM, ...
    KneeRotM2, KneeAbM2, RAnkleFront,RAnkleFrontNeg, RAnkleSag,RAnkleSagNeg, RAnkleTrans, RAnkleTransNeg]
%plot(KneeAbductionM)
