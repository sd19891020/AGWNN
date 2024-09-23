%Coefficients surface, Betas
clc;
clear;

addpath('./Common');
ypath=".\DATA\SYN\S5.csv";

dataNorm=ReadCsvData3(ypath);
UV=dataNorm.VARS(:,5:6);
UU=UV(:,1)';
VV=UV(:,2)';
OB=dataNorm.VARS(:,7:10)';

ul=20;
vl=20;
betaMax=4;
xMax=1;
sigma2=0.25;

[~,~,outBetas,~] = SimulatedData(ul,vl,betaMax,xMax,sigma2);
vOB=var(outBetas,0,1);
txt{1}=sprintf('¦Â_%s (Var=%0.2f)',"a",vOB(1));
txt{2}=sprintf('¦Â_%s (Var=%0.2f)',"b",vOB(2));
txt{3}=sprintf('¦Â_%s (Var=%0.2f)',"c",vOB(3));
txt{4}=sprintf('¦Â_%s (Var=%0.2f)',"d",vOB(4));
xticks1=[];
yticks1=[];
xticks2=[0,5,10,15,20];
yticks2=[0,5,10,15,20];

[NBS,~]=mapminmax(OB,0,betaMax);

xNum=ul;
yNum=vl;
fig=figure(1);
srNum=2;
scNum=2;
for sr=1:srNum
    for sc=1:scNum
        index=(sr-1)*scNum+sc;
        subFig(sr,sc)=subplot(srNum,scNum,index);
        xticks=xticks1;
        yticks=yticks1;
        if index==1 || index==3
            yticks=yticks2;
        end
        if index==3 || index==4
            xticks=xticks2;
        end
        ShowSubFigureY(subFig(sr,sc),xNum,yNum,UU,VV,NBS(index,:),0,betaMax,txt{index},xticks,yticks);
    end
end


