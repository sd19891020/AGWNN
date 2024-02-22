function [TrainStat,TestStat,FullStat,BatchStat,OptimalModel] = AGWNN3(TrainSet,HyperParameters)
    
    %输入数据需打上ID
    %训练集内部-随机交叉验证版
    %isGWSumNorm与isNormalized一起使用，效果好。因此两者均不启用，或均启用。

    XORI=TrainSet.XORI;
    YORI=TrainSet.YORI;
    IDS=TrainSet.IDS;
    [xNum,N]=size(XORI);
    %IDS=1:N;
    
    %获取超参数
    OptimalModel.AICc=Inf;
    OptimalModel.w1 = HyperParameters.w1;
    OptimalModel.w2 = HyperParameters.w2;
    OptimalModel.fgw = HyperParameters.fgw;
    OptimalModel.b1 = HyperParameters.b1;
    OptimalModel.b2 = HyperParameters.b2;
    

    % 设置超参数
    isEarlyStopping=HyperParameters.isEarlyStopping;%是否启用早停
    patience=HyperParameters.patience;%耐心轮数一般设为13
    patienceCount=0;
    aLoopEpochNum=HyperParameters.aLoopEpochNum;%可早停轮数
    isNormalized=HyperParameters.isNormalized;
    vsRatio =HyperParameters.vsRatio;
    lr=HyperParameters.lr;
    epochNum=HyperParameters.epochNum;
    mbNum=HyperParameters.mbNum;
    w1 = HyperParameters.w1;
    w2 = HyperParameters.w2;
    fgw = HyperParameters.fgw;
    b1 = HyperParameters.b1;
    b2 = HyperParameters.b2;
    gwlr=HyperParameters.gwlr;
    GW=HyperParameters.GW;

    % 保存一些训练过程中的变量
    TrainStat.loss_history=[];
    TrainStat.rmse_history = []; 
    TrainStat.r2_history = []; 
    TrainStat.r2adj_history = []; 
    TrainStat.aicc_history = []; 

    TestStat.loss_history=[];
    TestStat.rmse_history = []; 
    TestStat.r2_history = []; 
    TestStat.r2adj_history = []; 
    TestStat.aicc_history = []; 
    
    BatchStat.bmc_history = [];
    
    FullStat.loss_history=[];
    FullStat.rmse_history = []; 
    FullStat.r2_history = []; 
    FullStat.r2adj_history = []; 
    FullStat.aicc_history = []; 


    % 输入数据标准化
    if isNormalized
        [X_ALL,PS_X]=mapminmax(XORI);
        [Y_ALL,PS_Y]=mapminmax(YORI);
    else
        X_ALL=XORI;
        Y_ALL=YORI;
    end
    AllSamples=[X_ALL;Y_ALL;IDS];
    
    %初始化空间权重倒数矩阵
    %[reGW] = InitReGW(GW);
    GWone=ones(size(GW));
    reGW=GWone./GW;
   
    %优化器超参数初始化
    mt_fgw=zeros(size(fgw));
    nt_fgw=zeros(size(fgw));
    mt_w2=zeros(size(w2));
    nt_w2=zeros(size(w2));
    mt_w1=zeros(size(w1));
    nt_w1=zeros(size(w1));
    mt_b2=zeros(size(b2));
    nt_b2=zeros(size(b2));
    mt_b1=zeros(size(b1));
    nt_b1=zeros(size(b1));

    for j=1:epochNum   

        vsNum=floor(vsRatio*N);%验证集大小
        trainNum=N-vsNum;%训练集大小
        
        ShuffledSamples=Shuffle(AllSamples,false);
        
        XShuffle=ShuffledSamples(1:xNum,1:trainNum);
        TargetShuffle=ShuffledSamples(xNum+1,1:trainNum);
        IDSShuffle=ShuffledSamples(xNum+2,1:trainNum);

        mbs=ceil(trainNum/mbNum);

        for jmb=1:mbs 
            sid=(jmb-1)*mbNum+1;
            if(jmb>=mbs) 
                eid=trainNum;
            else
                eid=jmb*mbNum;
            end
            XShuffle_mb=XShuffle(:,sid:eid);
            TargetShuffle_mb=TargetShuffle(:,sid:eid);
            IDSShuffle_mb=IDSShuffle(:,sid:eid);

            jmbNum=eid-sid+1;

            dw2_sum=zeros(size(w2));
            db2_sum=zeros(size(b2));
            dw1_sum=zeros(size(w1));
            db1_sum=zeros(size(b1));
            for k=1:jmbNum  
                [Net1_mb,Y1_mb,Y2_mb,target_mb,input_mb,gwi_mb,fgwi_mb,LocID_mb] = ForewardPropagation(k,XShuffle_mb,TargetShuffle_mb,IDSShuffle_mb,GW,w1,b1,w2,b2,fgw); 
                [~,dw2,db2,dw1,db1,dfgw] = BackPropagation(w2,Net1_mb,Y1_mb,Y2_mb,target_mb,input_mb,gwi_mb,fgwi_mb);
                dw2_sum=dw2_sum+dw2;
                db2_sum=db2_sum+db2;
                dw1_sum=dw1_sum+dw1;
                db1_sum=db1_sum+db1;
                %注意：fgw与样本位置有关，每个样本训练结果需单独调节
                [mt_fgw(LocID_mb,:),nt_fgw(LocID_mb,:),fgw(LocID_mb,:)]=UpdateFGW(reGW(LocID_mb,:),dfgw,mt_fgw(LocID_mb,:),nt_fgw(LocID_mb,:),fgw(LocID_mb,:),gwlr);
                %[mt_b2(LocID_mb),nt_b2(LocID_mb),b2(LocID_mb)]=Nadam(db2,mt_b2(LocID_mb),nt_b2(LocID_mb),b2(LocID_mb),gwlr);
            end
            
            %========================开始进行mini-batch梯度下降==============================
            %计算梯度均值
            dw2_mean=dw2_sum./jmbNum;
            db2_mean=db2_sum./jmbNum;
            dw1_mean=dw1_sum./jmbNum;
            db1_mean=db1_sum./jmbNum;
            %网络参数逐层更新(Nadam优化器)
            [mt_w2,nt_w2,w2]=Nadam(dw2_mean,mt_w2,nt_w2,w2,lr);
            [mt_b2,nt_b2,b2]=Nadam(db2_mean,mt_b2,nt_b2,b2,lr);
            [mt_w1,nt_w1,w1]=Nadam(dw1_mean,mt_w1,nt_w1,w1,lr);
            [mt_b1,nt_b1,b1]=Nadam(db1_mean,mt_b1,nt_b1,b1,lr);
            %========================进行mini-batch梯度下降结束==============================

        end
        
        %全样本统计指标
        if isNormalized
            [STAT_full,YHat_full,BetaHat_full,GBetaHat_full] = FP_CV_RN(X_ALL,Y_ALL,IDS,GW,w1,b1,w2,b2,fgw,PS_X,PS_Y);
        else
            [STAT_full,YHat_full,BetaHat_full,GBetaHat_full] = FP_CV(X_ALL,Y_ALL,IDS,GW,w1,b1,w2,b2,fgw);
        end
        FullStat.loss_history=[FullStat.loss_history,STAT_full.LOSS];
        FullStat.rmse_history = [FullStat.rmse_history,STAT_full.RMSE]; 
        FullStat.r2_history = [FullStat.r2_history,STAT_full.R2]; 
        FullStat.r2adj_history = [FullStat.r2adj_history,STAT_full.R2adj]; 
        FullStat.aicc_history = [FullStat.aicc_history,STAT_full.AICc]; 
        
        %fprintf('训练轮数=%d，AICc=%f，LOSS=%f，adjR2=%f \n',j,STAT_full.AICc,STAT_full.LOSS,STAT_full.R2adj);
        
        %早停退出训练
        if STAT_full.R2adj>=0.0 && isEarlyStopping && patienceCount>=patience
            return;
        end
        
        %利用全样本AICc作为模型优选指标
        if j<aLoopEpochNum || STAT_full.AICc<OptimalModel.AICc 
            OptimalModel.lr = lr;
            OptimalModel.w1 = w1;
            OptimalModel.w2 = w2;
            OptimalModel.fgw = fgw;
            OptimalModel.b1 = b1;
            OptimalModel.b2 = b2;
            OptimalModel.GW=GW;
            OptimalModel.corGW=fgw.*GW;
            OptimalModel.Stat=STAT_full;
            OptimalModel.AICc=STAT_full.AICc;
            OptimalModel.epochIndex=j;
            OptimalModel.YHat=YHat_full;
            OptimalModel.BetaHat=BetaHat_full;
            OptimalModel.GBetaHat=GBetaHat_full;
            %发现新波谷
            patienceCount=1;
        elseif patienceCount>=1
            patienceCount=patienceCount+1;
        end
        
    end
    
    
    
    
end

