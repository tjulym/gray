function [Schedule ] = baseline_general( LLF, Y_rnd, W, varargin )

opt = propertylist2struct(varargin{:});
opt = set_defaults(opt,  'tol', 1e-3, 'display',0,'maxiter',2000, 'name','Not given','combb',0,'queue',[]);
m   = length(LLF);
k   = length(Y_rnd)+1;

if(~isempty(opt.queue))
    if(length(opt.queue.app_queue)~= length(opt.queue.W))
        error('Length of work and in the queue should be same as items in the queue.');
    end
    llf_extn = LLF(opt.queue.app_queue);
    work_extn = opt.queue.W;
    [~,b]  = sort(llf_extn); 
    W = work_extn(b);
    b = opt.queue.app_queue(b);
else
    [~,b]  = sort(LLF); 
    b(W(b)<opt.tol)=[];  
end
for i = 1:k;   
    if(opt.combb==0)
        sz = nchoosek(m,i);
    else
        sz = length(combbb(1:m,i));
    end
    schedule{i}      = zeros(sz,1); 
end

Schedule = set_defaults([],'name',opt.name,'work_done_total',sum(W),'work_done',W);
Wheel    = set_defaults([],'app_order',b,'work_rem',W,'time_baseline',0,'app_done',[]);
while(~isempty(Wheel.app_order) )
    %tic;length(Wheel.app_order)
    k               = min(k,length(Wheel.app_order));
    if(opt.combb==0)
        Structure = nchoosek(1:m,k);
    else
        Structure = combbb(1:m,k);
    end
    if k==1
        y = ones(m,1);
    else
        y = Y_rnd{k-1};
    end
    y(y<=opt.tol) = opt.tol;
    Wheel.app_group = Wheel.app_order([1:ceil(k/2),(end-floor(k/2)+1):end]);
    Wheel.work_indices = [1:ceil(k/2),(length(Wheel.app_order)-floor(k/2)+1):length(Wheel.app_order)];
    app_group_old   = Wheel.app_group;
    if(isempty(opt.queue))
        [Wheel,timee]   = run_wheel( Wheel, y,m,'combb',opt.combb )  ; % work for queuing has different relation
    else
        
        [Wheel,timee]   = run_wheel_queue( Wheel, y,m,'combb',opt.combb )  ; % work for queuing has different relation
    end
    indd = ismember(Structure,sort(app_group_old),'rows');
    schedule{k}(indd) = schedule{k}(indd) + timee;
    %toc
end

tmp = [];   
for i = 1:(length(Y_rnd)+1);  
    tmp = [tmp; schedule{i} ];
end
if(~isempty(opt.queue))
    work_condensed = zeros(m,1);
    for i = 1:m
        work_condensed(i) = sum(opt.queue.W(opt.queue.app_queue == i));
    end
    Schedule.work_done = work_condensed;
end
Schedule = set_defaults(Schedule,'time',Wheel.time_baseline,'schedule',...
                        tmp,'rate',Y_rnd);
% schedule_verifier(Schedule,'combb',1)
% Schedule.work_done
end

 function [Wheel, timee] = run_wheel(Wheel,y,m,varargin)
    k = length(Wheel.app_group);
    opt = propertylist2struct(varargin{:});
    opt = set_defaults(opt,  'combb',0);

    if(opt.combb==0)
        Structure = nchoosek(1:m,k);
    else
        Structure = combbb(1:m,k);
    end
    
    [q_sorted,tmp] = sort(Wheel.app_group);
    [~,q_order]    = sort(tmp);
    speed = y(ismember(Structure,q_sorted,'rows'),:); 
    speed = speed(q_order);
    
    time_group = Wheel.work_rem( Wheel.app_group )./speed';  
    timee      = min(time_group);
    Wheel.work_rem(Wheel.app_group) = Wheel.work_rem(Wheel.app_group) - timee* speed';
    
    % remove the apps which finishes 
    Wheel.work_rem(abs(Wheel.work_rem)<10^(-6))=0;
    app_done_index = find(Wheel.work_rem(Wheel.app_order)==0);
    
    app_done     = Wheel.app_order(app_done_index)';
    for itr=1:length(app_done_index)
        Wheel.app_group(Wheel.app_group==Wheel.app_order(app_done_index(itr))) = [];
    end
    Wheel.app_order(app_done_index)=[];
    Wheel.time_baseline = Wheel.time_baseline + timee;
    Wheel.app_done = app_done;
end
 function [Wheel, timee] = run_wheel_queue(Wheel,y,m,varargin)
    k = length(Wheel.app_group);
    opt = propertylist2struct(varargin{:});
    opt = set_defaults(opt,  'combb',0);

    if(opt.combb==0)
        Structure = nchoosek(1:m,k);
    else
        Structure = combbb(1:m,k);
    end
    
    [q_sorted,increasing_app_order] = sort(Wheel.app_group);
    [~,q_order]    = sort(increasing_app_order);
    speed = y(ismember(Structure,q_sorted,'rows'),:); 
    
%     increasing_app_order
%     
%     Wheel.work_rem'
%     Wheel.app_group
    %time_group = Wheel.work_rem( increasing_app_order )./speed';  
    tmp = Wheel.work_rem(Wheel.work_indices);
    time_group = tmp( increasing_app_order )./speed;  
    timee      = min(time_group);
    %Wheel.work_rem(increasing_app_order) = Wheel.work_rem(increasing_app_order) - timee* speed';
    tmp(increasing_app_order) = tmp(increasing_app_order) - timee* speed;
    %Wheel.work_rem(Wheel.work_indices) = tmp(increasing_app_order);
    Wheel.work_rem(Wheel.work_indices) = tmp;
%     fprintf('---\n');
%     Wheel.app_group(increasing_app_order)
%     speed
%     timee
    % remove the apps which finishes 
    Wheel.work_rem(abs(Wheel.work_rem)<10^(-6))=0;
    app_done_index = find(Wheel.work_rem==0);
    app_done     = Wheel.app_order(app_done_index)';
    Wheel.app_order(app_done_index)=[];
    Wheel.work_rem(app_done_index)=[];
    for itr=1:length(app_done_index)
        Wheel.app_group(Wheel.app_group==app_done(itr)) = [];
    end
    Wheel.time_baseline = Wheel.time_baseline + timee;
    %Wheel.app_done(end+1) = app_done;
    
end
