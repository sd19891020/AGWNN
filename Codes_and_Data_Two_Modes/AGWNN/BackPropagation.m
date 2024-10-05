function [HP] = BackPropagation(LocID,target,GWk,HP)

    S=HP.LYS{HP.LYNum}.Y-target;  
    for li=HP.LYNum:-1:2
        pli=li-1;
        if HP.LYS{li}.TYPE == "GW"
            DY=HP.LYS{li}.DAF(GWk);
        else
            DY=HP.LYS{li}.DAF(HP.LYS{li}.Y);
        end
        if HP.LYS{li}.TYPE == "GW"
            S_PRE=DY.*(HP.LYS{li}.fgw(LocID,:)'*S);
        else
            S_PRE=DY.*(HP.LYS{li}.w'*S);
        end
        S=S_PRE;
        if HP.LYS{pli}.TYPE == "GW"
            HP.LYS{pli}.dfgb(:,LocID) = S_PRE; 
            HP.LYS{pli}.dfgw(LocID,:) = S_PRE*HP.LYS{pli}.Y;
        end
        HP.LYS{pli}.db = S_PRE; 
        HP.LYS{pli}.dw = S_PRE*HP.LYS{pli}.Y;
        
    end

end

