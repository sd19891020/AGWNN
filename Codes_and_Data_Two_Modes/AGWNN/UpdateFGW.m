function [mt,nt,xt] = UpdateFGW(GWi,gt,mt_prev,nt_prev,xt_prev,lr)

    GWione=ones(size(GWi));
    reGWi=GWione./GWi;
    [~,n]=size(reGWi);
    [mt,nt,xt]=Nadam(gt,mt_prev,nt_prev,xt_prev,lr);
    for i=1:n
        rg=reGWi(i);
        x=xt(i);
        xp=xt_prev(i);
        if x<=0.0 || x>=rg
            xt(i)=xp;
        end
    end
    
end
