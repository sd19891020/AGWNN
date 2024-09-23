%Diagnosis of models predictive capabilities, Y & YHats, 1000 sets
clear
close all
clc

addpath('./Common');
agwnnpath=".\DATA\SYN\AGWNN_S5.mat";
ypath=".\DATA\SYN\S5.csv";
xyspath=".\DATA\SYN\S5_1000.mat";
outPath=".\\DATA\\SYN\\AGWNN_STAT_1000.csv";

dataNorm=ReadCsvData(ypath,5,6,4,[1,2,3]);
mXYs=load(xyspath);
mAGWNNModel=load(agwnnpath);
Model5=mAGWNNModel.AGWNNModel;
addpath('./AGWNN');
[YHat5,~] = PY(dataNorm.X,Model5,dataNorm.Y,false);
[N,M]=size(dataNorm.X);
OSTATs5 = STAT(M,N,dataNorm.Y,YHat5);

loop=1000;
for j=1:loop
    XYs=mXYs.DATA{j};
    X=XYs.X;
    Y=XYs.Y;
    addpath('./AGWNN');
    [PYHat5,~] = PY(X,Model5,Y,true);
    [N,M]=size(X);
    for mi=1:5
        MSTATs{j} = STAT(M,N,Y,PYHat5);
    end
end

mName5="AGWNN";
OS=OSTATs5;
OSTAT=[OS.LOSS,OS.RMSE,OS.R2,OS.R2adj];
for j=1:loop
    MS=MSTATs{j};
    MSTATmi(j,:)=[MS.LOSS,MS.RMSE,MS.R2,MS.R2adj,MS.PR];
end
MSTAT=mean(MSTATmi);
str0=sprintf('O-%s£¬%s%f£¬%s%f£¬%s%f£¬%s%f',...
   mName5, 'LOSS=',OSTAT(1),'RMSE=',OSTAT(2),'R2=',OSTAT(3),'R2adj=',OSTAT(4));
disp(str0);
str1=sprintf('P-%s£¬%s%f£¬%s%f£¬%s%f£¬%s%f',...
   mName5, 'LOSS=',MSTAT(1),'RMSE=',MSTAT(2),'R2=',MSTAT(3),'R2adj=',MSTAT(4));
disp(str1);

titles={'ID','LOSS','RMSE','R2','R2adj','PR'};
IDs=1:loop;
%WriteCsvData(outPath,titles,[IDs',MSTATmi]);






