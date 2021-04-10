% baseline_general - Computes the baseline schedule where we sort applications based on
% LLF and the top and bottom are run together.
%
% Syntax
%  function [Schedule] = baseline_general2(LLF, Y_rnd, W, <opt>)
%
%  inputs:
%    LLF:   - vector with low level feature like memory, l3requests for each application
%    Y_rnd: - structure containing performance for pairs, triplets and so on
%    W:     - work that needs to be finished for each application
%    varargin: 
%        * verbose - display argument 0 or 1
%  output
%    Schedule - schedule output
% See also: schedule_cover, main_general

function [Schedule ] = baseline_general_combb( LLF, Y_rnd, W, varargin )

opt = propertylist2struct(varargin{:});
opt = set_defaults(opt,  'tol', 1e-3, 'display',0,'maxiter',2000, 'name','Not given');
 
m      = length(W);
[~,b]  = sort(LLF); 
k      = length(Y_rnd)+1;
b(W(b)<opt.tol)=[];

for i = 1:k;    
    schedule{i}      = zeros(length(combbb(1:m,i)),1); 
end

Schedule = set_defaults([],'name',opt.name,'work_done_total',sum(W),'work_done',W);
Wheel    = set_defaults([],'app_order',b,'work_rem',W,'time_baseline',0);

while(~isempty(Wheel.app_order) )
    k               = min(k,length(Wheel.app_order));
    Structure       = combbb(1:m,k);  
    if k==1
        y = ones(m,1);
    else
        y = Y_rnd{k-1};
    end
    Wheel.app_group = Wheel.app_order([1:ceil(k/2),(end-floor(k/2)+1):end]);
    app_group_old   = Wheel.app_group;
    [Wheel,timee]   = run_wheel( Wheel, y )  ;
    schedule{k}(ismember(Structure,sort(app_group_old),'rows')) = timee;
end

tmp = [];   
for i = 1:(length(Y_rnd)+1);  
    tmp = [tmp; schedule{i} ];
end
Schedule = set_defaults(Schedule,'time',Wheel.time_baseline,'schedule',...
                        tmp,'rate',Y_rnd);
%schedule_verifier( Schedule, W );
end

 function [Wheel, timee] = run_wheel(Wheel,y)
    m = length(Wheel.work_rem);
    k = length(Wheel.app_group);
    
    Structure   = combbb( 1:m,k);
    
    [q_sorted,tmp] = sort(Wheel.app_group);
    [~,q_order]    = sort(tmp);
    
    speed = y(ismember(Structure,q_sorted,'rows'),:); 
    speed = speed(q_order);
    
    time_group = Wheel.work_rem( Wheel.app_group )./speed';  
    timee      = min(time_group);
    Wheel.work_rem(Wheel.app_group) = Wheel.work_rem(Wheel.app_group) - timee* speed';
    
    % remove the apps which finishes 
    Wheel.work_rem(abs(Wheel.work_rem)<10^(-6))=0;
    app_done_tmp = find(Wheel.work_rem(Wheel.app_order)==0);
    
    app_done     = Wheel.app_order(app_done_tmp)';
    for itr=1:length(app_done_tmp)
        Wheel.app_group(Wheel.app_group==Wheel.app_order(app_done_tmp(itr))) = [];
    end
    Wheel.app_order(app_done_tmp)=[];
    Wheel.time_baseline = Wheel.time_baseline + timee;
    Wheel.app_done = app_done;
end
