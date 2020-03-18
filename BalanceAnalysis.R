### balance measurements analysis hike/work ####

rm(list=ls())
balanceDat <- read.csv('C:/Users/Daniel.Feeney/Dropbox (Boa)/Hike Work Research/Data/Balance_ProtocolR.csv')
names(balanceDat)[1] <- 'Subject'

balance <- subset(balanceDat, balanceDat$Movement == 'Balance')
singleLeg <- subset(balanceDat, balanceDat$Movement == 'SingleLeg')

# Balance measurements 
# DF had lowest velocity in DD, but no changes otherwise
XVel<- aggregate(AvgVX ~ Config + Subject , data = balance, FUN = mean)
names(XVel) <- c('Config', 'Subject', 'AvgVelX')
XVel

#Both subjects had less Y movement in SD and DD
YVel<- aggregate(AvgVY ~ Config + Subject , data = balance, FUN = mean)
names(YVel) <- c('Config', 'Subject', 'AvgVelX')
YVel

# Average distance COP moves is lowest in DD and SD for DF
DistX <- aggregate(DistX ~ Config + Subject , data = balance, FUN = mean)
names(DistX) <- c('Config','Subject','AvgVelX')
DistX

#Average distance is lower in SD and DD than lace for both subjects
DistY <- aggregate(DistY ~ Config + Subject , data = balance, FUN = mean)
names(DistY) <- c('Config','Subject','AvgVelX')
DistY

# Single leg landing measurements 
# No systematic differences for time to stabilie
stabTime<- aggregate(TimeToStab ~ Config + Subject , data = singleLeg, FUN = mean)
names(stabTime) <- c('Config', 'Subject', 'TimeToStabilize')
stabTime

# Minimzied SD for BV and Lace for DF
XVel<- aggregate(AvgVX ~ Config + Subject , data = singleLeg, FUN = mean)
names(XVel) <- c('Config', 'Subject', 'AvgVelX')
XVel

# Minimized in SD for BV and DD for DF but most were similar for DF
YVel<- aggregate(AvgVY ~ Config + Subject , data = singleLeg, FUN = mean)
names(YVel) <- c('Config', 'Subject', 'AvgVelY')
YVel

# No systematic trends 
DistX <- aggregate(DistX ~ Config + Subject , data = singleLeg, FUN = mean)
names(DistX) <- c('Config','Subject','DistX')
DistX

# No systematic trends
DistY <- aggregate(DistY ~ Config + Subject , data = singleLeg, FUN = mean)
names(DistY) <- c('Config','Subject','DistY')
DistY
