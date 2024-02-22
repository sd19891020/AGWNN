



clc;
clear;

addpath('./Common');
addpath('./AGWNN');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%设置不同数量的地理神经元，用于诊断训练样本与回归能力的关系
dmpath=".\\DATA\\SYN\\s400.mat";
gwpath=".\\DATA\\SYN\\GW_FG.mat";
agwnnpath=".\\DATA\\SYN\\AGWNN.mat";
dData=load(dmpath);
allDataNorm=dData.dataNorm;
gwData=load(gwpath);
allGW=gwData.GW;

%超参数具体设置
HP.patience=3;%耐心轮数一般设为13
HP.isNormalized=false;
HP.vsRatio=0.3; %测试集比率
HP.mbNum=16;
HP.isEarlyStopping=true;%是否启用早停（训练过程中开启早停策略）
HP.epochNum=600;
HP.aLoopEpochNum=33;%可早停轮数
HP.lr=0.009;
HP.gw_factor=0.01;
HP.gwlr=HP.lr*HP.gw_factor;

spaths=[".\\DATA\\SYN\\gn400.mat",".\\DATA\\SYN\\gn350.mat",...
    ".\\DATA\\SYN\\gn300.mat",".\\DATA\\SYN\\gn250.mat",...
    ".\\DATA\\SYN\\gn200.mat",".\\DATA\\SYN\\gn150.mat"];
tNums=[400,350,300,250,200,150];
for si=1:6
    targetNum=tNums(si);
    [TS,HP3] = MakeAGWNNHP3(targetNum,allDataNorm,allGW);
    %更新超参数设置
    HP.w1=HP3.w1;
    HP.w2=HP3.w2;
    HP.b1=HP3.b1;
    HP.b2=HP3.b2;
    HP.GW=HP3.GW;
    HP.fgw=HP3.fgw;
    tt=tic;
    [~,~,~,~,AGWNNModel]= AGWNN3(TS,HP); 
    AGWNNModel.TIME=toc(tt);
    AGWNNModel.HLIndexs=HP3.HLIndexs;
    AGWNNModel.ALLX=TS.allXORI;
    AGWNNModel.ALLY=TS.allYORI;
    [AGWNNModel.ALLYHat,AGWNNModel.ALLBetaHat] = PY3(AGWNNModel.HLIndexs,allGW,TS.allXORI,TS.allYORI,AGWNNModel.w1,AGWNNModel.b1,AGWNNModel.w2,AGWNNModel.b2,AGWNNModel.fgw);
    AGWNNModel.ALLStat = STAT(3,400,AGWNNModel.ALLY,AGWNNModel.ALLYHat);
    %save(spaths(si),'AGWNNModel');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%不同训练样本条件下，模型性能和效率出图
dmpath=".\\DATA\\SYN\\s400.mat";
spaths=[".\\DATA\\SYN\\gn400.mat",".\\DATA\\SYN\\gn350.mat",...
    ".\\DATA\\SYN\\gn300.mat",".\\DATA\\SYN\\gn250.mat",...
    ".\\DATA\\SYN\\gn200.mat",".\\DATA\\SYN\\gn150.mat"];

xNum=20;
yNum=20;

dData=load(dmpath);
dataNorm=dData.dataNorm;
oNum=dataNorm.n;
UV=[dataNorm.u,dataNorm.v]';
UU=UV(1,:);
VV=UV(2,:);
fig=figure('color','w');

srNum=6;
scNum=9;
scNum1=5;
for sr=1:srNum
    for sc=1:scNum1
        index=(sr-1)*scNum+sc;
        subFig(index)=subplot(srNum,scNum,index);
    end
end

ssFig1=subplot(srNum,scNum,[6,15,24,33,42,51]);
ssFig2=subplot(srNum,scNum,[7,16,25,34,43,52]);
ssFig3=subplot(srNum,scNum,[8,17,26,35,44,53]);
ssFig4=subplot(srNum,scNum,[9,18,27,36,45,54]);

sNum=1;
for asid=1:srNum
    sId=(asid-1)*scNum+sNum;
    aModel=load(spaths(asid));
    mModel=aModel.AGWNNModel;
    HLIndexs=mModel.HLIndexs;
    %第一列
    mSamples=zeros(1,oNum)*nan;
    mSamples(1,HLIndexs)=1;
    ShowSubFigure3(subFig(sId),xNum,yNum,UU,VV,mSamples);
    %其余列
    ALLBetas=mModel.ALLBetaHat;
    compute_beta0=ALLBetas(:,1)';
    compute_beta1=ALLBetas(:,2)';
    compute_beta2=ALLBetas(:,3)';
    compute_beta3=ALLBetas(:,4)';
    ShowSubFigure3(subFig(sId+1),xNum,yNum,UU,VV,compute_beta0);
    ShowSubFigure3(subFig(sId+2),xNum,yNum,UU,VV,compute_beta1);
    ShowSubFigure3(subFig(sId+3),xNum,yNum,UU,VV,compute_beta2);
    ShowSubFigure3(subFig(sId+4),xNum,yNum,UU,VV,compute_beta3);
end

for asid=1:srNum
    aModel=load(spaths(asid));
    mModel=aModel.AGWNNModel;
    mTime(asid)=mModel.TIME;
    mR2adj(asid)=mModel.ALLStat.R2adj;
end
barh(ssFig2,mTime);
barh(ssFig3,mR2adj);








