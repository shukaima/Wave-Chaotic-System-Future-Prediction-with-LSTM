%%
set(0,'DefaultLineLineWidth',3)
set(0,'DefaultAxesFontSize',15)
folder='\\ubf.ece.umd.edu\anlage\Shukai\scaled cavity exp\20181129_onecav_ml\data6';
n=1000;
Nsec=10;
start=1;
S1221sym=0;
numPoints=801;
index = 1:numPoints;
[S11,S12,S21,S22,freq,~]=loadS(folder,n,start,S1221sym,index);

ttnp=200;
aa=(abs(S11(1:ttnp,:))).';

numTimeStepsTrain = 0.9*ttnp;

dataTrain = aa(1,1:numTimeStepsTrain+1);
dataTest = aa(1,numTimeStepsTrain+1:end);
%% Standardize Data
mu = mean(dataTrain);
sig = std(dataTrain);

dataTrainStandardized = (dataTrain - mu) / sig;

%%
X_Train = dataTrainStandardized(1:end-1);
Y_Train = dataTrainStandardized(2:end);

%%
numFeatures = 1;
numResponses = 1;
numHiddenUnits = 200;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];


options = trainingOptions('adam', ...
    'MaxEpochs',200, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');
net = trainNetwork(X_Train,Y_Train,layers,options);

%% and
dataTestStandardized = (dataTest - mu) / sig;
XTest = dataTestStandardized(1:end-1);

net = predictAndUpdateState(net,X_Train);
[net,YPred] = predictAndUpdateState(net,Y_Train(end));

numTimeStepsTest = numel(XTest);
numTimeStepsTest = 500;
for i = 2:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','cpu');
end

YPred = sig*YPred + mu;
YTest = dataTest(2:end);
%rmse = sqrt(mean((YPred-YTest).^2))

%%
figure
plot(dataTrain(1:end-1))
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[aa(1,numTimeStepsTrain) YPred],'.-')
hold off
xlabel("Realization #")
ylabel("abs(S)")
title("LSTM method, scaled cavity S-parameter")
legend(["Observed" "Forecast"])
%%
figure
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
legend(["Observed" "Forecast"])
ylabel("abs(S)")
title("LSTM method, scaled cavity S-parameter")

subplot(2,1,2)
stem(YPred - YTest)
xlabel("Realization #")
ylabel("Error")
title("RMSE = " + rmse)





