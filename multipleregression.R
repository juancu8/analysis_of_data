#This is an example file to implement multiple regression to a dataset.
#aseguarate to have a sufficient number of observations (problems with degrees of freedom)
#load package Mass

dataset < data #rename dataset
attach(data)#to access variables in the data set

md.lm<-lm(Renta ~ var1+var2+var3+var4+var5+var6+var7+var8)#model with eight variables that explains income (var. response)
summary(md.lm)#Model summary, we can see the load of each variable and adjustment capacity model(R^2)

vif(md.lm)#Factors variance inflation.
sqrt(vif(md.lm)) > 2 # problem?
anova(md.lm)

par(mfrow=c(2,2))
plot(md.lm)
outlierTest(md.lm)#show outliers

qqPlot(md9.lm, main="QQ Plot") #qq plot for studentized resid 
leveragePlots(md.lm)
hatvalues(md.lm)

crPlots(md.lm)
ceresPlots(md.lm)

durbinWatsonTest(md.lm) #Test de durbin-Watson

# Global test of model assumptions.library(gvlma)
gvmodel <- gvlma(md.lm) 
summary(gvmodel)

# Evaluate homoscedasticity
# non-constant error variance test
ncvTest(md.lm)
# plot studentized residuals vs. fitted values 
spreadLevelPlot(md.lm)

# Normality of Residuals
# qq plot for studentized resid
qqPlot(md.lm, main="QQ Plot")
# distribution of studentized residualslibrary(MASS)
sresid <- studres(md.lm) 
hist(sresid, freq=FALSE, 
     main="Distribution of Studentized Residuals")
xfit<-seq(min(sresid),max(sresid),length=40) 
yfit<-dnorm(xfit) 
lines(xfit, yfit)

# Influential Observations
# added variable plots 
avPlots(md.lm)
# Cook's D plot
# identify D values > 4/(n-k-1) 
cutoff <- 4/((nrow(md9.lm)-length(md.lm$coefficients)-2)) 
plot(md.lm, which=4, cook.levels=cutoff)

########### Evaluate the predictive power of our model on data #####################
########################################################################################
#data_set = dataTrain + dataTest
#set.seed(1), coge la misma semilla.

ind <- sample(2, nrow(M), replace = TRUE, prob = c(0.8, 0.2))
dataTrain <- data[ind == 1, ]#Data for train
dataTest <- data[ind == 2, ]#Data for testing

mdt.lm<-lm(Renta ~ var1+var2+var3+var4+var5+var6+var7+var8, data=dataTrain)#We pass the model to the training data
summary(mdt.lm)

adjustedvalues<-mdt.lm$fitted.values#adjusted values
predicted<-predict.lm(object = mdt.lm,newdata = dataTest)#predicted values

err<-(predicted-dataTest$Renta)#error
ecm<- sum(sqrt((err)^2))/length(predicted)#mean square error, to evaluate the fit of our model in a data set

mean<-mean(err)
deviation<-sd(err)
deviation
mean

###########################graphics################################################
#for a visual assessment
plot (predicted,col="blue")
points(dataTest$Renta,pch = 19,col="red")

plot(err)
#can see actual vs predicted and error