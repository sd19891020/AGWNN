function [YHat,YHat_NOR] = PY(X,inModel,Y,isPRED)

    BetaHat=inModel.BetaHat';
    Err=inModel.LYS{1,5}.b;
    if isPRED
        Err=mean(Err).*ones(size(Err));
    end

    [N,~] = size(X);
    [NX,~]=mapminmax(X');
    [~,PS_Y]=mapminmax(Y');
    INX=[ones(N,1),NX'];
    for i=1:N
        YHat_NOR(1,i)=INX(i,:)*BetaHat(i,:)'+Err(:,i)';
    end
    YHat=mapminmax('reverse',YHat_NOR,PS_Y);
    YHat_NOR=YHat_NOR';
    YHat=YHat';
   
end

