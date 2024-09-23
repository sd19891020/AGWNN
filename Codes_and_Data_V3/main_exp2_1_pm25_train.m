%Models training, PM2.5
clear
close all
clc

dpaths=[".\\DATA\\PM25\\NUVYXY_2019Q1.csv",".\\DATA\\PM25\\NUVYXY_2019Q2.csv",".\\DATA\\PM25\\NUVYXY_2019Q3.csv",".\\DATA\\PM25\\NUVYXY_2019Q4.csv"];
gwrparmpaths=[".\\DATA\\PM25\\GWRParm_2019Q1.mat",".\\DATA\\PM25\\GWRParm_2019Q2.mat",".\\DATA\\PM25\\GWRParm_2019Q3.mat",".\\DATA\\PM25\\GWRParm_2019Q4.mat"];
agwnnpaths=[".\\DATA\\PM25\\AGWNN_2019Q1.mat",".\\DATA\\PM25\\AGWNN_2019Q2.mat",".\\DATA\\PM25\\AGWNN_2019Q3.mat",".\\DATA\\PM25\\AGWNN_2019Q4.mat"];
isEarlyStopping=true;
isNormalized=true;
lr=0.001;
mbNum=16;
vsRatio=0.3;
HLNum=256;
isROP=false;
patience=9;
epochNum=100;
for qi=1:4
    addpath('./Common');
    dataNorm=ReadCsvData(dpaths(qi),12,13,5,6:10);

    addpath('./AGWNN');
    mGWRParm=load(gwrparmpaths{qi});
    GWRParm=mGWRParm.GWRParm;
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
    HP.gwlr=HP.lr*0.001;
    tt5=tic;
    [~,AGWNNModel]= AGWNN(HP); 
    AGWNNModel.TIME=toc(tt5);
    %save(agwnnpaths{qi},'AGWNNModel');
end


