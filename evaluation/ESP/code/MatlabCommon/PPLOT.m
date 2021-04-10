function [ ] = PPLOT( Perf,filename,varargin )
%plot performance
close all;
[s1,s2] = size(Perf);

if( isempty(varargin))
    idx = 1:s2;
else
    idx = varargin{1}; 
end

if(length(varargin)==2)
    Confidence = varargin{2};
end


 for j = 1:numel(idx)
    i = idx(j);  
    subplot(ceil(length(idx)/6),6,j); 
    hold on;
    
    plot(Perf(:,i));
    
    title(filename{i});
    xlim([1 s1]);
    if(length(varargin)==2)
    plot(Perf(:,i) - Confidence(:,i),'k');
    plot(Perf(:,i) + Confidence(:,i),'k');
    end
    hold off;
 end


end

