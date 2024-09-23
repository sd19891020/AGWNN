%Models training
clc;
clear;

addpath('./Common');
ypaths={".\DATA\SYN\S1.csv",".\DATA\SYN\S2.csv",".\DATA\SYN\S3.csv",".\DATA\SYN\S4.csv",".\DATA\SYN\S5.csv"};
gwrparmpaths={".\DATA\SYN\GWRParm_S1.mat",".\DATA\SYN\GWRParm_S2.mat",".\DATA\SYN\GWRParm_S3.mat",".\DATA\SYN\GWRParm_S4.mat",".\DATA\SYN\GWRParm_S5.mat"};
agwnnpaths={".\DATA\SYN\AGWNN_S1.mat",".\DATA\SYN\AGWNN_S2.mat",".\DATA\SYN\AGWNN_S3.mat",".\DATA\SYN\AGWNN_S4.mat",".\DATA\SYN\AGWNN_S5.mat"};
isEarlyStopping=true;
isNormalized=true;
lr=0.001;
mbNum=16;
vsRatio=0.3;
HLNum=256;
isROP=false;
patience=9;
epochNum=600;
for yi=1:5
    if yi<5
        dataNorm=ReadCsvData(ypaths{yi},4,5,3,[1,2]);
    else
        dataNorm=ReadCsvData(ypaths{yi},5,6,4,[1,2,3]);
    end

    addpath('./AGWNN');
    gwrparm=load(gwrparmpaths{yi});
    GWRParm=gwrparm.GWRParm;
    bw=GWRParm.bw;
    GWRBH=GWRParm.BetaHat;
    yNum=1;
    xNum=dataNorm.xNum;
    trainSampleNum=dataNorm.n;
    BNum=xNum+1;
    NN.HNNum=HLNum;
    NN.LYNum=6;
    NN.LTNs={"input","hidden","output","input","GW","output"};
    NN.LNNums=[BNum,NN.HNNum,BNum,xNum,trainSampleNum,yNum];
    NN.Next_LNNums=[NN.LNNums(1,2:end),1];
    NN.LAFNs={"none","softsign","softsign","none","GW","none"};
    [HP] = MakeAGWNNHP(dataNorm,bw,GWRBH,NN);
    HP.patience=patience;
    HP.vsRatio=vsRatio;
    HP.mbNum=mbNum;
    HP.isEarlyStopping=isEarlyStopping;
    HP.epochNum=epochNum;
    HP.aLoopEpochNum=3;
    HP.lr=lr;
    HP.gwlr=HP.lr*0.01;
    tt5=tic;
    [~,AGWNNModel]= AGWNN(HP); 
    AGWNNModel.TIME=toc(tt5);
    %save(agwnnpaths{yi},'AGWNNModel');
end

