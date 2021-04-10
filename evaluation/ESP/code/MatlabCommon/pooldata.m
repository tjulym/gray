function [ omean, ostd ] = pooldata( y,std )
% y = [1,2,3,4]';
% std=[0,2,0,1]';

if(isempty(y))
    omean = 0;
    ostd  = 0;   
else
    x = [y, std];
    z  = sortrows(x,2); 
    idx   = find(z(:,2)==0);
    mean1 = median(z(idx,1));
    std1  = sqrt(var(z(idx,1)));
    z(idx,:)=[];
    z(end+1,1)  = mean1;
    z(end+1,2)  = std1;
    omean = z(1,1);
    ostd  = z(1,2);
%     z       = sortrows(z,2);
%     [a,b] = size(z);
%     if(b==1 ||(b>1 && z(1,2)~=0))
%         omean = z(1,1);
%         ostd  = z(1,2);
%     else
%         if(z(1,2)==0)
%             omean = z(2,1);
%             ostd  = z(2,2);    
%         end
%     end
end
end

