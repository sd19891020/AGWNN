%Diagnosing the relationship between training samples and regression capacity, different numbers of geographic neurons
clear
close all
clc

addpath('./Common');
addpath('./AGWNN');

dmpath=".\\DATA\\SYN\\S5.csv";
gwrparmpath=".\\DATA\\SYN\\GWRParm_S5.mat";

allDataNorm=ReadCsvData(dmpath,5,6,4,[1,2,3]);
gwrparm=load(gwrparmpath);
GWRParm=gwrparm.GWRParm;
bw=GWRParm.bw;

isRegressionMode=true;
isEarlyStopping=false;
isNormalized=true;
lr=0.001;
mbNum=16;
vsRatio=0.3;
HLNum1=64;
HLNum2=128;
isROP=false;
patience=13;
epochNum=600;

spaths=[".\\DATA\\SYN\\gn400.mat",".\\DATA\\SYN\\gn350.mat",...
    ".\\DATA\\SYN\\gn300.mat",".\\DATA\\SYN\\gn250.mat",...
    ".\\DATA\\SYN\\gn200.mat",".\\DATA\\SYN\\gn150.mat"];
tNums=[400,350,300,250,200,150];
for si=1:6
    targetNum=tNums(si);
    rand_index = randperm(allDataNorm.n);
    GNIndexs = sort(rand_index(1:targetNum));
    
    dataNorm.xNum=allDataNorm.xNum;
    dataNorm.n =targetNum;
    dataNorm.u=allDataNorm.u(GNIndexs,:);
    dataNorm.v=allDataNorm.v(GNIndexs,:);
    dataNorm.Y=allDataNorm.Y(GNIndexs,:);
    dataNorm.X=allDataNorm.X(GNIndexs,:);
    dataNorm.XOne =allDataNorm.XOne(GNIndexs,:);
    dataNorm.XI =allDataNorm.XI(GNIndexs,:);
    dataNorm.VARS=allDataNorm.VARS(GNIndexs,:);  

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
    [HP_ALL] = MakeAGWNNHP(allDataNorm,bw,NN);
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
    
    AGWNNModel.GNIndexs=GNIndexs;
    AGWNNModel.ALLX=allDataNorm.X;
    AGWNNModel.ALLY=allDataNorm.Y;
    [AGWNNModel.ALLYHat,~,AGWNNModel.ALLBetaHat] = PY3(AGWNNModel.ALLX,AGWNNModel.ALLY,HP_ALL,AGWNNModel);
    AGWNNModel.ALLStat = STAT(allDataNorm.xNum,allDataNorm.n,AGWNNModel.ALLY,AGWNNModel.ALLYHat);
    %save(spaths(si),'AGWNNModel');
end


dmpath=".\\DATA\\SYN\\S5.csv";
spaths=[".\\DATA\\SYN\\gn400.mat",".\\DATA\\SYN\\gn350.mat",...
    ".\\DATA\\SYN\\gn300.mat",".\\DATA\\SYN\\gn250.mat",...
    ".\\DATA\\SYN\\gn200.mat",".\\DATA\\SYN\\gn150.mat"];

epochNum=600;
betaMax=4;
xNum=20;
yNum=20;

dataNorm=ReadCsvData(dmpath,5,6,4,[1,2,3]);
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

xticks=[];
yticks=[];
sNum=1;
tNums=[400,350,300,250,200,150];
for asid=1:srNum
    sId=(asid-1)*scNum+sNum;
    aModel=load(spaths(asid));
    mModel=aModel.AGWNNModel;
    GNIndexs=mModel.GNIndexs;
    
    mSamples=zeros(1,oNum)*nan;
    mSamples(1,GNIndexs)=1;
    ShowSubFigureY(subFig(sId),xNum,yNum,UU,VV,mSamples,0,4,'',xticks,yticks);
    
    ALLBetas=mModel.ALLBetaHat;
    [ALLBetas,~]=mapminmax(ALLBetas,0,betaMax);
    ALLBetas=ALLBetas';
    compute_beta0=ALLBetas(:,1)';
    compute_beta1=ALLBetas(:,2)';
    compute_beta2=ALLBetas(:,3)';
    compute_beta3=ALLBetas(:,4)';
    ShowSubFigureY(subFig(sId+1),xNum,yNum,UU,VV,compute_beta0,0,betaMax,'',xticks,yticks);
    ShowSubFigureY(subFig(sId+2),xNum,yNum,UU,VV,compute_beta1,0,betaMax,'',xticks,yticks);
    ShowSubFigureY(subFig(sId+3),xNum,yNum,UU,VV,compute_beta2,0,betaMax,'',xticks,yticks);
    ShowSubFigureY(subFig(sId+4),xNum,yNum,UU,VV,compute_beta3,0,betaMax,'',xticks,yticks);
    
    targetNum=tNums(asid);
    fprintf('GN=%d£¬TIME=%0.2f£¬R2=%0.4f£¬ecpch=%d / 600 \n',targetNum,mModel.TIME,mModel.ALLStat.R2,mModel.epochIndex);
end

for asid=1:srNum
    aModel=load(spaths(asid));
    mModel=aModel.AGWNNModel;
    mTime(asid)=mModel.TIME;
    mR2(asid)=mModel.ALLStat.R2;
    mEE{asid}=sprintf('%d/%d',mModel.epochIndex,epochNum);
end
barh(ssFig2,mTime);
barh(ssFig3,mR2);








