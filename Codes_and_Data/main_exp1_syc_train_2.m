



clc;
clear;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%400�����������򻯣���ȡGWR-FG�Ŀռ�Ȩ��GW�����������糬������AGWNN
addpath('./Common');
addpath('./AGWNN');
dmpath=".\\DATA\\SYN\\s400.mat";
gwpath=".\\DATA\\SYN\\GW_FG.mat";
agwnnpath=".\\DATA\\SYN\\AGWNN.mat";
dData=load(dmpath);
dataNorm=dData.dataNorm;
gwData=load(gwpath);
GW=gwData.GW;

%��������������
[TS,HP] = MakeAGWNNHP(dataNorm,GW);
HP.patience=3;%��������һ����Ϊ13
HP.isNormalized=false;
HP.vsRatio=0.3; %���Լ�����
HP.mbNum=16;
HP.isEarlyStopping=true;%�Ƿ�������ͣ��ѵ�������п�����ͣ���ԣ�
HP.epochNum=900;
HP.aLoopEpochNum=33;%����ͣ����
HP.lr=0.009;
HP.gw_factor=0.01;
HP.gwlr=HP.lr*HP.gw_factor;
tt=tic;
[~,~,~,~,AGWNNModel]= AGWNN(TS,HP); 
AGWNNModel.TIME=toc(tt);
%save(agwnnpath,'AGWNNModel');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����������ꡢY��YHat���
outPath=".\\DATA\\SYN\\YPY.csv";
titles={'U','V','Y','AGWNN_Yhat'};
vals=[dataNorm.u,dataNorm.v,dataNorm.Y,AGWNNModel.YHat'];
%WriteCsvData(outPath,titles,vals);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ģ�͵�YHat������ֶ����뵽�ļ���


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ԭʼBeta��AGWNN BetaHat�͵�������
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ģ�͵�BetaHat���ֶ����뵽�ļ���








