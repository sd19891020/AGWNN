%Scatterplot of models estimation results
clear
close all
clc

addpath('./Common');
YPYs(1)=ReadCsvData3('.\\DATA\\PM25\\YPY_2019Q1.csv');
YPYs(2)=ReadCsvData3('.\\DATA\\PM25\\YPY_2019Q2.csv');
YPYs(3)=ReadCsvData3('.\\DATA\\PM25\\YPY_2019Q3.csv');
YPYs(4)=ReadCsvData3('.\\DATA\\PM25\\YPY_2019Q4.csv');

eqs=["y=0.31x+4.63","y=0.41x+4.70","y=0.33x+5.05","y=0.30x+5.56";...
"y=0.40x+3.92","y=0.57x+3.38","y=0.45x+4.12","y=0.40x+4.89";...
"y=0.73x+1.74","y=0.74x+2.07","y=0.77x+1.73","y=0.71x+2.34";...
"y=0.73x+1.73","y=0.78x+1.78","y=0.78x+1.70","y=0.73x+2.29";...
"y=0.90x+0.69","y=0.90x+0.78","y=0.90x+0.84","y=0.84x+1.29"];

rmses=["RMSE=1.46","RMSE=1.39","RMSE=2.04","RMSE=2.33";...
    "RMSE=1.32","RMSE=1.16","RMSE=1.81","RMSE=2.23";...
    "RMSE=0.83","RMSE=0.86","RMSE=1.10","RMSE=1.43";...
    "RMSE=0.83","RMSE=0.78","RMSE=1.08","RMSE=1.42";...
    "RMSE=0.46","RMSE=0.49","RMSE=0.72","RMSE=0.90"];

adjr2s=["adjR^2=0.30","adjR^2=0.40","adjR^2=0.32","adjR^2=0.29";...
    "adjR^2=0.41","adjR^2=0.58","adjR^2=0.47","adjR^2=0.41";...
    "adjR^2=0.77","adjR^2=0.77","adjR^2=0.80","adjR^2=0.75";...
    "adjR^2=0.77","adjR^2=0.81","adjR^2=0.81","adjR^2=0.76";...
    "adjR^2=0.91","adjR^2=0.92","adjR^2=0.91","adjR^2=0.90"];

eqs=eqs';
rmses=rmses';
adjr2s=adjr2s';

titleLabels=["Spring","Summer","Autumn","Winter"];
rowLabels=["MLR","ANN","GWR","GWANN","AGWNN"];
leftLabel="estimation";
bottomLabel="observation";
titleFI=[1,2,3,4];
leftFI=[1,5,9,13,17];
bottomFI=[17,18,19,20];
rightFI=4;

xFI=1:16;
yFI=[2:4,6:8,10:12,14:16,18:20];

maxY=20;
for i=1:5
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
        
        outStr=sprintf("%s\n%s",eqs(ij),adjr2s(ij));
        outStr2=sprintf("%s",rmses(ij));

        subplot(5,4,ij);
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
        text(0.6,16.3,outStr,'FontName','Arial','FontSize',11);hold on;
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











