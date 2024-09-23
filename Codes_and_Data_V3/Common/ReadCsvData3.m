function dataNorm=ReadCsvData3(path)
    data=table2array(readtable(path));
    [n,~] = size(data);

    dataNorm.n = n;
    dataNorm.VARS = data;
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
    [n,~] = size(dataNorm.VARS);
    dataNorm.n = n;
    
end    
 