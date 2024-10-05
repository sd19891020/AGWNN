%Generating simulated datasets
clc;
clear;

addpath('./Common');
ypaths={".\DATA\SYN\S1.csv",".\DATA\SYN\S2.csv",".\DATA\SYN\S3.csv",".\DATA\SYN\S4.csv"};
ypath5=".\DATA\SYN\S5.csv";
ul=20;
vl=20;
betaMax=4;
xMax=1;
sigma2=0.25;

[outX,outUV,outBetas] = SimulatedData(ul,vl,betaMax,xMax,sigma2);
outBeta{1}=outBetas(:,[1,2,3]);%Linear & Low variance
outY{1}=outBetas(:,1)+outBetas(:,2).*outX(:,1)+outBetas(:,3).*outX(:,2);
outBeta{2}=outBetas(:,[1,2,4]);%Linear & High variance
outY{2}=outBetas(:,1)+outBetas(:,2).*outX(:,1)+outBetas(:,4).*outX(:,2);
outBeta{3}=outBetas(:,[1,2,3]);%Nonlinear & Low variance
outY{3}=outBetas(:,1)+3*tanh((outBetas(:,2).*outX(:,1))./2)+3*tanh((outBetas(:,3).*outX(:,2))./2);
outBeta{4}=outBetas(:,[1,2,4]);%Nonlinear & High variance
outY{4}=outBetas(:,1)+3*tanh((outBetas(:,2).*outX(:,1))./2)+3*tanh((outBetas(:,4).*outX(:,2))./2);
titles={'X1','X2','Y','U','V','Beta0','Beta1','Beta2'};
for yi=1:4
    vals=[outX(:,1:2),outY{yi},outUV,outBeta{yi}];
    %WriteCsvData(ypaths{yi},titles,vals);
end

outBeta5=outBetas(:,[1,2,3,4]);%Coefficient visualization, 4 Betas, 
outY5=outBetas(:,1)+outBetas(:,2).*outX(:,1)+outBetas(:,3).*outX(:,2)+outBetas(:,4).*outX(:,3);
titles5={'X1','X2','X3','Y','U','V','Beta0','Beta1','Beta2','Beta3'};
vals5=[outX,outY5,outUV,outBeta5];
%WriteCsvData(ypath5,titles5,vals5);

loop=1000;
for j=1:loop
    [outX,~,outBetas] = SimulatedData(ul,vl,betaMax,xMax,sigma2);
    Y5=outBetas(:,1)+outBetas(:,2).*outX(:,1)+outBetas(:,3).*outX(:,2)+outBetas(:,4).*outX(:,3);
    DATA{j}.X=outX;
    DATA{j}.Beta=outBetas(:,[1,2,3,4]);%Prediction ability testing, 4 Betas, 1000 set
    DATA{j}.Y=Y5;
end
%save(".\DATA\SYN\S5_1000.mat","DATA");
