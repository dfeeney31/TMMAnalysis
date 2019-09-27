%% Import golf kinetics and make plots of the data %%
clear
addpath('C:\Users\Daniel.Feeney\Dropbox (Boa)\TMM Files')
dat = importGolfKinetics('C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019\AllSubjectPoints\cw x 2 - Kinetics.txt');
dat2 = importGolfKinetics('C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019\AllSubjectPoints\cw x 3 - Kinetics.txt');
dat3 = importGolfKinetics('C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019\AllSubjectPoints\cw x 4 - Kinetics.txt');
dat4 = importGolfKinetics('C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019\AllSubjectPoints\cw x 7 - Kinetics.txt');
dat5 = importGolfKinetics('C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019\AllSubjectPoints\cw x 8 - Kinetics.txt');
dat6 = importGolfKinetics('C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019\AllSubjectPoints\cw x 6 - Kinetics.txt');

%% Find locations

[M1, I1] = max(dat.leftAnklePower)
[M2, I2] = max(dat2.leftAnklePower)
[M3, I3] = max(dat3.leftAnklePower)
[M4, I4] = max(dat4.leftAnklePower)
[M5, I5] = max(dat5.leftAnklePower)

stackedAnklePower = [dat.leftAnklePower(I1-100:I1+50), dat2.leftAnklePower(I2-100:I2+50),...
    dat3.leftAnklePower(I3-100:I3+50), dat4.leftAnklePower(I4-100:I4+50), dat5.leftAnklePower(I5-100:I5+50)];
stackedAnklePower = stackedAnklePower';
figure(1)
shadedErrorBar(1:length(stackedAnklePower), stackedAnklePower, {@mean,@std}, 'lineprops','-b')
title("Left Ankle Power")
ylabel('Power (W)')
xlabel('Time (ms)')
%% hip
[M1, I1] = max(dat.LeftHipPower)
[M2, I2] = max(dat2.LeftHipPower)
[M3, I3] = max(dat3.LeftHipPower)
[M4, I4] = max(dat4.LeftHipPower)
[M5, I5] = max(dat5.LeftHipPower)

stackedHip = [dat.LeftHipPower(I1-100:I1+50), dat2.LeftHipPower(I2-100:I2+50),...
    dat3.LeftHipPower(I3-100:I3+50), dat4.LeftHipPower(I4-100:I4+50), dat5.LeftHipPower(I5-100:I5+50)];
stackedHip = stackedHip';
figure(2)
shadedErrorBar(1:length(stackedHip), stackedHip, {@mean,@std}, 'lineprops','-b')
ylabel('Power (W)')
xlabel('Time (ms)')
title("Left Hip Power")

%% right side
[M1, I1] = max(dat.rightAnklePower)
[M2, I2] = max(dat2.rightAnklePower)
[M3, I3] = max(dat3.rightAnklePower)
[M4, I4] = max(dat4.rightAnklePower)
[M5, I5] = max(dat5.rightAnklePower)

stackedAnklePower = [dat.rightAnklePower(I1-100:I1+50), dat2.rightAnklePower(I2-100:I2+50),...
    dat3.rightAnklePower(I3-100:I3+50), dat4.rightAnklePower(I4-100:I4+50), dat5.rightAnklePower(I5-100:I5+50)];
stackedAnklePower = stackedAnklePower';
figure(3)
shadedErrorBar(1:length(stackedAnklePower), stackedAnklePower, {@mean,@std}, 'lineprops','-r')
title('Right Ankle Power')
ylabel('Power (W)')
xlabel('Time (ms)')

%% Right hip

[M3, I1] = max(dat4.RightHipPower)
%[M4, I2] = max(dat5.RightHipPower)
[M5, I3] = max(dat6.RightHipPower)

stackedAnklePower = [dat4.RightHipPower(I1-100:I1+50),dat6.RightHipPower(I3-100:I3+50)];
stackedAnklePower = stackedAnklePower';
figure(3)
shadedErrorBar(1:length(stackedAnklePower), stackedAnklePower, {@mean,@std}, 'lineprops','-r')
title('Right Hip Power')
ylabel('Power (W)')
xlabel('Time (ms)')

%% force data

force1 = importGolfForces('C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019\AllSubjectPoints\cw x 5 - Forces.txt');
force2 = importGolfForces('C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019\AllSubjectPoints\cw x 6 - Forces.txt');
force3 = importGolfForces('C:\Users\Daniel.Feeney\Dropbox (Boa)\Golf\Golf Pilot Aug 2019\AllSubjectPoints\cw x 7 - Forces.txt');

%% Forces side

plot(force1.LForceZ)

lZForce = [-1 .* force1.LForceZ(6144:6144+2000), -1 .* force2.LForceZ(6688:6688+2000), -1 .* force3.LForceZ(7322:7322+2000)];
lZForce = lZForce';
figure(3)
shadedErrorBar(1:length(lZForce), lZForce, {@mean,@std}, 'lineprops','-b')
title('Vertical Forces')
RZForce = [-1 .* force1.RForceZ(6144:6144+2000), -1 .* force2.RForceZ(6688:6688+2000), -1 .* force3.RForceZ(7322:7322+2000)];
RZForce = RZForce';
figure(3)
shadedErrorBar(1:length(RZForce), RZForce, {@mean,@std}, 'lineprops','-r')
ylabel('Force (N)')
xlabel('Time (ms)')

%% ML
lZForce = [-1 .* force1.LForceX(6144:6144+2000), -1 .* force2.LForceX(6688:6688+2000), -1 .* force3.LForceX(7322:7322+2000)];
lZForce = lZForce';
figure(3)
shadedErrorBar(1:length(lZForce), lZForce, {@mean,@std}, 'lineprops','-b')
title('ML Forces')
RZForce = [-1 .* force1.RForceX(6144:6144+2000), -1 .* force2.RForceX(6688:6688+2000), -1 .* force3.RForceX(7322:7322+2000)];
RZForce = RZForce';
figure(3)
shadedErrorBar(1:length(RZForce), RZForce, {@mean,@std}, 'lineprops','-r')
ylabel('Force (N)')
xlabel('Time (ms)')

%% AP
lZForce = [-1 .* force1.LForceY(6144:6144+2000), -1 .* force2.LForceY(6688:6688+2000), -1 .* force3.LForceY(7322:7322+2000)];
lZForce = lZForce';
figure(3)
shadedErrorBar(1:length(lZForce), lZForce, {@mean,@std}, 'lineprops','-b')
title('AP Forces')
RZForce = [-1 .* force1.RForceY(6144:6144+2000), -1 .* force2.RForceY(6688:6688+2000), -1 .* force3.RForceY(7322:7322+2000)];
RZForce = RZForce';
figure(3)
shadedErrorBar(1:length(RZForce), RZForce, {@mean,@std}, 'lineprops','-r')
ylabel('Force (N)')
xlabel('Time (ms)')