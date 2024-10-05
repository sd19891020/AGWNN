%Estimation surfaces of models, yhats
clc;
clear;

addpath('./Common');
ypaths={".\DATA\SYN\S1.csv",".\DATA\SYN\S2.csv",".\DATA\SYN\S3.csv",".\DATA\SYN\S4.csv"};
yyhpaths={".\DATA\SYN\YYH_S1.csv",".\DATA\SYN\YYH_S2.csv",".\DATA\SYN\YYH_S3.csv",".\DATA\SYN\YYH_S4.csv"};

RMSEMax=1.0;
xNum=20;
yNum=20;
fig=figure(1);
srNum=4;
scNum=6;
for sr=1:srNum
    for sc=1:scNum
        index=(sr-1)*scNum+sc;
        subFig(sr,sc)=subplot(srNum,scNum,index);
    end
end


for yi=1:4
    dataNorm=ReadCsvData(ypaths{yi},4,5,3,[1,2]);
    yyhDataNorm=ReadCsvData3(yyhpaths{yi});
    YYH=yyhDataNorm.VARS;
    Y=YYH(:,1);
    YHs=YYH(:,2:end);
    
    [MLR_LSTAT] = LOCALSTAT(dataNorm.xNum,dataNorm.n,dataNorm.Y,YHs(:,1));
    [ANN_LSTAT] = LOCALSTAT(dataNorm.xNum,dataNorm.n,dataNorm.Y,YHs(:,2));
    [GWR_LSTAT] = LOCALSTAT(dataNorm.xNum,dataNorm.n,dataNorm.Y,YHs(:,3));
    [GWANN_LSTAT] = LOCALSTAT(dataNorm.xNum,dataNorm.n,dataNorm.Y,YHs(:,4));
    [GNNWR_LSTAT] = LOCALSTAT(dataNorm.xNum,dataNorm.n,dataNorm.Y,YHs(:,5));
    [AGWNN_LSTAT] = LOCALSTAT(dataNorm.xNum,dataNorm.n,dataNorm.Y,YHs(:,6));
    [AGWNN_NR_LSTAT] = LOCALSTAT(dataNorm.xNum,dataNorm.n,dataNorm.Y,YHs(:,7));
    
    txt1=sprintf('RMSE=%0.3f',MLR_LSTAT.GSTAT.RMSE);
    txt2=sprintf('RMSE=%0.3f',ANN_LSTAT.GSTAT.RMSE);
    txt3=sprintf('RMSE=%0.3f',GWR_LSTAT.GSTAT.RMSE);
    txt4=sprintf('RMSE=%0.3f',GWANN_LSTAT.GSTAT.RMSE);
    txt5=sprintf('RMSE=%0.3f',GNNWR_LSTAT.GSTAT.RMSE);
    if yi<3
        txt6=sprintf('RMSE=%0.3f',AGWNN_LSTAT.GSTAT.RMSE);
    else
        txt6=sprintf('RMSE=%0.3f',AGWNN_NR_LSTAT.GSTAT.RMSE);
    end
    
    UV=[dataNorm.u,dataNorm.v];
    UU=UV(:,1)';
    VV=UV(:,2)';
    xticks1=[];
    yticks1=[];
    xticks2=[0,5,10,15,20];
    yticks2=[0,5,10,15,20];
    if yi<4
        ShowSubFigureY(subFig(yi,1),xNum,yNum,UU,VV,MLR_LSTAT.RMSE',0.0,RMSEMax,txt1,xticks1,yticks2);
        ShowSubFigureY(subFig(yi,2),xNum,yNum,UU,VV,ANN_LSTAT.RMSE',0.0,RMSEMax,txt2,xticks1,yticks1);
        ShowSubFigureY(subFig(yi,3),xNum,yNum,UU,VV,GWR_LSTAT.RMSE',0.0,RMSEMax,txt3,xticks1,yticks1);
        ShowSubFigureY(subFig(yi,4),xNum,yNum,UU,VV,GWANN_LSTAT.RMSE',0.0,RMSEMax,txt4,xticks1,yticks1);
        ShowSubFigureY(subFig(yi,5),xNum,yNum,UU,VV,GNNWR_LSTAT.RMSE',0.0,RMSEMax,txt5,xticks1,yticks1);
        if yi<3
            ShowSubFigureY(subFig(yi,6),xNum,yNum,UU,VV,AGWNN_LSTAT.RMSE',0.0,RMSEMax,txt6,xticks1,yticks1);
        else
            ShowSubFigureY(subFig(yi,6),xNum,yNum,UU,VV,AGWNN_NR_LSTAT.RMSE',0.0,RMSEMax,txt6,xticks1,yticks1);
        end
    else
        ShowSubFigureY(subFig(yi,1),xNum,yNum,UU,VV,MLR_LSTAT.RMSE',0.0,RMSEMax,txt1,xticks2,yticks2);
        ShowSubFigureY(subFig(yi,2),xNum,yNum,UU,VV,ANN_LSTAT.RMSE',0.0,RMSEMax,txt2,xticks2,yticks1);
        ShowSubFigureY(subFig(yi,3),xNum,yNum,UU,VV,GWR_LSTAT.RMSE',0.0,RMSEMax,txt3,xticks2,yticks1);
        ShowSubFigureY(subFig(yi,4),xNum,yNum,UU,VV,GWANN_LSTAT.RMSE',0.0,RMSEMax,txt4,xticks2,yticks1);
        ShowSubFigureY(subFig(yi,5),xNum,yNum,UU,VV,GNNWR_LSTAT.RMSE',0.0,RMSEMax,txt5,xticks2,yticks1);
        ShowSubFigureY(subFig(yi,6),xNum,yNum,UU,VV,AGWNN_NR_LSTAT.RMSE',0.0,RMSEMax,txt6,xticks2,yticks1);
    end
end




