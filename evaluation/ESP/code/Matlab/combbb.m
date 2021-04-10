function P = combbb(v,m)
%COMBS  All possible combinations.
%   COMBS(1:N,M) or COMBS(V,M) where V is a row vector of length N,
%   creates a matrix with N!/((N-M)! M!) rows and M columns containing
%   all possible combinations of N elements taken M at a time.
%
%   This function is only practical for situations where M is less
%   than about 15.
% 
% v = v(:).'; % Make sure v is a row vector.
% n = length(v);
% if n == m
%     P = v;
% elseif m == 1
%     P = v.';
% else
%     P = [];
%     if m < n && m > 1
%         for k = 1:n-m+1
%             Q = combbb(v(k:n),m-1);
%             P = [P; [v(ones(size(Q,1),1),k) Q]]; %#ok
%         end
%     end
% end
v = v(:).'; % Make sure v is a row vector.
n = length(v);
if m == 1
    P = v.';
else
    P = [];
    if m >= 1
        for k = 1:n
            Q = combbb(v(k:n),m-1);
            P = [P; [v(ones(size(Q,1),1),k) Q]]; %#ok
        end
    end
end
end