function Yhat2 = filterr(Yhat, qlist,m,k)
    %k=4;
    Yhat2 = Yhat;
    for j = 1:(k-1)
        Structure{j} = combbb(1:m,j+1);
    end
    app_type = unique(qlist);
    app_freq = histc(qlist,app_type);
    
    for i = 1:length(app_type)
        for j = 1:(k-1)
            booll{j} = Structure{j}==app_type(i);
        end
        % hard-coding
        ii = app_freq(i);
        for j = ii:(k-1)
            ind = nchoosek(1:(j+1),ii+1);
            for l=1:size(ind,1)
                zero_out = find(prod(booll{j}(:,ind(l,:)),2));
                Yhat2{j}(zero_out,:)=0;
            end
        end
    end
end
