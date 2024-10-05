function [HP] = ForewardPropagation3(input,GWk,HP)
    
    GNNum=length(HP.YORI);
    HP.LYS{1}.Y=input';
    for li=2:HP.LYNum
        pli=li-1;
        ann_In=[1,HP.LYS{pli}.Y];
        if HP.LYS{pli}.TYPE == "GW"
            ann_W=[HP.LYS{pli}.b,ones(1,GNNum)]';
        else
            ann_W=[HP.LYS{pli}.b,HP.LYS{pli}.w]';
        end
        NET=ann_In*ann_W;
        HP.LYS{li}.NET=NET;
        if HP.LYS{li}.TYPE == "GW"
            HP.LYS{li}.Y=HP.LYS{li}.AF(NET,GWk);
        else
            HP.LYS{li}.Y=HP.LYS{li}.AF(NET);
        end
    end

end

