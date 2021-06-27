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

clear aa1 aa2
aa2=abs(S11);

aa1=(abs(S21));
K=1000;
%%
clear uu ss x t
nincc=70;
ninc=5;
start=51;
step=4;
step2=66;
%uu=real(aa1(1:K,start:start+nincc-1)).';
%ss=real(aa2(1:K,start:start+ninc-1)).';
clear i
for i=1:nincc
    uu(i,:)=real(aa1(1:K,start+i*step)).';
end
for i=1:ninc
    ss(i,:)=real(aa2(1:K,start+i*step2)).';
end
clear x t
x=con2seq(uu);
t=con2seq(ss);
%% train
clear X_train T_train Xs Xi Ai Ts
nptrain=0.9*K;
X_train=x(1:nptrain);
T_train=t(1:nptrain);
net = layrecnet(1:2,38);
net.trainParam.epochs=40; %40 is good
[Xs,Xi,Ai,Ts] = preparets(net,X_train,T_train);
net = train(net,Xs,Ts,Xi,Ai);
view(net)
Y_train = net(Xs,Xi,Ai);
perf = perform(net,Y_train,Ts)
%% plot train
key=cell2mat(Ts);
rsnet=cell2mat(Y_train);
plotpick=randi([1 nptrain-2]);
h=figure
hold on
fig1=plot(1:ninc,key(:,plotpick),'Displayname','data');
fig2=plot(1:ninc,rsnet(:,plotpick),'Displayname','predict');
legend([fig1,fig2]);
xlabel(['frequency points']);
box on
title(['train result of realization #', num2str(plotpick)]);
hold off
%%
plotpick=4;
h=figure
hold on
fig1=plot(1:nptrain-2,key(plotpick,:),'Displayname','data');
fig2=plot(1:nptrain-2,rsnet(plotpick,:),'Displayname','predict');
legend([fig1,fig2]);
xlabel(['realization']);
xlim([1,nptrain-2]);
box on
title(['train result of series #', num2str(plotpick)]);
hold off
%% 
%%tst %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear X_tst T_tst Xss Xis Ais Tss
[~,npf]=size(x);
X_tst=x(1:npf);
T_tst=t(1:npf);
[Xss,Xis,Ais,Tss] = preparets(net,X_tst,T_tst);
Y_tst = net(Xss,Xis,Ais);
perf = perform(net,Y_tst,Tss)
key=cell2mat(Tss);
rsnet=cell2mat(Y_tst);
%% plot tst

plotpick=randi([nptrain-2,K-2]);
h=figure
hold on
fig1=plot(1:ninc,key(:,plotpick),'Displayname','data');
fig2=plot(1:ninc,rsnet(:,plotpick),'Displayname','predict');
legend([fig1,fig2]);
xlabel(['frequency points']);
box on
title(['test result of realization #', num2str(plotpick)]);
hold off
%%
plotpick=2;
h=figure
hold on
fig1=plot(nptrain+1:K-2,key(plotpick,nptrain+1:K-2),'Displayname','data');
fig2=plot(nptrain+1:K-2,rsnet(plotpick,nptrain+1:K-2),'Displayname','predict');
legend([fig1,fig2]);
xlabel(['realization']);
box on
title(['test result of series #', num2str(plotpick)]);
hold off

%%
plotpick=2;
h=subplot(2,1,1)
hold on
fig1=plot(nptrain+1:K-2,key(plotpick,nptrain+1:K-2),'Displayname','data');
fig2=plot(nptrain+1:K-2,rsnet(plotpick,nptrain+1:K-2),'Displayname','predict');legend;
box on
ylabel(['output and target']);
%title(['test result of series #', num2str(plotpick)]);
hold off

h=subplot(2,1,2)

hold on
fig0=plot(nptrain+1:K-2,abs(key(plotpick,nptrain+1:K-2)-rsnet(plotpick,nptrain+1:K-2)),'Displayname','error');

xlabel(['realization']);
ylabel(['|error|']);
box on
hold off
