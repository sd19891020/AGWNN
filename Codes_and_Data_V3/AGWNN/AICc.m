function [mAICc,mENP]=AICc(X,Y,YHat,HP)
    X=X';
    Y=Y';
    YHat=YHat';
    [n, ~] = size(X);
    XOne=[ones(n,1),X];
    for i = 1 : n  
        GWi=MakeGWih(HP.UV(i,:),HP.HLUV,HP.bw);
        fGWi=HP.LYS{5}.fgw(i,:);
        Wi=GWi.*fGWi;
        XOneT_Wi=Matmul(XOne',Wi);
        XOneT_Wi_Xone= XOneT_Wi*XOne;
        Ci=pinv(XOneT_Wi_Xone)*XOneT_Wi;
        S(i)=XOne(i,:)*Ci(:,i);
    end
    RSS=dot(Y-YHat,Y-YHat);
    TraceS=sum(S);
    mENP=TraceS;
    sigma=RSS/n;
    temp1=n+TraceS;
    temp2=n-2-TraceS;
    mAICc=abs(n*log(sigma)+n*log(2*pi)+n*(temp1/temp2)); 

    
    
    
    
    
    
    

   