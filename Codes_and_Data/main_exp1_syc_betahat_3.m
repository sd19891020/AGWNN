



clc;
clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%原始Beta，GWR与AGWNN BetaHat，还原度比较
xNum=20;
yNum=20;

bspath=".\\DATA\\SYN\\BBHUV.csv";
BSData=ReadCsvData3(bspath);
BS=BSData.VARS;

UV=BS(:,25:26)';
UU=UV(1,:);
VV=UV(2,:);
fig=figure(1);

srNum=6;
scNum=8;
for sr=1:srNum
    for sc=1:(scNum/2)
        index=(sr-1)*scNum/2+sc;
        realSId=(index-1)*2+1;
        subFig(1,index)=subplot(srNum,scNum,realSId);
        subFig(2,index)=subplot(srNum,scNum,realSId+1);
    end
end

origin_Betas=BS(:,1:4);
origin_beta0=origin_Betas(:,1)';
origin_beta1=origin_Betas(:,2)';
origin_beta2=origin_Betas(:,3)';
origin_beta3=origin_Betas(:,4)';
ShowSubFigure(subFig(1,1),subFig(2,1),xNum,yNum,UU,VV,origin_beta0,'origin_beta0');
ShowSubFigure(subFig(1,2),subFig(2,2),xNum,yNum,UU,VV,origin_beta1,'origin_beta1');
ShowSubFigure(subFig(1,3),subFig(2,3),xNum,yNum,UU,VV,origin_beta2,'origin_beta2');
ShowSubFigure(subFig(1,4),subFig(2,4),xNum,yNum,UU,VV,origin_beta3,'origin_beta3');

sNum=5;
for gwrid=1:4
    gsid=gwrid*4;
    GWR_Betas=BS(:,gsid+1:gsid+4);
    gwr_beta0=GWR_Betas(:,1)';
    gwr_beta1=GWR_Betas(:,2)';
    gwr_beta2=GWR_Betas(:,3)';
    gwr_beta3=GWR_Betas(:,4)';
    sId=(gwrid-1)*4+sNum;
    ShowSubFigure(subFig(1,sId),subFig(2,sId),xNum,yNum,UU,VV,gwr_beta0,'gwr_beta0');
    ShowSubFigure(subFig(1,sId+1),subFig(2,sId+1),xNum,yNum,UU,VV,gwr_beta1,'gwr_beta1');
    ShowSubFigure(subFig(1,sId+2),subFig(2,sId+2),xNum,yNum,UU,VV,gwr_beta2,'gwr_beta2');
    ShowSubFigure(subFig(1,sId+3),subFig(2,sId+3),xNum,yNum,UU,VV,gwr_beta3,'gwr_beta3');
end

sNum=21;
asid=5*4;
compute_Betas=BS(:,asid+1:asid+4);
compute_beta0=compute_Betas(:,1)';
compute_beta1=compute_Betas(:,2)';
compute_beta2=compute_Betas(:,3)';
compute_beta3=compute_Betas(:,4)';
sId=sNum;
ShowSubFigure(subFig(1,sId),subFig(2,sId),xNum,yNum,UU,VV,compute_beta0,'agwnn_beta0');
ShowSubFigure(subFig(1,sId+1),subFig(2,sId+1),xNum,yNum,UU,VV,compute_beta1,'agwnn_beta1');
ShowSubFigure(subFig(1,sId+2),subFig(2,sId+2),xNum,yNum,UU,VV,compute_beta2,'agwnn_beta2');
ShowSubFigure(subFig(1,sId+3),subFig(2,sId+3),xNum,yNum,UU,VV,compute_beta3,'agwnn_beta3');







