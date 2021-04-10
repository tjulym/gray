function [ col ] = sched_color(varargin)
addpath('../MatlabCommon/');
opt     = propertylist2struct(varargin{:});
opt     = set_defaults(opt, 'color','BrBG');
col = brewermap(8,opt.color);
col([4],:)=[];
end

% col = [0.55          0.32          0.04
%           0.75          0.51          0.18
%           0.87          0.76          0.49
%           0.96          0.91          0.76
%           0.78          0.92          0.90
%           0.50          0.80          0.76
%           0.21          0.59          0.56
%           0.00          0.40          0.37];

