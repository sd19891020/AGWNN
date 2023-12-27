

clc;
clear;

addpath('./Common');
addpath('./MLR');
addpath('./GWR');
addpath('./AGWNN');

dataNorms(1)=ReadCsvData('.\\DATA\\NY\\ny_q1.csv',1,2,7,3:6);
dataNorms(2)=ReadCsvData('.\\DATA\\NY\\ny_q2.csv',1,2,7,3:6);
dataNorms(3)=ReadCsvData('.\\DATA\\NY\\ny_q3.csv',1,2,7,3:6);
dataNorms(4)=ReadCsvData('.\\DATA\\NY\\ny_q4.csv',1,2,7,3:6);


for i=1:4
    t='adaptive';
    f='gauss';
    dataNorm=dataNorms(i);

    GWRModel(i) = GWR(dataNorm.X',dataNorm.Y',[dataNorm.u,dataNorm.v]',0.001,t,f);
    [TS,HP] = MakeHP(dataNorm,GWRModel(i));

    %超参数具体设置
    HP.patience=13;%耐心轮数一般设为13
    HP.isNormalized=false;
    HP.vsRatio=0.3; %测试集比率
    HP.mbNum=16;

    HP.isEarlyStopping=true;%是否启用早停
    HP.epochNum=100;
    HP.aLoopEpochNum=33;%可早停轮数
    HP.lr=0.09;
    HP.gw_factor=0.01;
    HP.gwlr=HP.lr*HP.gw_factor;

    ROP_HP.enable=true;
    ROP_HP.factor=0.3;
    ROP_HP.patience=10;
    ROP_HP.threshold=13.0;%平原阈值
    ROP_HP.min_lr=0.000001;%最小学习率

    [~,~,~,~,OptimalModel(i)]= AGWNN(TS,HP,ROP_HP);

end

