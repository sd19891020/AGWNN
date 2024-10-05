function [mt,nt,xt] = Nadam(gt,mt_prev,nt_prev,xt_prev,lr)

    eps=10^(-8);
    mu=0.975;
    nu=0.999;
    
    mt=mu*mt_prev+(1-mu)*gt;
    nt=nu*nt_prev+(1-nu)*(gt.*gt);
    mhat =mu*mt/(1-mu)+(1-mu)*gt./(1-mu); 
    nhat = nu*nt/(1-nu);
    xt= xt_prev-lr*mhat./(sqrt(nhat)+eps);
    
end

