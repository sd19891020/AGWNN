%Regression coefficients visualization, AGWNN vs. GWR, BetaHats
clc;
clear;

addpath('./Common');
ypath=".\DATA\SYN\S5.csv";
bhpath=".\DATA\SYN\BHS_S5.mat";

betaMax=4;

odataNorm=ReadCsvData3(ypath);
UV=odataNorm.VARS(:,5:6);
UU=UV(:,1)';
VV=UV(:,2)';
OB=odataNorm.VARS(:,7:10)';

mBHS=load(bhpath);
BHS=mBHS.BHS';

BS=[OB;BHS];
[NBS,~]=mapminmax(BS,0,betaMax);

xticks1=[];
yticks1=[];
xticks2=[0,5,10,15,20];
yticks2=[0,5,10,15,20];

xNum=20;
yNum=20;
fig=figure(1);
srNum=3;
scNum=4;
for sr=1:srNum
    txts={"¦Â_a","¦Â_b","¦Â_c","¦Â_d"};
    for sc=1:scNum
        index=(sr-1)*scNum+sc;
        subFig(sr,sc)=subplot(srNum,scNum,index);
        xticks=xticks1;
        yticks=yticks1;
        if index==1 || index==5 || index==9
            yticks=yticks2;
        end
        if index==9 || index==10 || index==11 || index==12
            xticks=xticks2;
        end
        vOB=var(NBS(index,:),0,2);
        ShowSubFigureY(subFig(sr,sc),xNum,yNum,UU,VV,NBS(index,:),0,betaMax,txts{sc},xticks,yticks);
    end
end


