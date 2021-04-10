function [ tensorY ] = mat2tensor(Y,id1,id2,id3)
% converts power performance data to tensor only.

% these are the foldings of the tensor
% id1 = 16; 
% id2 =16; 
% id3 = 1; 
[a,b] = size(Y);
if(a==1)
    Y = Y'; % to convert row vector to column vector.
end
[a,b] = size(Y);
id4 = b;

if(a==prod([id1,id2,id3]))
    for l = 1:id4
        for i = 1:id1
            for j = 1:id2
                for k = 1:id3            
                    tensorY(i,j,k,l) = Y(sub2indY1024( i,j,k ),l);
                end
            end
        end    
    end
else    
    fprintf('Error in the size length(Y)=%d is not equal to id1*id2*id3=%d',...
            a, prod([id1,id2,id3]));
end
    
    %tensorY= permute(tensorY,[3,2,1,4]);
end