function [FullStat,OptimalModel] = AGWNN(HP)
    
    OptimalModel.LOSS=Inf;
    OptimalModel.AICc=Inf;
    OptimalModel.LYS=HP.LYS;
    
    FullStat.loss_history=[];
    FullStat.rmse_history = []; 
    FullStat.r2_history = []; 
    FullStat.r2adj_history = []; 
    FullStat.aicc_history = []; 
    
    XORI=HP.XORI;
    YORI=HP.YORI;
    IDS=HP.IDS;
    [xNum,N]=size(XORI);

    [X_ALL,PS_X]=mapminmax(XORI);
    [Y_ALL,PS_Y]=mapminmax(YORI);
    AllSamples=[X_ALL;Y_ALL;IDS];
    
    patienceCount=0;

    for j=1:HP.epochNum   
        vsNum=floor(HP.vsRatio*N);
        trainNum=N-vsNum;
        ShuffledSamples=Shuffle(AllSamples,false);
        XShuffle=ShuffledSamples(1:xNum,1:trainNum);
        TargetShuffle=ShuffledSamples(xNum+1,1:trainNum);
        IDSShuffle=ShuffledSamples(xNum+2,1:trainNum);
        mbs=ceil(trainNum/HP.mbNum);

        for jmb=1:mbs 
            sid=(jmb-1)*HP.mbNum+1;
            if(jmb>=mbs) 
                eid=trainNum;
            else
                eid=jmb*HP.mbNum;
            end
            XShuffle_mb=XShuffle(:,sid:eid);
            TargetShuffle_mb=TargetShuffle(:,sid:eid);
            IDSShuffle_mb=IDSShuffle(:,sid:eid);
            UV_mb=HP.UV(IDSShuffle_mb,:);

            jmbNum=eid-sid+1;
  
            for li=1:HP.LYNum
                if HP.LYS{li}.TYPE ~= "output"
                    dw_sum{li}=zeros(size(HP.LYS{li}.w));
                    db_sum{li}=zeros(size(HP.LYS{li}.b));
                end
            end

            for k=1:jmbNum  
                LocID=IDSShuffle_mb(1,k);
                target_mb = TargetShuffle_mb(:,k);
                input_mb = XShuffle_mb(:,k);
                GWk=MakeGWih(UV_mb(k,:),HP.HLUV,HP.bw);
                
                [HP] = ForewardPropagation(LocID,input_mb,GWk,HP); 
                [HP] = BackPropagation(LocID,target_mb,GWk,HP);
                for li=1:HP.LYNum
                    if HP.LYS{li}.TYPE ~= "output"
                        dw_sum{li}=dw_sum{li}+HP.LYS{li}.dw;
                        db_sum{li}=db_sum{li}+HP.LYS{li}.db;
                    end
                    if HP.LYS{li}.TYPE == "GW"
                        [HP.LYS{li}.mt_fgw(LocID,:),HP.LYS{li}.nt_fgw(LocID,:),HP.LYS{li}.fgw(LocID,:)]=UpdateFGW(GWk,HP.LYS{li}.dfgw(LocID,:),HP.LYS{li}.mt_fgw(LocID,:),HP.LYS{li}.nt_fgw(LocID,:),HP.LYS{li}.fgw(LocID,:),HP.gwlr);
                    end
                end
            end
            for li=1:HP.LYNum
                if HP.LYS{li}.TYPE ~= 'output'
                    dw_mean{li}=dw_sum{li}./jmbNum;
                    db_mean{li}=db_sum{li}./jmbNum;
                    [HP.LYS{li}.mt_w,HP.LYS{li}.nt_w,HP.LYS{li}.w]=Nadam(dw_mean{li},HP.LYS{li}.mt_w,HP.LYS{li}.nt_w,HP.LYS{li}.w,HP.lr);
                    [HP.LYS{li}.mt_b,HP.LYS{li}.nt_b,HP.LYS{li}.b]=Nadam(db_mean{li},HP.LYS{li}.mt_b,HP.LYS{li}.nt_b,HP.LYS{li}.b,HP.lr);
                end
            end
            
        end
        

        [STAT_full,YHat_full,YHat_NOR_full,HP,BetaHat] = FP_CV(X_ALL,Y_ALL,HP,PS_X,PS_Y);
        FullStat.loss_history=[FullStat.loss_history,STAT_full.LOSS];
        FullStat.rmse_history = [FullStat.rmse_history,STAT_full.RMSE]; 
        FullStat.r2_history = [FullStat.r2_history,STAT_full.R2]; 
        FullStat.r2adj_history = [FullStat.r2adj_history,STAT_full.R2adj]; 
        FullStat.aicc_history = [FullStat.aicc_history,STAT_full.AICc]; 
        
        fprintf('epoch=%d£¬AICc=%f£¬LOSS=%f£¬adjR2=%f \n',j,STAT_full.AICc,STAT_full.LOSS,STAT_full.R2adj);
        
        if STAT_full.R2adj>=0.0 && HP.isEarlyStopping && patienceCount>=HP.patience
            break;
        end
        
        if j<HP.aLoopEpochNum || STAT_full.AICc<OptimalModel.AICc 
            OptimalModel.HP=HP;
            OptimalModel.LYS=HP.LYS;
            OptimalModel.lr = HP.lr;
            OptimalModel.Stat=STAT_full;
            OptimalModel.AICc=STAT_full.AICc;
            OptimalModel.LOSS=STAT_full.LOSS;
            OptimalModel.epochIndex=j;
            OptimalModel.YHat=YHat_full;
            OptimalModel.YHat_NOR=YHat_NOR_full;
            OptimalModel.BetaHat=BetaHat;
            patienceCount=1;
        elseif patienceCount>=1
            patienceCount=patienceCount+1;
        end
        
    end
    
    
    
    
end

