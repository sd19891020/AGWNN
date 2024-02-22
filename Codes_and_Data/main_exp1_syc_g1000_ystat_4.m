


% 描述： AGWNN模型

clear
close all
clc

addpath('./Common');
addpath('./AGWNN');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
agwnnpath=".\\DATA\\SYN\\AGWNN.mat"; %训练出来的模型
xyspath=".\\DATA\\SYN\\s400_g1000.mat"; %1000组模拟数据，用于评价模型的预测能力
AModel=load(agwnnpath);
AGWNNModel=AModel.AGWNNModel;
XYs=load(xyspath);

loop=1000;
for j=1:loop
    X=XYs.X{j};
    Y=XYs.Y{j};
    YHat = PY(X,AGWNNModel.BetaHat,AGWNNModel.b2);
    [N,M]=size(X);
    STATj = STAT(M,N,Y,YHat);
    STATs(j,:)=[STATj.LOSS,STATj.RMSE,STATj.R2,STATj.R2adj,STATj.PR];
end

OSTAT=[AGWNNModel.Stat.LOSS,AGWNNModel.Stat.RMSE,AGWNNModel.Stat.R2,AGWNNModel.Stat.R2adj];
MSTAT=mean(STATs);
str0=sprintf('原始%d，%s%f，%s%f，%s%f，%s%f',...
   1, 'LOSS=',OSTAT(1),'RMSE=',OSTAT(2),'R2=',OSTAT(3),'R2adj=',OSTAT(4));
disp(str0);%训练性能
str1=sprintf('预测%d，%s%f，%s%f，%s%f，%s%f',...
   1, 'LOSS=',MSTAT(1),'RMSE=',MSTAT(2),'R2=',MSTAT(3),'R2adj=',MSTAT(4));
disp(str1);%预测性能


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%输出1000组预测统计结果
outPath1=".\\DATA\\SYN\\LOSS.csv";
outPath2=".\\DATA\\SYN\\RMSE.csv";
outPath3=".\\DATA\\SYN\\PR.csv";
titles1={'ID','loss_agwnn'};
titles2={'ID','rmse_agwnn'};
titles3={'ID','pr_agwnn'};
IDs=1:1000;
vals1=[IDs',STATs(:,1)];
WriteCsvData(outPath1,titles1,vals1);
vals2=[IDs',STATs(:,2)];
WriteCsvData(outPath2,titles2,vals2);
vals3=[IDs',STATs(:,5)];
%WriteCsvData(outPath3,titles3,vals3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%其他模型的预测统计结果已手动加入到文件中






