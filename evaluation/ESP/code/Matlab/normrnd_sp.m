function Y_rnd = normrnd_sp(Y, Yerror)
    for ii = 1:length(Y); Y_rnd{ii} = max(normrnd(Y{ii},Yerror{ii}),0); end  
end