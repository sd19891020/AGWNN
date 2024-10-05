function [] = ShowSubFigureY(subFig,nX,nY,X,Y,data,minData,maxData,txt,xticks,yticks)

    tX=(reshape(X,nX,nY))';
    tY=(reshape(Y,nX,nY))';
    tZ=(reshape(data,nX,nY))';
    hold on;
    pf=pcolor(subFig,tX,tY,tZ);
    caxis(subFig,[minData maxData]);
    grid on;box on;
    title(subFig,txt);
    set(subFig,'xtick',xticks,'ytick',yticks,'fontsize',12);
    set(pf,'edgecolor','none');
    
end

