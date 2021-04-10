function [ T2 ] = vech2mat( y )
%UNTITLED3 Summary of this function goes here
%   output matrix is symmetric
 tmp = y;
 mm = length(y);
 m = (-1+sqrt(1+8*mm))/2; 
        T2 = zeros(m);
            for i = 1:m
                T2(i:m,i) = tmp(1:(m-i+1));
                tmp(1:(m-i+1))=[];
            end
       T2 = T2+T2';
       for i = 1:m
           T2(i,i)=T2(i,i)/2;
       end
    
end

