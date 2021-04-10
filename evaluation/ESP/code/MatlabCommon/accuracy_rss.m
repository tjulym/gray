function [ error ] = accuracy_rss( x,y,varargin )
    opt = propertylist2struct(varargin{:});
    opt = set_defaults(opt, 'threshold',inf); 
    x = min(x(:),opt.threshold);
    y = min(y(:),opt.threshold);
    if(length(x)~=length(y))
        disp('Error lengths not equal');        
    else
        residual = x-y;
        n = length(x);
        rss = nansum(residual.*residual); 
        tss = nansum((x-nanmean(x)).*(x-nanmean(x)));
        residualsquare = 1-rss/tss;
        
        error = 1-(1-residualsquare)*(n-1)/(n-2);
    end
end

