

clc;
clear;

addpath('./Common');
addpath('./AGWNN');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%四个季度，局部回归系数诊断
dpaths=[".\\DATA\\PM25\\NUVYXY_2019Q1.csv",".\\DATA\\PM25\\NUVYXY_2019Q2.csv",".\\DATA\\PM25\\NUVYXY_2019Q3.csv",".\\DATA\\PM25\\NUVYXY_2019Q4.csv"];
agwnnpaths=[".\\DATA\\PM25\\AGWNN_2019Q1.mat",".\\DATA\\PM25\\AGWNN_2019Q2.mat",".\\DATA\\PM25\\AGWNN_2019Q3.mat",".\\DATA\\PM25\\AGWNN_2019Q4.mat"];
for qi=1:4
    dataNorm=ReadCsvData(dpaths(qi),12,13,5,6:10);
    mAGWNNModel=load(agwnnpaths(qi));
    AGWNNModel=mAGWNNModel.AGWNNModel;
    [AGWNNModel.AICc,AGWNNModel.ENP,AGWNNModel.DoD,AGWNNModel.DoD2,AGWNNModel.SE,AGWNNModel.DF,AGWNNModel.TV,AGWNNModel.PV]=DX(dataNorm.X',dataNorm.Y',AGWNNModel.YHat,AGWNNModel.BetaHat',(AGWNNModel.GW.*AGWNNModel.fgw),true);
    
    P=dataNorm.xNum+1;
    PE(qi)=P/AGWNNModel.DoD;
    alpha(qi)=AGWNNModel.DoD*0.05;
    alpha2(qi)=AGWNNModel.DoD2*0.05;
    for jj=1:6
        [num,~]=size(find(AGWNNModel.PV(:,jj)<=alpha(qi)));
        [num2,~]=size(find(AGWNNModel.PV(:,jj)<=alpha2(qi)));
        per(jj)=num/double(dataNorm.n);
        per2(jj)=num2/double(dataNorm.n);
        mean_beta(jj)=mean(AGWNNModel.BetaHat(:,jj)); 
        mean_tv(jj)=mean(AGWNNModel.TV(:,jj));
        mean_pv(jj)=mean(AGWNNModel.PV(:,jj));
        ssiidd=(jj-1)*5+1;
        vals(qi,ssiidd:ssiidd+4)=[mean_beta(jj),mean_tv(jj),mean_pv(jj),per(jj),per2(jj)];
    end
end

titles={'mean_b0','mean_t0','mean_p0','mean_f0','mean_f20',...
        'mean_b1','mean_t1','mean_p1','mean_f1','mean_f21',...
        'mean_b2','mean_t2','mean_p2','mean_f2','mean_f22',...
        'mean_b3','mean_t3','mean_p3','mean_f3','mean_f23',...
        'mean_b4','mean_t4','mean_p4','mean_f4','mean_f24',...
        'mean_b5','mean_t5','mean_p5','mean_f5','mean_f25'};
%WriteCsvData(".\\DATA\\PM25\\CE_STAT.csv",titles,vals);




