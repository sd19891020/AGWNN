%Models training
clc;
clear;


addpath('./Common');
ypaths={".\DATA\SYN\S1.csv",".\DATA\SYN\S2.csv",".\DATA\SYN\S3.csv",".\DATA\SYN\S4.csv",".\DATA\SYN\S5.csv"};
gwrparmpaths={".\DATA\SYN\GWRParm_S1.mat",".\DATA\SYN\GWRParm_S2.mat",".\DATA\SYN\GWRParm_S3.mat",".\DATA\SYN\GWRParm_S4.mat",".\DATA\SYN\GWRParm_S5.mat"};
agwnnpaths={".\DATA\SYN\AGWNN_S1.mat",".\DATA\SYN\AGWNN_S2.mat",".\DATA\SYN\AGWNN_S3.mat",".\DATA\SYN\AGWNN_S4.mat",".\DATA\SYN\AGWNN_S5.mat"};
agwnnnrpaths={".\DATA\SYN\AGWNN_NR_S1.mat",".\DATA\SYN\AGWNN_NR_S2.mat",".\DATA\SYN\AGWNN_NR_S3.mat",".\DATA\SYN\AGWNN_NR_S4.mat",".\DATA\SYN\AGWNN_NR_S5.mat"};

isEarlyStopping=true;
isNormalized=true;
lr=0.001;
mbNum=16;
vsRatio=0.3;
isROP=false;
patience=13;
epochNum=600;
HLNum1=64;
HLNum2=128;
for yi=1:5
    if yi<5
        dataNorm=ReadCsvData(ypaths{yi},4,5,3,[1,2]);
    else
        dataNorm=ReadCsvData(ypaths{yi},5,6,4,[1,2,3]);
    end
    
    %Regression mode
    isRegressionMode=true;
    addpath('./AGWNN');
    gwrparm=load(gwrparmpaths{yi});
    GWRParm=gwrparm.GWRParm;
    bw=GWRParm.bw;
    yNum=1;
    xNum=dataNorm.xNum;
    trainSampleNum=dataNorm.n;
    BNum=xNum+1;
    NN.LYNum=5;
    NN.LTNs={"input","hidden","hidden","GW","output"};
    NN.LNNums=[xNum,HLNum1,HLNum2,trainSampleNum,yNum];
    NN.Next_LNNums=[NN.LNNums(1,2:end),1];
    if isRegressionMode
        NN.LAFNs={"none","none","none","GW","none"};
    else
        NN.LAFNs={"none","softsign","softsign","GW","softsign"};
    end
    [HP] = MakeAGWNNHP(dataNorm,bw,NN);
    HP.patience=patience;
    HP.vsRatio=vsRatio;
    HP.mbNum=mbNum;
    HP.isRegressionMode=isRegressionMode;
    HP.isEarlyStopping=isEarlyStopping;
    HP.epochNum=epochNum;
    HP.aLoopEpochNum=3;
    HP.lr=lr;
    HP.gwlr=HP.lr*0.001;
    tt6=tic;
    [~,AGWNNModel]= AGWNN(HP); 
    AGWNNModel.TIME=toc(tt6);
    %save(agwnnpaths{yi},'AGWNNModel');
    
    %Non-Regression mode
    isRegressionMode=false;
    if isRegressionMode
        NN.LAFNs={"none","none","none","GW","none"};
    else
        NN.LAFNs={"none","softsign","softsign","GW","softsign"};
    end
    [HP] = MakeAGWNNHP(dataNorm,bw,NN);
    HP.patience=patience;
    HP.vsRatio=vsRatio;
    HP.mbNum=mbNum;
    HP.isRegressionMode=isRegressionMode;
    HP.isEarlyStopping=isEarlyStopping;
    HP.epochNum=epochNum;
    HP.aLoopEpochNum=3;
    HP.lr=lr;
    HP.gwlr=HP.lr*0.001;
    tt7=tic;
    [~,AGWNNModel]= AGWNN(HP); 
    AGWNNModel.TIME=toc(tt7);
    %save(agwnnnrpaths{yi},'AGWNNModel');
    
end

%YHat of other models have been manually added to the corresponding file
addpath('./Common');
ypaths={".\DATA\SYN\S1.csv",".\DATA\SYN\S2.csv",".\DATA\SYN\S3.csv",".\DATA\SYN\S4.csv"};
agwnnpaths={".\DATA\SYN\AGWNN_S1.mat",".\DATA\SYN\AGWNN_S2.mat",".\DATA\SYN\AGWNN_S3.mat",".\DATA\SYN\AGWNN_S4.mat"};
agwnnnrpaths={".\DATA\SYN\AGWNN_NR_S1.mat",".\DATA\SYN\AGWNN_NR_S2.mat",".\DATA\SYN\AGWNN_NR_S3.mat",".\DATA\SYN\AGWNN_NR_S4.mat"};
agwnnypaths={".\DATA\SYN\YYH_S1.csv",".\DATA\SYN\YYH_S2.csv",".\DATA\SYN\YYH_S3.csv",".\DATA\SYN\YYH_S4.csv"};
for yi=1:4
    dataNorm=ReadCsvData(ypaths{yi},4,5,3,[1,2]);
    mAGWNNModel=load(agwnnpaths{yi});
    AGWNNModel=mAGWNNModel.AGWNNModel;
    mAGWNNNRModel=load(agwnnnrpaths{yi});
    AGWNNNRModel=mAGWNNNRModel.AGWNNModel;
    titles={'Y','AGWNN_YH','AGWNN_NR_YH'};
    vals=[dataNorm.Y,AGWNNModel.YHat',AGWNNNRModel.YHat'];
    %WriteCsvData(agwnnypaths{yi},titles,vals);
end








