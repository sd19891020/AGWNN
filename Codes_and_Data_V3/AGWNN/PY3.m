function [YHat,YHat_NOR] = PY3(X,BetaHat,inModel,Y)

    Errs=inModel.LYS{1,5}.b;
    Err=mean(Errs);

    [N,~] = size(X);
    [NX,~]=mapminmax(X');
    [~,PS_Y]=mapminmax(Y');
    INX=[ones(N,1),NX'];
    for i=1:N
        YHat_NOR(1,i)=INX(i,:)*BetaHat(i,:)'+Err;
    end
    YHat=mapminmax('reverse',YHat_NOR,PS_Y);
    YHat_NOR=YHat_NOR';
    YHat=YHat';
   
end

