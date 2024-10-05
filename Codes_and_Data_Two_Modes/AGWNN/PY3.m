function [YHat,YHat_NOR,BetaHat] = PY3(X,Y,HP_ALL,inModel)

    HP=inModel.HP;
    [N,~] = size(X);
    [NX,~]=mapminmax(X');
    [~,PS_Y]=mapminmax(Y');
    for i=1:N
        NXi = NX(:,i);
        GWi=MakeGWih(HP_ALL.UV(i,:),HP.HLUV,HP.bw);
        [HP] = ForewardPropagation3(NXi,GWi,HP);
        YHat_NOR(:,i)=HP.LYS{HP.LYNum}.Y;
        
        if HP.isRegressionMode
            BetaHati=[HP.LYS{1}.b,HP.LYS{1}.w]';
            for li=2:(HP.LYNum-1)
                if HP.LYS{li}.TYPE == "GW"
                    lW=GWi';
                else
                    lW=HP.LYS{li}.w';
                end
                BetaHati=BetaHati*lW;
            end
            BetaHat(:,i)=BetaHati;
        else
            BetaHat(:,i)=HP.OLRBH';
        end
        
    end
    YHat=mapminmax('reverse',YHat_NOR,PS_Y);
    YHat_NOR=YHat_NOR';
    YHat=YHat';
   
end

