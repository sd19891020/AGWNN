

clc;
clear;

%%%%%%%%%%%%%%%实验1.1 AICc指标的可用性验证
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%400样本，非正则化，获取GWR-FG的空间权重GW并生成神经网络超参数，AGWNN
addpath('./Common');
addpath('./AGWNN');
dmpath=".\\DATA\\SYN\\s400.mat"; %合成样本数据矩阵
gwpath=".\\DATA\\SYN\\GW_FG.mat"; %GWR-FW计算得到的空间权重矩阵
dData=load(dmpath);
dataNorm=dData.dataNorm;
gwData=load(gwpath);
GW=gwData.GW;

%超参数具体设置
[TS,HP] = MakeAGWNNHP(dataNorm,GW);
HP.patience=13;%耐心轮数一般设为13
HP.isNormalized=false;
HP.vsRatio=0.3; %测试集比率
HP.mbNum=16;
HP.isEarlyStopping=false;%是否启用早停（测试AICc指标，不需要启动早停策略）
HP.epochNum=400;
HP.aLoopEpochNum=33;%可早停轮数

lrs=[0.003,0.009,0.03,0.09];
for lri=1:4
    HP.lr=lrs(lri);
    HP.gw_factor=0.01;
    HP.gwlr=HP.lr*HP.gw_factor;
    [TrainStat(lri),TestStat(lri),FullStat(lri),~,~]= AGWNN(TS,HP);
end   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%绘图部分

colors(1,:)=[252 141 98]/255; %adjR2
colors(2,:)=[231 138 195]/255; %粉红 LOSS
colors(3,:)=[166 216 84]/255; %RMSE
colors(4,:)=[102 194 165]/255; %绿色 AICc_all
colors(5,:)=[141 160 203]/255; %蓝紫 AICc_test
colors(6,:)=[255 217 47]/255; %橙黄 AICc_train

ls='-';
lw=1.6;

ff=figure('Color',[1 1 1]);
set(ff,'defaultAxesColorOrder',colors);

strs=["lr=0.003","lr=0.009","lr=0.03","lr=0.09",...
        "","","","",...
        "","","","",...
        "","","","",...
    "lr=0.003","lr=0.009","lr=0.03","lr=0.09"];

xts=[{' ',' ',' '};{' ',' ',' '};{' ',' ',' '};{' ',' ',' '};...
    {' ',' ',' '};{' ',' ',' '};{' ',' ',' '};{' ',' ',' '};...
    {'0','200','400'};{'0','200','400'};{'0','200','400'};{'0','200','400'};...
    {' ',' ',' '};{' ',' ',' '};{' ',' ',' '};{' ',' ',' '};...
    {'0','200','400'};{'0','200','400'};{'0','200','400'};{'0','200','400'}];

yts1=[[0,150,300];[0,150,300];[0,150,300];[0,150,300];...
    [0,0.5,1];[0,0.5,1];[0,0.5,1];[0,0.5,1];...
    [0,2000,4000];[0,2000,4000];[0,2000,4000];[0,2000,4000];...
    [0,2000,4000];[0,2000,4000];[0,2000,4000];[0,2000,4000];...
    [0,2000,4000];[0,2000,4000];[0,2000,4000];[0,2000,4000]];

ytls1=[{'0','150','300'};{' ',' ',' '};{' ',' ',' '};{' ',' ',' '};...
    {'0','0.5','1'};{' ',' ',' '};{' ',' ',' '};{' ',' ',' '};...
    {'0','2000','4000'};{' ',' ',' '};{' ',' ',' '};{' ',' ',' '};...
    {' ',' ',' '};{' ',' ',' '};{' ',' ',' '};{' ',' ',' '};...
    {'0','2000','4000'};{' ',' ',' '};{' ',' ',' '};{' ',' ',' '}];
yts2=[[0,0.5,1];[0,0.5,1];[0,0.5,1];[0,0.5,1];...
    [0,0.5,1];[0,0.5,1];[0,0.5,1];[0,0.5,1];...
    [0,0.5,1];[0,0.5,1];[0,0.5,1];[0,0.5,1];...
    [0,0.5,1];[0,0.5,1];[0,0.5,1];[0,0.5,1];...
    [0,0.5,1];[0,0.5,1];[0,0.5,1];[0,0.5,1]];
