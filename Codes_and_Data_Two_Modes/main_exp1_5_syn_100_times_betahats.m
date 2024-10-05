%Regression coefficients visualization, AGWNN vs. GWR and GNNWR, BetaHats, 100 times
clc;
clear;

addpath('./Common');
ypath=".\DATA\SYN\S5.csv";
gwrparmpath=".\DATA\SYN\GWRParm_S5.mat";
mgnnwrbhspath=".\DATA\SYN\GNNWR_MEAN_BHS_S5.mat";
agwnnbhspath=".\DATA\SYN\AGWNN_BHS_S5.mat";
magwnnbhspath=".\DATA\SYN\AGWNN_MEAN_BHS_S5.mat";

% %Training AGWNN 100 times
% gwrparm=load(gwrparmpath);
% GWRParm=gwrparm.GWRParm;
% bw=GWRParm.bw;
% dataNorm=ReadCsvData(ypath,5,6,4,[1,2,3]);
% isRegressionMode=true;
% isEarlyStopping=true;
% isNormalized=true;
% lr=0.001;
% mbNum=16;
% vsRatio=0.3;
% isROP=false;
% patience=13;
% epochNum=300;
% HLNum1=64;
% HLNum2=128;
% times=100;
% BHS=zeros((dataNorm.xNum+1),dataNorm.n,times);
% BSTATS=zeros(1,(dataNorm.xNum+1)*2,times);
% for ti=1:times
%     addpath('./AGWNN');
%     yNum=1;
%     xNum=dataNorm.xNum;
%     trainSampleNum=dataNorm.n;
%     BNum=xNum+1;
%     NN.LYNum=5;
%     NN.LTNs={"input","hidden","hidden","GW","output"};
%     NN.LNNums=[xNum,HLNum1,HLNum2,trainSampleNum,yNum];
%     NN.Next_LNNums=[NN.LNNums(1,2:end),1];
%     if isRegressionMode
%         NN.LAFNs={"none","none","none","GW","none"};
%     else
%         NN.LAFNs={"none","softsign","softsign","GW","softsign"};
%     end
%     [HP] = MakeAGWNNHP(dataNorm,bw,NN);
%     HP.patience=patience;
%     HP.vsRatio=vsRatio;
%     HP.mbNum=mbNum;
%     HP.isRegressionMode=isRegressionMode;
%     HP.isEarlyStopping=isEarlyStopping;
%     HP.epochNum=epochNum;
%     HP.aLoopEpochNum=3;
%     HP.lr=lr;
%     HP.gwlr=HP.lr*0.001;
%     tt5=tic;
%     [~,AGWNNModel]= AGWNN(HP); 
%     AGWNNModel.TIME=toc(tt5);
%     BHS(:,:,ti)=AGWNNModel.BetaHat;
%     
%     tBS=[OBS;AGWNNModel.BetaHat];
%     [tNBS,~]=mapminmax(tBS,0,betaMax);
%     for bi=1:(dataNorm.xNum+1)
%         tSTs = STAT(1,dataNorm.n,tNBS(bi,:)',tNBS(bi+4,:)');
%         BSTATS(1,bi,ti)=tSTs.PR;
%         BSTATS(1,bi+4,ti)=tSTs.RMSE;
%     end
% end
% %save(agwnnbhspath,'BHS');
% MBHS=mean(BHS,3);
% %save(magwnnbhspath,'MBHS');

%Drawing plot
n=400;
BNum=4;
betaMax=4;
odataNorm=ReadCsvData3(ypath);
UV=odataNorm.VARS(:,5:6);
UU=UV(:,1)';
VV=UV(:,2)';
OBS=odataNorm.VARS(:,7:10)';
gwrparm=load(gwrparmpath);
GWRParm=gwrparm.GWRParm;
GWRBHS=GWRParm.BetaHat';
mMGNNWRBHS=load(mgnnwrbhspath);
MGNNWRBHS=mMGNNWRBHS.MBHS;
mMAGWNNBHS=load(magwnnbhspath);
MAGWNNBHS=mMAGWNNBHS.MBHS;

mABHS=load(agwnnbhspath);
ABHSS=mABHS.BHS;
times=100;
BSTATS=zeros(1,BNum,times);
for ti=1:times
    tBS=[OBS;ABHSS(:,:,ti)];
    [tNBS,~]=mapminmax(tBS,0,betaMax);
    for bi=1:BNum
        tSTs = STAT(1,n,tNBS(bi,:)',tNBS(bi+4,:)');
        BSTATS(1,bi,ti)=tSTs.RMSE;
    end
end
ABSTAT=mean(BSTATS,3);

OGGBSTAT=[0.2945,0.6803,0.9528,1.3912;...
          1.0133,0.4604,0.4968,0.5142;...
          0.9961,0.4516,0.4833,0.5093];

OAGSTAT=[OGGBSTAT;ABSTAT];
BS=[OBS;GWRBHS;MGNNWRBHS;MAGWNNBHS];
[NBS,~]=mapminmax(BS,0,betaMax);

xticks1=[];
yticks1=[];
xticks2=[0,5,10,15,20];
yticks2=[0,5,10,15,20];

xNum=20;
yNum=20;
fig=figure(1);
srNum=4;
scNum=4;
txts{1,1}="¦Â_a";txts{1,2}="¦Â_b";txts{1,3}="¦Â_c";txts{1,4}="¦Â_d";
for sr=1:srNum
    for sc=1:scNum
        index=(sr-1)*scNum+sc;
        subFig(sr,sc)=subplot(srNum,scNum,index);
        xticks=xticks1;
        yticks=yticks1;
        if index==1 || index==5 || index==9 || index==13
            yticks=yticks2;
        end
        if index==13 || index==14 || index==15 || index==16
            xticks=xticks2;
        end
        if sr>1
            txts{sr,sc}=sprintf('RMSE=%0.3f',OAGSTAT(sr,sc));
        end
        ShowSubFigureY(subFig(sr,sc),xNum,yNum,UU,VV,NBS(index,:),0,betaMax,txts{sr,sc},xticks,yticks);
    end
end


