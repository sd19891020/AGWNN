function [matOut] = Shuffle(mat,byRow)
    
    if byRow==true
        rowrank = randperm(size(mat,1)); 
        matOut = mat(rowrank,:);             
    else
        colrank = randperm(size(mat,2)); 
        matOut = mat(:,colrank);   
    end

end

