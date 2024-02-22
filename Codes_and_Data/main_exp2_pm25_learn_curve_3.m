

clear
close all
clc

addpath('./Common');
addpath('./AGWNN');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�ĸ�����ѵ��,���򻯣�AGWNN
dpaths=[".\\DATA\\PM25\\NUVYXY_2019Q1.csv",".\\DATA\\PM25\\NUVYXY_2019Q2.csv",".\\DATA\\PM25\\NUVYXY_2019Q3.csv",".\\DATA\\PM25\\NUVYXY_2019Q4.csv"];
gwpaths=[".\\DATA\\PM25\\GW_FG_2019Q1.mat",".\\DATA\\PM25\\GW_FG_2019Q2.mat",".\\DATA\\PM25\\GW_FG_2019Q3.mat",".\\DATA\\PM25\\GW_FG_2019Q4.mat"];
isNormalized=true;
epochNum=5000;
LOSSes=zeros(epochNum,8);
for qi=1:4
    dataNorm=ReadCsvData(dpaths(qi),12,13,5,6:10);
    gwData=load(gwpaths(qi));
    GW=gwData.GW;
    [TS,HP] = MakeAGWNNHP(dataNorm,GW);
    %����������������
    HP.isNormalized=isNormalized;
    HP.mbNum=8;
    HP.vsRatio=0.3; %���Լ�����
    HP.aLoopEpochNum=33;%����ͣ����
    HP.isEarlyStopping=false;%�Ƿ�������ͣ������ѧϰ���ߣ�����Ҫ������ͣ���ԣ�
    HP.patience=10;
    HP.epochNum=epochNum;
    HP.lr=0.001; %����0.001
    HP.gw_factor=0.0001;
    HP.gwlr=HP.lr*HP.gw_factor;
    [~,~,AGWNN_FullStat,~,~]= AGWNN(TS,HP);
    LOSSes(:,qi)=AGWNN_FullStat.loss_history';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���LOSS��¼
titles={'AGWNN_Q1','AGWNN_Q2','AGWNN_Q3','AGWNN_Q4'};
%WriteCsvData(".\\DATA\\PM25\\LOSS.csv",titles,LOSSes);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ANNģ�͵�LOSS��¼���ֶ����뵽�ļ���
dataNorm=ReadCsvData3(".\\DATA\\PM25\\LOSS.csv");
LOSSs=dataNorm.VARS;
n=dataNorm.n;
figure('Color',[1 1 1]);
color(1,:)=[0 0 255]/255;
color(2,:)=color(1,:);
color(3,:)=color(1,:);
color(4,:)=color(1,:);
color(5,:)=[255 0 0]/255;
color(6,:)=color(5,:);
color(7,:)=color(5,:);
color(8,:)=color(5,:);
titleLabels=["Spring","Summer","Autumn","Winter"];
for i = 1:4
    subplot(1,8,i);
    title(titleLabels(i),'FontName','Arial','FontSize',14);hold on;
    plot(LOSSs(:,i),1:n,'color',color(i,:),'LineWidth',3);xlim([-400,1600]);ylim([-100,5100]);hold on;
    % ��ȡ��ǰ������
    ax = gca;
    % ���� x ��� y ��Ŀ̶ȱ�ǩ�����С
    tickFontSize = 14;
    set(ax, 'XTickLabel', get(ax, 'XTickLabel'), 'FontSize', tickFontSize);
    set(ax, 'YTickLabel', get(ax, 'YTickLabel'), 'FontSize', tickFontSize);
    set(ax,'XDir','reverse');
    box on;
end
for i = 5:8
    subplot(1,8,i);
    title(titleLabels(i-4),'FontName','Arial','FontSize',14);hold on;
    plot(LOSSs(:,i),1:n,'color',color(i,:),'LineWidth',3);xlim([-400,1600]);ylim([-100,5100]);hold on;
    % ��ȡ��ǰ������
    ax = gca;
    % ���� x ��� y ��Ŀ̶ȱ�ǩ�����С
    tickFontSize = 14;
    set(ax, 'XTickLabel', get(ax, 'XTickLabel'), 'FontSize', tickFontSize);
    set(ax, 'YTickLabel', get(ax, 'YTickLabel'), 'FontSize', tickFontSize);
    set(ax,'XDir','reverse');
    box on;
end



