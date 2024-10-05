%Statistics of models estimation results
clear
close all
clc

dpaths=[".\\DATA\\PM25\\NUVYXY_2019Q1.csv",".\\DATA\\PM25\\NUVYXY_2019Q2.csv",".\\DATA\\PM25\\NUVYXY_2019Q3.csv",".\\DATA\\PM25\\NUVYXY_2019Q4.csv"];
agwnnnrpaths=[".\\DATA\\PM25\\AGWNN_NR_2019Q1.mat",".\\DATA\\PM25\\AGWNN_NR_2019Q2.mat",".\\DATA\\PM25\\AGWNN_NR_2019Q3.mat",".\\DATA\\PM25\\AGWNN_NR_2019Q4.mat"];
ypypaths=[".\\DATA\\PM25\\YPY_2019Q1.csv",".\\DATA\\PM25\\YPY_2019Q2.csv",".\\DATA\\PM25\\YPY_2019Q3.csv",".\\DATA\\PM25\\YPY_2019Q4.csv"];
for qi=1:4
    dataNorm=ReadCsvData(dpaths(qi),12,13,5,6:10);
    mAGWNNNRModel=load(agwnnnrpaths(qi));
    AGWNNNRModel=mAGWNNNRModel.AGWNNModel;
    titles={'Y','AGWNN_YHat'};
    vals=[dataNorm.Y,AGWNNNRModel.YHat'];
    %WriteCsvData(ypypaths(qi),titles,vals);
end
%YHat results for other models have been manually added to the file


dpaths=[".\\DATA\\PM25\\NUVYXY_2019Q1.csv",".\\DATA\\PM25\\NUVYXY_2019Q2.csv",".\\DATA\\PM25\\NUVYXY_2019Q3.csv",".\\DATA\\PM25\\NUVYXY_2019Q4.csv"];
ypypaths=[".\\DATA\\PM25\\YPY_2019Q1.csv",".\\DATA\\PM25\\YPY_2019Q2.csv",".\\DATA\\PM25\\YPY_2019Q3.csv",".\\DATA\\PM25\\YPY_2019Q4.csv"];
modelNum=6;
STATs=zeros(modelNum,8);
for qi=1:4
    dataNorm=ReadCsvData(dpaths(qi),12,13,5,6:10);
    oDataNorm=ReadCsvData3(ypypaths(qi));
    X=dataNorm.X;
    Ys=oDataNorm.VARS;
    [N,M]=size(X);
    sid=(qi-1)*2;

    for mi=1:modelNum
        mSTAT = STAT(M,N,Ys(:,1),Ys(:,mi+1));
        STATs(mi,sid+1:sid+2)=[mSTAT.RMSE,mSTAT.R2adj];
    end
end
titles={'RMSE_Q1','adjR2_Q1','RMSE_Q2','adjR2_Q2','RMSE_Q3','adjR2_Q3','RMSE_Q4','adjR2_Q4'};
%WriteCsvData(".\\DATA\\PM25\\YPY_STATX.csv",titles,STATs);