ytls2=[{' ',' ',' '};{' ',' ',' '};{' ',' ',' '};{'0','0.5','1'};...
    {' ',' ',' '};{' ',' ',' '};{' ',' ',' '};{'0','0.5','1'};...
    {' ',' ',' '};{' ',' ',' '};{' ',' ',' '};{'0','0.5','1'};...
    {' ',' ',' '};{' ',' ',' '};{' ',' ',' '};{' ',' ',' '};...
    {' ',' ',' '};{' ',' ',' '};{' ',' ',' '};{'0','0.5','1'}];

yls1=["LOSS","","","",...
        "RMSE","","","",...
        "AICc","","","",...
        "","","","",...
    "AICc","","",""];

for lri=1:4
    subplot(5,4,lri);
    title(strs(lri),'FontName','Arial','FontSize',14);hold on;
    yyaxis left;plot(FullStat(lri).loss_history',ls,'LineWidth',lw,'Color',colors(2,:));ylim([-30,300]);set(gca,'YColor','k');yticks(yts1(lri,:));yticklabels(ytls1(lri,:));ylabel(yls1(lri),'FontName','Arial','FontSize',14);
    yyaxis right;plot(FullStat(lri).r2adj_history',ls,'LineWidth',lw,'Color',colors(1,:));ylim([0,1.1]);set(gca,'YColor','k');yticks(yts2(lri,:));yticklabels(ytls2(lri,:));
    xticklabels(xts(lri,:));
    box on;hold on;

    subplot(5,4,lri+4);
    title(strs(lri+4),'FontName','Arial','FontSize',14);hold on;
    yyaxis left;plot(FullStat(lri).rmse_history',ls,'LineWidth',lw,'Color',colors(3,:));ylim([0,1]);set(gca,'YColor','k');yticks(yts1(lri+4,:));yticklabels(ytls1(lri+4,:));ylabel(yls1(lri+4),'FontName','Arial','FontSize',14);
    yyaxis right;plot(FullStat(lri).r2adj_history',ls,'LineWidth',lw,'Color',colors(1,:));ylim([0,1.1]);set(gca,'YColor','k');yticks(yts2(lri+4,:));yticklabels(ytls2(lri+4,:));
    xticklabels(xts(lri+4,:));
    box on;hold on;

    subplot(5,4,lri+8);
    title(strs(lri+8),'FontName','Arial','FontSize',14);hold on;
    yyaxis left;plot(FullStat(lri).aicc_history',ls,'LineWidth',lw,'Color',colors(4,:));ylim([-500,4000]);set(gca,'YColor','k');yticks(yts1(lri+8,:));yticklabels(ytls1(lri+8,:));ylabel(yls1(lri+8),'FontName','Arial','FontSize',14);
    yyaxis right;plot(FullStat(lri).r2adj_history',ls,'LineWidth',lw,'Color',colors(1,:));ylim([0,1.1]);set(gca,'YColor','k');yticks(yts2(lri+8,:));yticklabels(ytls2(lri+8,:));
    xticklabels(xts(lri+8,:));
    box on;hold on;
end

for lri=1:4
    subplot(5,4,lri+16);
    title(strs(lri+16),'FontName','Arial','FontSize',14);hold on;
    yyaxis left;
    plot(TrainStat(lri).aicc_history',ls,'LineWidth',lw,'Color',colors(6,:));hold on; 
    plot(TestStat(lri).aicc_history',ls,'LineWidth',lw,'Color',colors(5,:));hold on; 
    plot(FullStat(lri).aicc_history',ls,'LineWidth',lw,'Color',colors(4,:)); 
    ylim([-500,4000]);yticks(yts1(lri+16,:));yticklabels(ytls1(lri+16,:));set(gca,'YColor','k');
    ylabel(yls1(lri+16),'FontName','Arial','FontSize',14);
    yyaxis right;
    plot(FullStat(lri).r2adj_history',ls,'LineWidth',lw,'Color',colors(1,:)); 
    ylim([0,1.1]);yticks(yts2(lri+16,:));yticklabels(ytls2(lri+16,:));set(gca,'YColor','k');
    xticklabels(xts(lri+16,:));
    box on;hold on;
end
%设置画布的大小以及在屏幕中间 位置
set(gca,'FontName','Arial');







