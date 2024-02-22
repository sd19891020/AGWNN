function [] = ShowSubFigure(subFig1,subFig2,nX,nY,X,Y,data,zTitle)

    tX=(reshape(X,nX,nY))';
    tY=(reshape(Y,nX,nY))';
    tZ=(reshape(data,nX,nY))';
    %%»æÖÆÇúÃæÍ¼+ÑÕÉ«Í¼
    hold on;
    sf=surf(subFig1,tX,tY,tZ);set(subFig1,'xtick',[],'ytick',[],'ztick',[0,2,4],'zlim',[0,5],'fontsize',6);set(sf,'edgecolor','none');%xlabel('x');ylabel('y');zlabel(zTitle);
    hold on;
    pf=pcolor(subFig2,tX,tY,tZ);set(subFig2,'xtick',[],'ytick',[],'fontsize',6);set(pf,'edgecolor','none');%set(gca,'xtick',[],'ytick',[]);%xlabel('x');ylabel('y');zlabel(zTitle);
end

% ax = uiaxes;
% ax.XTick=[];
% ax.YTick=[];

