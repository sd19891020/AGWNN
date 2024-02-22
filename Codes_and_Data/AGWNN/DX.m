function [mAICc,mENP,mDoD,mDoD2,mSE,mDF,TV,PV]=DX(X,Y,YHat,BetaHat,GWA,isNormalized)
    %%模型诊断：AICc,ENP,DoD,DoD2,SE,DF

    [~, ycs] = size(Y);
    if(ycs<=1)
        X=X';
        Y=Y';
        YHat=YHat';
        BetaHat=BetaHat';
    end
    
    % 输入数据标准化
    if isNormalized
        [X,~]=mapminmax(X);
        [Y,PS_Y]=mapminmax(Y);
        [YHat,~]=mapminmax(YHat,PS_Y);
    end

    X=X';
    Y=Y';
    YHat=YHat';
    BetaHat=BetaHat';
    
    [n, k] = size(X);
    XOne=[ones(n,1),X];
    %GWA=GW.*FGW;
    for i = 1 : n   
        Wi=GWA(i,:);
        XOneT_Wi=Matmul(XOne',Wi); %（n*m->m*n,1*n）
        XOneT_Wi_Xone= XOneT_Wi*XOne;%（m*m）
        Ci=pinv(XOneT_Wi_Xone)*XOneT_Wi;%+infiniteMatrix1
        %xi*Ci矩阵的对角值，迹只需要对角线，取了个巧
        S(i)=XOne(i,:)*Ci(:,i);
        %BetaHat(i,:)=Ci*Y;
        CCT(i,:)=diag(Ci*Ci');
    end  
    
    if isNormalized
        RSS_RN=dot(Y-YHat,Y-YHat);
        Y=mapminmax('reverse',Y,PS_Y);
        YHat=mapminmax('reverse',YHat,PS_Y);
        RSS=dot(Y-YHat,Y-YHat);
    else
        RSS_RN=dot(Y-YHat,Y-YHat);
        RSS=RSS_RN;
    end
    
    STS=S.*S;
    TS=sum(S);
    TSTS=sum(STS);
    
    mENP=TS;
    sigma=RSS/n;%n;  %RSS/(n-TraceS);%
    temp1=n+TS;
    temp2=n-2-TS;
    mAICc=abs( n*log(sigma)+n*log(2*pi)+abs(n*(temp1/temp2)) );%abs(n*log(sigma)+n*log(2*pi)+n*(temp1/temp2)); 
    
    P=k+1;
    Pe=2*TS-TSTS;
    mDoD=P/Pe;
    mDoD2=sqrt(1-(Pe/(n*P)));
    alpha=mDoD*0.05;
    alpha2=mDoD2*0.05;
    
    mDF=n-TS;
    sigma2=RSS_RN/mDF;
    Var=CCT.*sigma2;
    mSE=sqrt(Var);
    TV=BetaHat./mSE;
    PV=2*(1-tcdf(abs(TV),mDF));
    
    for jj=1:P
        [num,~]=size(find(PV(:,jj)<=alpha2));
        per(jj)=num/double(n);
    end
    
end
    
    
    
    
    
    
    

   