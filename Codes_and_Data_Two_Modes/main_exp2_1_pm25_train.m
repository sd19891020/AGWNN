%Models training, PM2.5
clear
close all
clc

dpaths=[".\\DATA\\PM25\\NUVYXY_2019Q1.csv",".\\DATA\\PM25\\NUVYXY_2019Q2.csv",".\\DATA\\PM25\\NUVYXY_2019Q3.csv",".\\DATA\\PM25\\NUVYXY_2019Q4.csv"];
gwrparmpaths=[".\\DATA\\PM25\\GWRParm_2019Q1.mat",".\\DATA\\PM25\\GWRParm_2019Q2.mat",".\\DATA\\PM25\\GWRParm_2019Q3.mat",".\\DATA\\PM25\\GWRParm_2019Q4.mat"];
agwnnpaths=[".\\DATA\\PM25\\AGWNN_2019Q1.mat",".\\DATA\\PM25\\AGWNN_2019Q2.mat",".\\DATA\\PM25\\AGWNN_2019Q3.mat",".\\DATA\\PM25\\AGWNN_2019Q4.mat"];
agwnnnrpaths=[".\\DATA\\PM25\\AGWNN_NR_2019Q1.mat",".\\DATA\\PM25\\AGWNN_NR_2019Q2.mat",".\\DATA\\PM25\\AGWNN_NR_2019Q3.mat",".\\DATA\\PM25\\AGWNN_NR_2019Q4.mat"];

isEarlyStopping=true;
isNormalized=true;
lr=0.001;
mbNum=16;
vsRatio=0.3;
HLNum1=64;
HLNum2=128;
isROP=false;
patience=13;
epochNum=600;
for qi=1:4
    addpath('./Common');
    dataNorm=ReadCsvData(dpaths(qi),12,13,5,6:10);

    isRegressionMode=true;
    addpath('./AGWNN');
    gwrparm=load(gwrparmpaths{qi});
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
    tt5=tic;
    [~,AGWNNModel]= AGWNN(HP); 
    AGWNNModel.TIME=toc(tt5);
    %save(agwnnpaths{qi},'AGWNNModel');
    
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
    tt6=tic;
    [~,AGWNNModel]= AGWNN(HP); 
    AGWNNModel.TIME=toc(tt6);
    %save(agwnnnrpaths{qi},'AGWNNModel');
end


















