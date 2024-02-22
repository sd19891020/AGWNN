function [YHat] = PY(X,BetaHat,b2)
    [N, ~] = size(X);
    XOne=[ones(N,1),X];  
    for i=1:N
        YHat(i,1)=XOne(i,:)*BetaHat(i,:)'+b2(i,:);
    end
end

