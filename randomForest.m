clear all;

close;

load Matrix.mat

matrixVar = Matrix(1:1000,2:8); % Matrix(number of observations, variables)
matrixVar = [matrixVar, Matrix(1:1000,10:15)];%Add more variables


x = MatrixVar;
y = Matrix(1:1000, 9);%Select response var

parTrain = round(length(x) * 0.75);% We start the data to test and train for x and y
parTest = round(length(x) * 0.90);

xTrain = x(1:parTrain,:);
xTest =  x(parTrain+1:parTest,:);
xtt = cat(1,xTrain,xTest);
xValidation = x(parTest+1:length(x),:);

yTrain = y(1:parTrain,:);
yTest = y(parTrain+1:parTest,:);
ytt = cat(1,yTrain,yTest);
yValidacion = y(parTest+1:length(y),:);

rng(1); % For reproducibility,para train
BaggedEnsembleTT = TreeBagger(100,xtt,ytt,'method','regression','OOBPred','On','OOBVarImp','on');

% acumulated Error 
oobErrorBaggedEnsembleTT = oobError(BaggedEnsembleTT);
figure;
plot(oobErrorBaggedEnsembleTT)
xlabel 'Number of trees';
ylabel 'Out-of-bag acumulated error';

%Individual Error.
oobErrorBaggedEnsembleTTind = oobError(BaggedEnsembleTT,'mode','individual');
figure;
plot(oobErrorBaggedEnsembleTTind)
xlabel 'Number of trees';
ylabel 'Out-of-bag individual error';

% We tested with a small number of trees

rng(1); % For reproducibility,for train
BaggedEnsembleR = TreeBagger(11,xtt,ytt,'method','regression','OOBPred','On','OOBVarImp','on'); %optimal number of trees: 11

% acumulated Error 
oobErrorBaggedEnsembleTT = oobError(BaggedEnsembleTT);
figure;
plot(oobErrorBaggedEnsembleTT)
xlabel 'Number of trees';
ylabel 'Out-of-bag acumulated error';

%Individual Error.
oobErrorBaggedEnsembleTTind = oobError(BaggedEnsembleTT,'mode','individual');
figure;
plot(oobErrorBaggedEnsembleTTind)
xlabel 'Number of trees';
ylabel 'Out-of-bag individual error';

%Variable importance.
figure;
bar(BaggedEnsembleR.OOBPermutedVarDeltaError);
xlabel('Feature number');
ylabel('Out-of-bag feature importance');
title('Feature importance results');
oobErrorFullX = BaggedEnsembleR.oobError;

idxvar = find(BaggedEnsembleTT.OOBPermutedVarDeltaError>5);

% y predicted.
yest = predict(BaggedEnsembleR, xValidation);

% Real y vs. estimate y, sack error

err = yest-yValidation;
ecm = sum(sqrt((yest - yValidacion).^2))/length(yest); 
sprintf('\t\tError %d',  ecm);


sampleEst=datasample(yest',1000);
sampleVal=datasample(yValidation',1000);

figure;%Print estimated vs. real
plot(sampleEst,'x-r');
hold on
plot(sampleVal,'o-g');
xlabel 'n';
ylabel 'y';
legend('Estimated price','Real price');

% Mean y desviación.

mean = mean(err);
deviation = std(err);

mu = [mean mean];
sigma = [desviation desviation];
r=[0,100];

figure;% painted
plot(err,'x-r');
hold on
plot(r,mu);
hold on
plot(r,sigma);
xlabel 'x';
ylabel 'y';
legend('Error','Mean','Desviation');

    
