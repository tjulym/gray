function [Perfest ] = PCAPLOT( Perf,varargin )
%plot performance
close all;
[s1,s2] = size(Perf);

if( isempty(varargin))
    k = 10; %default
else
    k = varargin{1}; 
end

%   plot principal components
close all;
[U,S,V] = svd(Perf,'econ');
figure(1);
for i = 1:s2   
    subplot(6,6,i);
    plot(U(:,i)); 
    xlim([1 s1]);
    ylim([-0.2 0.2]);
end
title('U');

figure(2);
for i = 1:s2
    subplot(6,6,i);
    plot(V(:,i)); 
end
title('V');

figure(3);
plot(diag(S));
title('S');

Perfest = U(:,1:k)*S(1:k,1:k)*V(:,1:k)';
for i = 1:s2
    accuracy(i) = accuracy_rss(Perf(:,i), Perfest(:,i));
end
figure(4);
plot(accuracy);
title('accuracy');

figure(5);
for i = 1:s2   
    subplot(6,6,i);
    plot(Perfest(:,i)); 
    xlim([1 s1]);    
end
title('Perf_est');
end

