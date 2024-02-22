function [YHat,BetaHat] = PY3(HLIndexs,AllGW,ALLX,ALLY,w1,b1,w2,b2,fgw)

    AllGW=AllGW(:,HLIndexs);
    AllFgw=ones(size(AllGW));
    AllFgw(HLIndexs,:)=fgw;
    
    [~,N]=size(ALLX);
    YHat=zeros(1,N);
    GGGG=[b1,w1];
    IDS=1:N;
    for i=1:N
        [~,~,YHat(i),~,~,gwi,fgwi,~] = ForewardPropagation(i,ALLX,ALLY,IDS,AllGW,w1,b1,w2,b2,AllFgw);
        GWHati=gwi.*fgwi;
        BetaHat(i,:)=(w2.*GWHati)*GGGG; 
    end

    
end

