

clc;
clear;


addpath('./Common');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����������ꡢƽ�����ꡢY��YHat��BetaHat���
dpaths=[".\\DATA\\PM25\\NUVYXY_2019Q1.csv",".\\DATA\\PM25\\NUVYXY_2019Q2.csv",".\\DATA\\PM25\\NUVYXY_2019Q3.csv",".\\DATA\\PM25\\NUVYXY_2019Q4.csv"];
agwnnpaths=[".\\DATA\\PM25\\AGWNN_2019Q1.mat",".\\DATA\\PM25\\AGWNN_2019Q2.mat",".\\DATA\\PM25\\AGWNN_2019Q3.mat",".\\DATA\\PM25\\AGWNN_2019Q4.mat"];
ypypaths=[".\\DATA\\PM25\\UVYPYBETA_2019Q1.csv",".\\DATA\\PM25\\UVYPYBETA_2019Q2.csv",".\\DATA\\PM25\\UVYPYBETA_2019Q3.csv",".\\DATA\\PM25\\UVYPYBETA_2019Q4.csv"];
for qi=1:4
    oDataNorm=ReadCsvData3(dpaths(qi));%��ȡԭʼ���ݣ��������ֶΣ�2��3��Ϊ����γ������
    dataNorm=ReadCsvData(dpaths(qi),12,13,5,6:10);
    mAGWNNModel=load(agwnnpaths(qi));
    AGWNNModel=mAGWNNModel.AGWNNModel;
    titles={'LON','LAT','U','V','Y','AGWNN_YH','AGWNN_BH0','AGWNN_BH1','AGWNN_BH2','AGWNN_BH3','AGWNN_BH4','AGWNN_BH5'};
    vals=[oDataNorm.VARS(:,2:3),dataNorm.u,dataNorm.v,dataNorm.Y,AGWNNModel.YHat',AGWNNModel.BetaHat];
    %WriteCsvData(ypypaths(qi),titles,vals);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%GWR-FGģ�͵�YHat��BetaHat������ֶ����뵽�ļ���
