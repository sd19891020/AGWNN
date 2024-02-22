function [] = ShowSubFigure3(subFig,nX,nY,X,Y,data)

    tX=(reshape(X,nX,nY))';
    tY=(reshape(Y,nX,nY))';
    tZ=(reshape(data,nX,nY))';
    %%»æÖÆÇúÃæÍ¼+ÑÕÉ«Í¼
    hold on;
    pf=pcolor(subFig,tX,tY,tZ);caxis(subFig,[0,4]);grid on;box on;%axis(subFig,'square');
    set(subFig,'xtick',[],'ytick',[],'fontsize',6);set(pf,'edgecolor','none');
    %set(gca,'xtick',[],'ytick',[]);%xlabel('x');ylabel('y');zlabel(zTitle);
end

% ax = uiaxes;
% ax.XTick=[];
% ax.YTick=[];

