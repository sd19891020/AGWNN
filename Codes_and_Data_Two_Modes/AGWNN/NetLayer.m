function [LY] = NetLayer(LayerTypeName,NeuronNumber,NextLayerNeuronNumber,ActivationFunctionName)
    LY.TYPE=LayerTypeName;
    LY.NET=[];
    LY.Y=[];
    LY.SUM=@(x) x*ones(size(x))';
    switch ActivationFunctionName
        case "tanh"
            LY.AF=@(x) tanh(x);
            LY.DAF=@(x) (1-tanh(x).^2)';
        case "sigmoid"
            LY.AF=@(x) 1./(1+exp(-x));
            LY.DAF=@(x) (exp(-x)./(1+exp(-x)).^2)';
        case "softsign"
            LY.AF=@(x) x./(1+abs(x));
            LY.DAF=@(x) (1./(1+abs(x)).^2)';
        case "GW"
            LY.AF=@(x,GWk) GWk.*x;
            LY.DAF=@(GWk) GWk';
        otherwise
            LY.AF=@(x) x;
            LY.DAF=@(x) ones(size(x))';
    end
    switch LayerTypeName
        case {"input","hidden"}
            LY.limit=sqrt(6.0/(NeuronNumber+1+NextLayerNeuronNumber+1));
            LY.w=LY.limit*(rand(NextLayerNeuronNumber,NeuronNumber)*2.0-1.0);
            LY.b=LY.limit*(rand(NextLayerNeuronNumber,1)*2.0-1.0);
            LY.mt_w=zeros(size(LY.w));
            LY.nt_w=zeros(size(LY.w));
            LY.mt_b=zeros(size(LY.b));
            LY.nt_b=zeros(size(LY.b));
            LY.dw=zeros(size(LY.w));
            LY.db=zeros(size(LY.b));
        case {"GW"}
            LY.limit=sqrt(6.0/(NeuronNumber+1+NextLayerNeuronNumber+1));
            LY.w=LY.limit*(rand(NextLayerNeuronNumber,NeuronNumber)*2.0-1.0);
            LY.b=LY.limit*(rand(NextLayerNeuronNumber,1)*2.0-1.0);
            LY.mt_w=zeros(size(LY.w));
            LY.nt_w=zeros(size(LY.w));
            LY.mt_b=zeros(size(LY.b));
            LY.nt_b=zeros(size(LY.b));
            LY.dw=zeros(size(LY.w));
            LY.db=zeros(size(LY.b));
            LY.fgw = ones(NeuronNumber,NeuronNumber);
            LY.mt_fgw=zeros(size(LY.fgw));
            LY.nt_fgw=zeros(size(LY.fgw));
            LY.dfgw=zeros(size(LY.fgw));
        case "output"
            LY.w=eye(NextLayerNeuronNumber,NeuronNumber); 
    end
end

