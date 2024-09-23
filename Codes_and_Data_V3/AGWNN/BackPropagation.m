function [HP] = BackPropagation(LocID,HP,target,GWk)

    S6=HP.LYS{6}.Y-target;
    DY6=HP.LYS{6}.DAF(HP.LYS{6}.Y);
    S5=DY6.*(HP.LYS{6}.w'*S6);
    HP.LYS{5}.db(1,LocID) = S5; 
    HP.LYS{5}.dw = S5*HP.LYS{5}.Y;
    SFGW5 = GWk'.*(HP.LYS{5}.w'*S5);
    HP.LYS{5}.dfgw(LocID,:) = SFGW5'.*HP.LYS{5}.NET;
    
    fGWk=HP.LYS{5}.fgw(LocID,:);
    mGWk=GWk.*fGWk;
    DY5=HP.LYS{5}.DAF(mGWk);
    S4=DY5.*(HP.LYS{5}.w'*S5);
    HP.LYS{4}.db = S4; 
    HP.LYS{4}.dw = S4*HP.LYS{4}.Y(:,2:end);
    
    DY4=HP.LYS{4}.DAF(HP.LYS{4}.Y);
    WB4=[HP.LYS{4}.b';HP.LYS{4}.w'];
    S3=DY4.*(WB4*S4);
    
    DY3=HP.LYS{3}.DAF(HP.LYS{3}.Y);
    S2=DY3.*S3;
    HP.LYS{2}.db = S2; 
    HP.LYS{2}.dw = S2*HP.LYS{2}.Y;
    
    DY2=HP.LYS{2}.DAF(HP.LYS{2}.Y);
    S1=DY2.*(HP.LYS{2}.w'*S2);
    HP.LYS{1}.db = S1; 
    HP.LYS{1}.dw = S1*HP.LYS{1}.Y;

end

