

clc;
clear;

addpath('./Common');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%所有模型回归结果拟合散点图对比
YPYs(1)=ReadCsvData3('.\\DATA\\PM25\\YPY_2019Q1.csv');
YPYs(2)=ReadCsvData3('.\\DATA\\PM25\\YPY_2019Q2.csv');
YPYs(3)=ReadCsvData3('.\\DATA\\PM25\\YPY_2019Q3.csv');
YPYs(4)=ReadCsvData3('.\\DATA\\PM25\\YPY_2019Q4.csv');

eqs=["y=0.42x+3.82","y=0.61x+3.12","y=0.47x+3.98","y=0.39x+4.90";...
"y=0.73x+1.74","y=0.74x+2.07","y=0.77x+1.73","y=0.71x+2.34";...
"y=0.73x+1.78","y=0.73x+2.16","y=0.82x+1.38","y=0.72x+2.24";...
"y=0.90x+0.61","y=0.95x+0.43","y=0.95x+0.37","y=0.93x+0.53"];

adjr2s=["adjR2=0.42","adjR2=0.61","adjR2=0.48","adjR2=0.39";...
    "adjR2=0.77","adjR2=0.77","adjR2=0.80","adjR2=0.75";...
    "adjR2=0.75","adjR2=0.75","adjR2=0.85","adjR2=0.75";...
    "adjR2=0.89","adjR2=0.92","adjR2=0.94","adjR2=0.92"];

enps=[" "," "," "," ";...
    "ENP=85.93","ENP=97.36","ENP=114.63","ENP=96.11";...
    "ENP=85.93","ENP=97.43","ENP=114.63","ENP=97.29";...
    "ENP=85.91","ENP=97.33","ENP=114.61","ENP=96.09"];

aiccs=[" "," "," "," ";...
    "AICc=1545","AICc=1596","AICc=1832","AICc=1993";...
    "AICc=1548","AICc=1601","AICc=1732","AICc=2001";...
    "AICc=1159","AICc=1044","AICc=1223","AICc=1467"];

eqs=eqs';
adjr2s=adjr2s';
enps=enps';
aiccs=aiccs';

titleLabels=["Spring","Summer","Autumn","Winter"];
rowLabels=["ANN","GWR","MGWR","AGWNN"];
leftLabel="estimation";
bottomLabel="observation";
titleFI=[1,2,3,4];
leftFI=[1,5,9,13];
bottomFI=[13,14,15,16];
rightFI=[4,8,12,16];

xFI=1:12;
yFI=[2:4,6:8,10:12,14:16];

maxY=20;
for i=1:4
    YPYNorm=YPYs(i);
    YPY=YPYNorm.VARS(:,[1,2,3,7,8]);
    sid=1;
    mid=sid+i;
    for j=1:4
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
        outStr2=sprintf("%s\n%s",enps(ij),aiccs(ij));

        subplot(4,4,ij);
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
        text(0.5,17,outStr,'FontName','Arial','FontSize',12);hold on;
        text(8,3,outStr2,'FontName','Arial','FontSize',12);hold on;
        if ismember(ij,rightFI)
            c=colorbar();hold on;
            c.Label.FontSize = 10;
        end
        % 获取当前坐标轴
        ax = gca;
        % 设置 x 轴和 y 轴的刻度标签字体大小
        tickFontSize = 14;
        set(ax, 'XTickLabel', get(ax, 'XTickLabel'), 'FontSize', tickFontSize);
        set(ax, 'YTickLabel', get(ax, 'YTickLabel'), 'FontSize', tickFontSize);
        box on;
    end
end











