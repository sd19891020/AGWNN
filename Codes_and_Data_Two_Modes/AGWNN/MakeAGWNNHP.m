function [HP] = MakeAGWNNHP(trainDataNorm,bw,NN)

    xNum=trainDataNorm.xNum;
    trainSampleNum=trainDataNorm.n;
    HP.bw=bw;
    HP.BNum=xNum+1;

    HP.UV = [trainDataNorm.u,trainDataNorm.v];
    HP.HLUV = HP.UV;
    HP.IDS = 1:trainSampleNum;
    HP.XORI = trainDataNorm.X';
    HP.YORI = trainDataNorm.Y';
    XOne=[ones(1,trainSampleNum);HP.XORI];
    HP.OLRBH=regress(HP.YORI',XOne')';

    HP.LYNum=NN.LYNum;
    for li=1:HP.LYNum
        HP.LYS{li} = NetLayer(NN.LTNs{li},NN.LNNums(li),NN.Next_LNNums(li),NN.LAFNs{li});
    end
    
    fprintf('Hyperparameters initialization completed. \n');
    
end

