function [mAICc,mENP]=AICc(S,n,Y,YHat)
    Y=Y';
    YHat=YHat';
    RSS=dot(Y-YHat,Y-YHat);
    TraceS=sum(S);
    mENP=TraceS;
    sigma=RSS/n;
    temp1=n+TraceS;
    temp2=n-2-TraceS;
    mAICc=abs(n*log(sigma)+n*log(2*pi)+n*(temp1/temp2)); 

    
    
    
    
    
    
    

   