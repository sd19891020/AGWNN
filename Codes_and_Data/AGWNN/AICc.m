function [mAICc,mENP]=AICc(X,Y,YHat,IDS,GW,FWG)
    X=X';
    Y=Y';
    YHat=YHat';
    [n, ~] = size(X);
    XOne=[ones(n,1),X];
    GWA=GW.*FWG;
    for i = 1 : n   
        LocID = IDS(:,i);
        Wi=GWA(LocID,IDS);
        XOneT_Wi=Matmul(XOne',Wi); %（n*m->m*n,1*n）
        XOneT_Wi_Xone= XOneT_Wi*XOne;%（m*m）
        Ci=pinv(XOneT_Wi_Xone)*XOneT_Wi;%+infiniteMatrix1
        %xi*Ci矩阵的对角值，迹只需要对角线，取了个巧
        S(i)=XOne(i,:)*Ci(:,i);
    end 
    
    RSS=dot(Y-YHat,Y-YHat);
    
    TraceS=sum(S);
    mENP=TraceS;
    sigma=RSS/n;  %(n-TraceS);%
    temp1=n+TraceS;
    temp2=n-2-TraceS;
    mAICc=abs(n*log(sigma)+n*log(2*pi)+n*(temp1/temp2)); 

    
    
    
    
    
    
    

   