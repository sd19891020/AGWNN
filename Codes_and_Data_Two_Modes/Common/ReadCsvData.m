function dataNorm=ReadCsvData(path,uid,vid,yid,xids)
    data=table2array(readtable(path));
    [n,~] = size(data);
    
    dataNorm.n = n;
    dataNorm.xNum = size(xids,2);
    dataNorm.u = data(:,uid);
    dataNorm.v = data(:,vid);
    dataNorm.VARS = data(:,[yid,xids]);
    varNum=size(dataNorm.VARS,2);
    
    mIDS=[];
    for vi=1:varNum
        ODATA=dataNorm.VARS(:,vi);
        TF=ismissing(ODATA);
        for i=1:n
            if TF(i)
                mIDS=[mIDS,i];
            end
        end
    end
    mIDS=unique(mIDS);
    dataNorm.VARS(mIDS,:)=[];
    dataNorm.u(mIDS,:) = [];
    dataNorm.v(mIDS,:) = [];
    [n,~] = size(dataNorm.VARS);
    dataNorm.n = n;
    
    
    XYs=dataNorm.VARS;
    XYNum=size(XYs,2);
    
    dataNorm.Y=XYs(:,1);
    dataNorm.X=XYs(:,2:XYNum);
    dataNorm.XOne = [ones(n,1),dataNorm.X];
    dataNorm.XI = [dataNorm.X,ones(n,1)];
    
end    
 