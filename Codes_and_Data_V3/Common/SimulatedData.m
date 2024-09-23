function [outX,outUV,outBetas,outError] = SimulatedData(xyUnits,xyRank,betaMax,XMax,errorSigema)

    n=xyRank*xyRank;
    xyScale=xyUnits/(xyRank-1);
    for i=1:n
        u(i)=xyScale*mod(i-1,xyRank);
        v(i)=xyScale*floor((i-1)/xyRank);
    end
    u=u';
    v=v';

    beta_scale_0=betaMax/2;
    beta_scale_1=betaMax/(xyUnits*2);
    beta_scale_22=betaMax/2;
    beta_scale_23=betaMax/2;
    beta0=beta_scale_0.*ones(n,1);
    beta1=beta_scale_1*(u+v);
    beta22=beta_scale_22*abs(cos((2/xyUnits)*pi*u)+cos((2/xyUnits)*pi*v));
    beta23=beta_scale_23*(1+sin((2/xyUnits)*pi*u).^2-cos((2/xyUnits)*pi*v).^2);

    X1=XMax*rand(n,1);
    X2=XMax*rand(n,1);
    X3=XMax*rand(n,1);
    error=normrnd(0,errorSigema,[n,1]);

    outX=[X1,X2,X3];
    outUV=[u,v];
	outError=error;
	outBetas=[beta0,beta1,beta23,beta22];

end

