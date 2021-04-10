function [Yout, normalization] = normalize( Ymat, p)
  Ymat(Ymat==Inf) = NaN;
%   if(p~=0)
%     %type 1: feasible
%       Y = Y/Y(1); 
%       normalization = strcat('Y/Y(1)');
% 
%     %type 2: not-feasible, since min may not be known
%       Y = Y/min(Y); % type 2: not feasible
%       normalization = strcat('Y/min(Y)');
% 
%     %type 3: not-feasible, since min-max may not be known
%       Y = (Y - nanmin(Y));
%       Y = (Y*p)/nanmax(Y) + p;
%       normalization = strcat('p=',num2str(p));
%   else
%       normalization = '0';
%   end  

[n,m] = size(Ymat);
for i = 1:m
    Y = Ymat(:,i);
 switch p
    case 0
      normalization = '0';
    case -1
      %type 1: feasible
      Y = Y/Y(1); 
      normalization = strcat('Y/Y(1)');

    case -2
      %type 2: not-feasible, since min may not be known
      Y = Y/min(Y); % type 2: not feasible
      normalization = strcat('Y/min(Y)');
   
    otherwise
        %type 3: not-feasible, since min-max may not be known
      Y = (Y - nanmin(Y));
      Y = (Y*p)/nanmax(Y) + p;
	%Y = Y - mean(Y);
      normalization = strcat('mean,p=',num2str(p));
 end
 Yout(:,i) = Y;
end
end

