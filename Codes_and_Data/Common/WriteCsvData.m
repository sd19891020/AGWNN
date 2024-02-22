function [] = WriteCsvData(outPath,titles,vals)
    
    [~,col]=size(vals);
    T=array2table(vals);
    T.Properties.VariableNames(1:col)=titles;
    writetable(T,outPath);

end

