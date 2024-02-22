



clc;
clear;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%400样本，非正则化，获取GWR-FG的空间权重GW并生成神经网络超参数，AGWNN
addpath('./Common');
addpath('./AGWNN');
dmpath=".\\DATA\\SYN\\s400.mat";
gwpath=".\\DATA\\SYN\\GW_FG.mat";
agwnnpath=".\\DATA\\SYN\\AGWNN.mat";
dData=load(dmpath);
dataNorm=dData.dataNorm;
gwData=load(gwpath);
GW=gwData.GW;

%超参数具体设置
[TS,HP] = MakeAGWNNHP(dataNorm,GW);
HP.patience=3;%耐心轮数一般设为13
HP.isNormalized=false;
HP.vsRatio=0.3; %测试集比率
HP.mbNum=16;
HP.isEarlyStopping=true;%是否启用早停（训练过程中开启早停策略）
HP.epochNum=900;
HP.aLoopEpochNum=33;%可早停轮数
HP.lr=0.009;
HP.gw_factor=0.01;
HP.gwlr=HP.lr*HP.gw_factor;
tt=tic;
[~,~,~,~,AGWNNModel]= AGWNN(TS,HP); 
AGWNNModel.TIME=toc(tt);
%save(agwnnpath,'AGWNNModel');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%输出地理坐标、Y和YHat结果
outPath=".\\DATA\\SYN\\YPY.csv";
titles={'U','V','Y','AGWNN_Yhat'};
vals=[dataNorm.u,dataNorm.v,dataNorm.Y,AGWNNModel.YHat'];
%WriteCsvData(outPath,titles,vals);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%其他模型的YHat结果已手动加入到文件中


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%输出原始Beta、AGWNN BetaHat和地理坐标
dmpath=".\\DATA\\SYN\\s400.mat";
betapath=".\\DATA\\SYN\\s400_beta.mat";
agwnnpath=".\\DATA\\SYN\\AGWNN.mat";
bspath=".\\DATA\\SYN\\BBHUV.csv";
addpath('./Common');
vals=[];
bData=load(betapath);
Beta=bData.Beta;
vals=[vals,Beta];
aModel=load(agwnnpath);
AGWNNModel=aModel.AGWNNModel;
AGWNNBetaHat=AGWNNModel.BetaHat;
vals=[vals,AGWNNBetaHat];
dData=load(dmpath);
dataNorm=dData.dataNorm;
vals=[vals,dataNorm.u,dataNorm.v];
titles={'OBeta0','OBeta1','OBeta2','OBeta3',...
    'AGWNNBetaHat0','AGWNNBetaHat1','AGWNNBetaHat2','AGWNNBetaHat3',...
    'U','V'};
%WriteCsvData(bspath,titles,vals);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%其他模型的BetaHat已手动加入到文件中








