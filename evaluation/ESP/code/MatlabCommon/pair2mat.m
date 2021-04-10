function [ S ] = pair2mat( Y )

[n,p] = size(Y);
m = (1+sqrt(1+8*n))/2;
if(m~=floor(m) )
    error('length of input is not right for pair');
elseif(p~=2)
    error('The number of columns in Y should be 2.');
else
    S = zeros(m);
    t = 1;
    for i = 1:m
        for j = i+1: m
            S(i,j) = Y(t,1);
            S(j,i) = Y(t,2);
            t = t+1;
        end
    end
end
end

