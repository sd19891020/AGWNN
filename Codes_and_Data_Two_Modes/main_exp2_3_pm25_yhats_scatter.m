%Scatterplot of models estimation results
clear
close all
clc

addpath('./Common');
YPYs(1)=ReadCsvData3('.\\DATA\\PM25\\YPY_2019Q1.csv');
YPYs(2)=ReadCsvData3('.\\DATA\\PM25\\YPY_2019Q2.csv');
YPYs(3)=ReadCsvData3('.\\DATA\\PM25\\YPY_2019Q3.csv');
YPYs(4)=ReadCsvData3('.\\DATA\\PM25\\YPY_2019Q4.csv');

modelNum=6;
for j=1:4
    YPYNorm=YPYs(j);
    YPY=YPYNorm.VARS;
    nn=YPYNorm.n;
    sid=1;
    for i=1:modelNum
        mid=sid+i;
        OLR = polyfit(YPY(:,sid),YPY(:,mid),1);
        olrStrs(i,j)=sprintf("y=%0.2fx+%0.2f",OLR(1),OLR(2));
        mstat=STAT(5,nn,YPY(:,sid),YPY(:,mid));
        RMSEStrs(i,j)=sprintf("RMSE=%0.2f",mstat.RMSE);
        R2adjStrs(i,j)=sprintf("adjR^2=%0.2f",mstat.R2adj);
    end
end

eqs=olrStrs;
adjr2s=R2adjStrs;
rmses=RMSEStrs;

titleLabels=["Spring","Summer","Autumn","Winter"];
rowLabels=["MLR","ANN","GWR","GWANN","GNNWR","AGWNN"];
leftLabel="estimation";
bottomLabel="observation";
titleFI=[1,2,3,4];
leftFI=[1,5,9,13,17,21];
bottomFI=[21,22,23,24];
rightFI=4;

xFI=1:16;
yFI=[2:4,6:8,10:12,14:16,18:20];

maxY=20;
for i=1:modelNum
    sid=1;
    mid=sid+i;
    for j=1:4
        YPYNorm=YPYs(j);
        YPY=YPYNorm.VARS(:,:);
        Y=YPY(:,sid);
        YHat=YPY(:,mid);
        m=0:maxY/2:maxY;n=m;
        sz = 15;
        c = linspace(0,maxY,length(Y));

        yP=polyfit(Y,YHat,1);
        yFit=polyval(yP,Y);
        yEnd=polyval(yP,maxY);
        XX=[Y;maxY];
        YY=[yFit;yEnd];
        
        ij=(i-1)*4+j;
        
        outStr=sprintf("%s\n%s",eqs(i,j),adjr2s(i,j));
        outStr2=sprintf("%s",rmses(i,j));

        subplot(6,4,ij);
        if ismember(ij,titleFI)
            title(titleLabels(ij),'FontName','Arial','FontSize',14);hold on;
        end
        plot(m,n,'k:','LineWidth', 0.5);hold on;
        plot(XX,YY,'k-','LineWidth', 0.5);hold on;
        scatter(Y,YHat,sz,c,'filled');xlim([0,maxY]);ylim([0,maxY]);
        if ismember(ij,xFI)
            xticklabels({});hold on;
        end
        if ismember(ij,yFI)
            yticklabels({});hold on;
        end
        if ismember(ij,leftFI)
            lStr=sprintf("%s\n%s",rowLabels(i),leftLabel);
            ylabel(lStr,'FontName','Arial','FontSize',14);hold on;
        end
        if ismember(ij,bottomFI)
            xlabel(bottomLabel,'FontName','Arial','FontSize',14);hold on;
        end
        text(0.6,15.3,outStr,'FontName','Arial','FontSize',11);hold on;
        text(9.6,2.3,outStr2,'FontName','Arial','FontSize',11);hold on;
        if ismember(ij,rightFI)
            c=colorbar();hold on;
            c.Label.FontSize = 10;
        end

        ax = gca;
        tickFontSize = 14;
        set(ax, 'XTickLabel', get(ax, 'XTickLabel'), 'FontSize', tickFontSize);
        set(ax, 'YTickLabel', get(ax, 'YTickLabel'), 'FontSize', tickFontSize);
        box on;
    end
end











