

clc;
clear;

addpath('./Common');
addpath('./AGWNN');

%%%%%%%%%%%%%%%%%%%%%%%四个季度训练,正则化，AGWNN
dpaths=[".\\DATA\\PM25\\NUVYXY_2019Q1.csv",".\\DATA\\PM25\\NUVYXY_2019Q2.csv",".\\DATA\\PM25\\NUVYXY_2019Q3.csv",".\\DATA\\PM25\\NUVYXY_2019Q4.csv"];
gwpaths=[".\\DATA\\PM25\\GW_FG_2019Q1.mat",".\\DATA\\PM25\\GW_FG_2019Q2.mat",".\\DATA\\PM25\\GW_FG_2019Q3.mat",".\\DATA\\PM25\\GW_FG_2019Q4.mat"];
agwnnpaths=[".\\DATA\\PM25\\AGWNN_2019Q1.mat",".\\DATA\\PM25\\AGWNN_2019Q2.mat",".\\DATA\\PM25\\AGWNN_2019Q3.mat",".\\DATA\\PM25\\AGWNN_2019Q4.mat"];
isNormalized=true;
epochNum=5000;
for qi=1:4
    dataNorm=ReadCsvData(dpaths(qi),12,13,5,6:10);
    gwData=load(gwpaths(qi));
    GW=gwData.GW;
    [TS,HP] = MakeAGWNNHP(dataNorm,GW);
    %启动超参数调整区
    HP.isNormalized=isNormalized;
    HP.mbNum=8;
    HP.vsRatio=0.3; %测试集比率
    HP.aLoopEpochNum=33;%可早停轮数
    
    HP.isEarlyStopping=true;%是否启用早停
    HP.patience=10;
    HP.epochNum=epochNum;
    HP.lr=0.001; %最优0.001
    HP.gw_factor=0.001;
    HP.gwlr=HP.lr*HP.gw_factor;

    tt2=tic;
    [~,~,~,~,AGWNNModel]= AGWNN(TS,HP);
    AGWNNModel.TIME=toc(tt2);
    %save(agwnnpaths(qi),'AGWNNModel');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%输出Y和YHat结果
dpaths=[".\\DATA\\PM25\\NUVYXY_2019Q1.csv",".\\DATA\\PM25\\NUVYXY_2019Q2.csv",".\\DATA\\PM25\\NUVYXY_2019Q3.csv",".\\DATA\\PM25\\NUVYXY_2019Q4.csv"];
agwnnpaths=[".\\DATA\\PM25\\AGWNN_2019Q1.mat",".\\DATA\\PM25\\AGWNN_2019Q2.mat",".\\DATA\\PM25\\AGWNN_2019Q3.mat",".\\DATA\\PM25\\AGWNN_2019Q4.mat"];
ypypaths=[".\\DATA\\PM25\\YPY_2019Q1.csv",".\\DATA\\PM25\\YPY_2019Q2.csv",".\\DATA\\PM25\\YPY_2019Q3.csv",".\\DATA\\PM25\\YPY_2019Q4.csv"];
for qi=1:4
    dataNorm=ReadCsvData(dpaths(qi),12,13,5,6:10);
    mAGWNNModel=load(agwnnpaths(qi));
    AGWNNModel=mAGWNNModel.AGWNNModel;
    titles={'Y','AGWNN_YHat'};
    vals=[dataNorm.Y,AGWNNModel.YHat'];
    %WriteCsvData(ypypaths(qi),titles,vals);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%其他模型的YHat结果已手动加入到文件中

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%输出所有模型的回归结果统计信息
dpaths=[".\\DATA\\PM25\\NUVYXY_2019Q1.csv",".\\DATA\\PM25\\NUVYXY_2019Q2.csv",".\\DATA\\PM25\\NUVYXY_2019Q3.csv",".\\DATA\\PM25\\NUVYXY_2019Q4.csv"];
ypypaths=[".\\DATA\\PM25\\YPY_2019Q1.csv",".\\DATA\\PM25\\YPY_2019Q2.csv",".\\DATA\\PM25\\YPY_2019Q3.csv",".\\DATA\\PM25\\YPY_2019Q4.csv"];
STATs=zeros(7,8);
for qi=1:4
    dataNorm=ReadCsvData(dpaths(qi),12,13,5,6:10);
    oDataNorm=ReadCsvData3(ypypaths(qi));
    X=dataNorm.X;
    Ys=oDataNorm.VARS;
    [N,M]=size(X);
    sid=(qi-1)*2;

    for mi=1:7
        mSTAT = STAT(M,N,Ys(:,1),Ys(:,mi+1));
        STATs(mi,sid+1:sid+2)=[mSTAT.RMSE,mSTAT.R2adj];
    end
end
titles={'RMSE_Q1','adjR2_Q1','RMSE_Q2','adjR2_Q2','RMSE_Q3','adjR2_Q3','RMSE_Q4','adjR2_Q4'};
%WriteCsvData(".\\DATA\\PM25\\YPY_STAT.csv",titles,STATs);

