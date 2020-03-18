rm(list=ls())

library(tidyverse)
library(ggplot2)

hikeDat <- read.csv('C:/Users/Daniel.Feeney/Dropbox (Boa)/Hike Work Research/Data/HikeKineticsR.csv')
names(hikeDat)[1] <- 'Subject'

sub1 <- subset(hikeDat, hikeDat$Subject == 'DF')
sub1 <- subset(sub1, sub1$HipWork < 10000) #removing unrealistically high hip work values

### decreased ankle work in DD comapred with other two. ###
ggplot(data = sub1, aes(x=as.factor(Config), y = AnkleWork)) + geom_boxplot() + 
  geom_point() + theme_bw(base_size = 16) + xlab('Config') +
  ylab('Ankle Work') + labs(fill = 'Configuration')

ggplot(data = sub1, aes(x=as.factor(Config), y = HipWork)) + geom_boxplot() + 
  geom_point() + theme_bw(base_size = 16) + xlab('Config') +
  ylab('Hip Work') + labs(fill = 'Configuration')

ggplot(data = sub1, aes(x=as.factor(Config), y = MaxKneeMx)) + geom_boxplot() + 
  geom_point() + theme_bw(base_size = 16) + xlab('Config') +
  ylab('Peak Knee X Moment') + labs(fill = 'Configuration')

ggplot(data = sub1, aes(x=as.factor(Config), y = MaxKneeMy)) + geom_boxplot() + 
  geom_point() + theme_bw(base_size = 16) + xlab('Config') +
  ylab('Peak Knee Y Moment') + labs(fill = 'Configuration')

ggplot(data = sub1, aes(x=as.factor(Config), y = stepLen)) + geom_boxplot() + 
  geom_point() + theme_bw(base_size = 16) + xlab('Config') +
  ylab('Stance Time (ms)') + labs(fill = 'Configuration')

#### Differences in peak ankle power (lower in DD), similar to ankle work trend
ggplot(data = sub1, aes(x=as.factor(Config), y = MaxAnklePow)) + geom_boxplot() + 
  geom_point() + theme_bw(base_size = 16) + xlab('Config') +
  ylab('Peak Ankle Power') + labs(fill = 'Configuration')

ggplot(data = sub1, aes(x=as.factor(Config), y = MaxHipP)) + geom_boxplot() + 
  geom_point() + theme_bw(base_size = 16) + xlab('Config') +
  ylab('Peak Hip Power') + labs(fill = 'Configuration')
