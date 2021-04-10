function [ y ] = mat2vech( A )
%only for symmetric matrices
if(issame(A,A')==2)
    [m,n] = size(A);
    y = [];
    for i = 1:m
        y = [y;A(i:end,i)];
    end
else
    fprintf('Input matrix A is not symmetric \n');
end

end

