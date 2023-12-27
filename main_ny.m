

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

    %��������������
    HP.patience=13;%��������һ����Ϊ13
    HP.isNormalized=false;
    HP.vsRatio=0.3; %���Լ�����
    HP.mbNum=16;

    HP.isEarlyStopping=true;%�Ƿ�������ͣ
    HP.epochNum=100;
    HP.aLoopEpochNum=33;%����ͣ����
    HP.lr=0.09;
    HP.gw_factor=0.01;
    HP.gwlr=HP.lr*HP.gw_factor;

    ROP_HP.enable=true;
    ROP_HP.factor=0.3;
    ROP_HP.patience=10;
    ROP_HP.threshold=13.0;%ƽԭ��ֵ
    ROP_HP.min_lr=0.000001;%��Сѧϰ��

    [~,~,~,~,OptimalModel(i)]= AGWNN(TS,HP,ROP_HP);

end

