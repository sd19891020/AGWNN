function [delta,dw2,db2,dw1,db1,dfgw] = BackPropagation(w2,Net1,Y1,Y2,target,input,gwi,fgwi)
     
    GWHati=gwi.*fgwi;
    % ��������ݶȼ���
    delta = Y2 - target;
    S2 = delta;
    SFGW = gwi'.*(w2'*S2);
    S1 = GWHati'.*(w2'*S2);
    dfgw = SFGW'.*Net1;% �õ�fgw���ݶ�
    dw2 = S2*Y1;     % �õ�w2���ݶ�
    dw1 = S1*input';  % �õ�w1���ݶ�
    db2 = S2;         % �õ�b2���ݶ�
    db1 = S1;         % �õ�b1���ݶ�
   
end

