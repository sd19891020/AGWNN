%Outputing regression statistics results, AGWNN vs. PM2.5, YHat
clear
close all
clc

addpath('./Common');
dpaths=[".\\DATA\\PM25\\NUVYXY_2019Q1.csv",".\\DATA\\PM25\\NUVYXY_2019Q2.csv",".\\DATA\\PM25\\NUVYXY_2019Q3.csv",".\\DATA\\PM25\\NUVYXY_2019Q4.csv"];
agwnnnrpaths=[".\\DATA\\PM25\\AGWNN_NR_2019Q1.mat",".\\DATA\\PM25\\AGWNN_NR_2019Q2.mat",".\\DATA\\PM25\\AGWNN_NR_2019Q3.mat",".\\DATA\\PM25\\AGWNN_NR_2019Q4.mat"];
stats=zeros(4,6);
for qi=1:4
    dataNorm=ReadCsvData(dpaths(qi),12,13,5,6:10);
    mAGWNNNRModel=load(agwnnnrpaths(qi));
    AGWNNNRModel=mAGWNNNRModel.AGWNNModel;
    YY=dataNorm.Y;
    YYHH=AGWNNNRModel.YHat';
    stats(qi,1)=min(YY);
    stats(qi,2)=mean(YY);
    stats(qi,3)=max(YY);
    stats(qi,4)=min(YYHH);
    stats(qi,5)=mean(YYHH);
    stats(qi,6)=max(YYHH);
end
titles={'min','mean','max','min2','mean2','max2'};
%WriteCsvData(".\\DATA\\PM25\\NUVYPY_STAT.csv",titles,stats);

