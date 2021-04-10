function [ Y ] = mat2pair( S )

[n,p] = size(S);

if(n~=p )
    error('matrix must be square');
else
    Y = zeros(n*(n-1)/2,2);
    t = 1;
    for i = 1:n
        for j = i+1: n
            Y(t,1) = S(i,j) ;
            Y(t,2) = S(j,i) ;
            t = t+1;
        end
    end
end
end

