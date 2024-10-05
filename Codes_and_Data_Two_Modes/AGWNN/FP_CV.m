function [STAT,YHat_RRN,YHat,HP,BetaHat] = FP_CV(X,Y,HP,PS_X,PS_Y)
    [~,N]=size(X);
    YHat=zeros(1,N);
    XOne=[ones(N,1),X'];
    for i=1:N
        Xi = X(:,i);
        GWi=MakeGWih(HP.UV(i,:),HP.HLUV,HP.bw);
        [HP] = ForewardPropagation(i,Xi,GWi,HP);
        YHat(:,i)=HP.LYS{HP.LYNum}.Y;
        
        fGWi=GWi.*HP.LYS{HP.LYNum-1}.fgw(i,:);
        Wi=fGWi;
        XOneT_Wi=Matmul(XOne',Wi); %£¨n*m->m*n,1*n£©
        XOneT_Wi_Xone= XOneT_Wi*XOne;%£¨m*m£©
        Ci=pinv(XOneT_Wi_Xone)*XOneT_Wi;%+infiniteMatrix1
        S(i)=XOne(i,:)*Ci(:,i);
        
        if HP.isRegressionMode
            BetaHati=[HP.LYS{1}.b,HP.LYS{1}.w]';
            for li=2:(HP.LYNum-1)
                if HP.LYS{li}.TYPE == "GW"
                    lW=fGWi';
                else
                    lW=HP.LYS{li}.w';
                end
                BetaHati=BetaHati*lW;
            end
            BetaHat(:,i)=BetaHati;
        else
            BetaHat(:,i)=(Ci*Y')';
        end
    end

    X_RRN=mapminmax('reverse',X,PS_X);
    Y_RRN=mapminmax('reverse',Y,PS_Y);
    YHat_RRN=mapminmax('reverse',YHat,PS_Y);
    
    [STAT] = XStat(X_RRN,Y_RRN,YHat_RRN);
    [STAT.AICc,STAT.ENP]=AICc(S,N,Y_RRN,YHat_RRN);
   
end

