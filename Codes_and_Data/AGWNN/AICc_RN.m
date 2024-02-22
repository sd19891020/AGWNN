function [mAICc,mENP]=AICc_RN(X,Y,YHat,IDS,GW,FWG,PS_X,PS_Y)
    X=X';
    Y=Y';
    YHat=YHat';
    [n, ~] = size(X);
    XOne=[ones(n,1),X];
    GWA=GW.*FWG;
    for i = 1 : n   
        LocID = IDS(:,i);
        Wi=GWA(LocID,IDS);
        XOneT_Wi=Matmul(XOne',Wi); %��n*m->m*n,1*n��
        XOneT_Wi_Xone= XOneT_Wi*XOne;%��m*m��
        Ci=pinv(XOneT_Wi_Xone)*XOneT_Wi;%+infiniteMatrix1
        %xi*Ci����ĶԽ�ֵ����ֻ��Ҫ�Խ��ߣ�ȡ�˸���
        S(i)=XOne(i,:)*Ci(:,i);
    end
    
    %RSS_RN=dot(Y-YHat,Y-YHat);
    %X=mapminmax('reverse',X',PS_X);
    Y=mapminmax('reverse',Y',PS_Y);
    YHat=mapminmax('reverse',YHat',PS_Y);
    RSS=dot(Y-YHat,Y-YHat);

    TraceS=sum(S);
    mENP=TraceS;
    sigma=RSS/n;  %(n-TraceS);%
    temp1=n+TraceS;
    temp2=n-2-TraceS;
    mAICc=abs(n*log(sigma)+n*log(2*pi)+n*(temp1/temp2)); 

    
    
    
    
    
    
    

   