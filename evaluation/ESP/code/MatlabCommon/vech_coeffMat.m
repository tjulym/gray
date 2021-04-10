function [ A ] = vech_coeffMat( S )
    [m,n] = size(S);
    mm = m*(m+1)/2;
    A = [];
    for i = 1:m
        blockmat = diag(S(i:end,i));
        blockmat(1,:) = S(i,i:end);
        A(i:m, (end+1):(end+m-i+1)) = blockmat;
        
%         r = S_rnd(i,i:end);
%         blockmat = diag(r);
%         blockmat(1,:) = r;
%         A_rnd(i:m, (end+1):(end+length(r)))=blockmat;
    end

end

