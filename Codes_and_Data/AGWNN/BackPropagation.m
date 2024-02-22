function [delta,dw2,db2,dw1,db1,dfgw] = BackPropagation(w2,Net1,Y1,Y2,target,input,gwi,fgwi)
     
    GWHati=gwi.*fgwi;
    % 反向逐层梯度计算
    delta = Y2 - target;
    S2 = delta;
    SFGW = gwi'.*(w2'*S2);
    S1 = GWHati'.*(w2'*S2);
    dfgw = SFGW'.*Net1;% 得到fgw的梯度
    dw2 = S2*Y1;     % 得到w2的梯度
    dw1 = S1*input';  % 得到w1的梯度
    db2 = S2;         % 得到b2的梯度
    db1 = S1;         % 得到b1的梯度
   
end

