%Diagnosis of models predictive capabilities, Y & YHats, 1000 sets
clear
close all
clc

addpath('./Common');
agwnnpath=".\DATA\SYN\AGWNN_S5.mat";
ypath=".\DATA\SYN\S5.csv";
xyspath=".\DATA\SYN\S5_1000.mat";
dataNorm=ReadCsvData(ypath,5,6,4,[1,2,3]);
mXYs=load(xyspath);
addpath('./AGWNN');
mAGWNNModel=load(agwnnpath);
AGWNNModel=mAGWNNModel.AGWNNModel;
[YHat,~] = PY(dataNorm.X,AGWNNModel,dataNorm.Y);
[N,M]=size(dataNorm.X);
OS = STAT(M,N,dataNorm.Y,YHat);
OTIME=AGWNNModel.TIME;
Obw=AGWNNModel.HP.bw;
OENP=AGWNNModel.Stat.ENP;
OAICc=AGWNNModel.Stat.AICc;
OSTAT=[OTIME,OAICc,OS.LOSS,OS.RMSE,OS.R2,OS.R2adj];
loop=1000;
for j=1:loop
    XYs=mXYs.DATA{j};
    X=XYs.X;
    Y=XYs.Y;
    addpath('./AGWNN');
    [PYHat,~] = PY(X,AGWNNModel,Y);
    [N,M]=size(X);
    MS = STAT(M,N,Y,PYHat);
    MSTATS(j,:)=[MS.LOSS,MS.RMSE,MS.R2,MS.R2adj,MS.PR];
    fprintf('loop=%d \n',j);
end
%save(".\\DATA\\SYN\\MSTATS_1000.mat",'MSTATS');
MSTAT=mean(MSTATS(:,1:4));
MSTAT=[0,0,MSTAT];
titles={'TIME','AICc','LOSS','RMSE','R2','R2adj'};
%WriteCsvData(".\\DATA\\SYN\\TABLE_STAT_1000.csv",titles,[OSTAT;MSTAT]);
%STAT of other models have been manually added to the file


addpath('./Common');
outPath1=".\\DATA\\SYN\\RMSE_1000.csv";
outPath2=".\\DATA\\SYN\\PR_1000.csv";
mMSTATS=load(".\\DATA\\SYN\\MSTATS_1000.mat");
MSTATS=mMSTATS.MSTATS;
loop=1000;
IDs=1:loop;
for j=1:loop
    MSTATj=MSTATS(j,:);
    vRMSE(j,1)=MSTATS(j,2);
    vPR(j,1)=MSTATS(j,5);
end
titles={'ID','AGWNN'};
%WriteCsvData(outPath1,titles,[IDs',vRMSE]);
%WriteCsvData(outPath2,titles,[IDs',vPR]);
%RMSE, PR of other models have been manually added to the file






