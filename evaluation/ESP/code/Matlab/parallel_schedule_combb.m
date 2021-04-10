% parallel scheduling with queue of jobs
% Example run:
% a) [ Output ] = parallel_schedule_combb(); % Function would run with default options.
% 
% b) [ Output ] = parallel_schedule_combb('k',4,'Nproc',4,'N',1,'Nqueue',40,'display',0);
% Options:  k      - Maximum number of applications that can be scheduled together.
%           Nproc  - Number of processors
%           N      - Number of runs of the algorithm
%           Nqueue - Number of jobs in the queue
%           display- 0 to hide display, 1 to print output.
function [ Output ] = parallel_schedule_combb(varargin)
format bank;
addpath('../MatlabCommon/','../../packages/glmnet_matlab');
filename = Create_BM();
opt     = propertylist2struct(varargin{:});
opt     = set_defaults(opt, 'plot',0,'display',1,'combb',1,'k',4,'Nproc',4,'N',1,'Nqueue',40);
   
% Options
m           = length(filename);
N           = opt.N;
k           = opt.k;
Nqueue      = opt.Nqueue;
Nprocessors = opt.Nproc;

% Load data
for i = 1:(k-1)
    dat{i}    = loaddata_general_combb(i+1); 
    Y{i}      = dat{i}.yy;
    X{i}      = dat{i}.xx;
    Yerror{i} = dat{i}.err;
end

% Baseline in paper
[ MEM,IPC,L3R ] = activity_vectors();

%% glmnet Estimation method
fprintf('**************    Scheduling using glmnet Estimation method    **************\n');
pp = [1,0.7];
timee     = zeros(N,6);
if(opt.display==1)
    fprintf('i, queue_id -> [Proc-1, Proc-1-time, Proc-1-work-done-total], [...] ,[...], Time taken\n');             
end
for i = 1:N 
    main_itr_loop = tic;
    if(opt.display==1)
        fprintf('i -> %d\n',i);             
    end
    %% Initialize queque and work
    queue.app_queue = randi(m,1,Nqueue); 
    %queue.app_queue = 1*ones(1,Nqueue);
    %queue.app_queue = [10,2,6,2];
    %queue.app_queue = [9,13,12,4,10,3,3,8,8,6,7,15,15,14,10,3,12,8,3,6,4,1,2,13,9,2,8,2,7,11,14,2,6,8,2,6,13,6,7,15];
    queue.W = 100*ones(Nqueue,1);
    for ii = 1:length(Y); Y_rnd{ii} = max(normrnd(Y{ii},Yerror{ii}*2),0); end    
    RND = randperm(m);  
    %% ESP
    for j = 1:length(pp)   
        % Samples
        NumSamples = 0;
        for ii = 1:length(Y_rnd)
            p = pp(j);
            if(pp(j)~=1 && pp(j)~=0 ) 
                switch ii
                case 1
                    p = 0.7;
                case 2
                    p = 0.4;
                otherwise
                    p = 0.2;    
                end
            end
            NumSamples=NumSamples+p*size(Y_rnd{ii},1);
            [Yhat{ii},acc(ii),acc_est(ii) ,name,~,fitt ] = glmnet_new( X{ii}, Y{ii}, p,'model','linear','var_sel',1);
%             [Yhat{ii},acc_est_q(ii,j,i),acc_est_train_q(ii,j,l) ,~ ,~, fitt_q{ii,j,l}] =...
%                 glmnet_new( X{ii}, Y_rnd{ii}, p,'model','linear','boxcox',0,'var_sel',1);
             if(opt.display==1)
                fprintf('p = %5.2f, multi-%d, acc_est = %5.2f, acc_train = %5.2f \n',...
                    p,ii+1,acc(ii),acc_est(ii));
            end
        end
        
        [Schedule, progress] = sched_cover_multi( queue, Y_rnd, Yhat,Nprocessors, 'name',name,'LLF',MEM,'display',opt.display );
        Output.EST{j}.sched = Schedule; Output.EST{j}.progress = progress; timee(i,j) = max(progress(end,:));
    end
    %k = 3;namess = names(k,'combb',1);namess(find(sum(Y{k-1},2)==0),:)
    [Schedule, progress] = sched_cover_multi( queue, Y_rnd, [], Nprocessors, 'name','MEM','LLF',MEM,'display', opt.display);
    Output.MEM.sched = Schedule;    Output.MEM.progress = progress;     timee(i,3) = max(progress(end,:));
    %schedule_verifier(Schedule{1},'combb',1)
    
    [Schedule, progress] = sched_cover_multi( queue, Y_rnd, [], Nprocessors, 'name','IPC','LLF',IPC,'display', opt.display );
    Output.IPC.sched = Schedule;    Output.IPC.progress = progress;     timee(i,4) = max(progress(end,:));
    
    [Schedule, progress] = sched_cover_multi( queue, Y_rnd, [], Nprocessors, 'name','L3R','LLF',L3R,'display', opt.display );
    Output.L3R.sched = Schedule;    Output.L3R.progress = progress;     timee(i,5) = max(progress(end,:));
    
    [Schedule, progress] = sched_cover_multi( queue, Y_rnd, [], Nprocessors, 'name','RND','LLF',RND,'display', opt.display );
    Output.RND.sched = Schedule;    Output.RND.progress = progress;     timee(i,6) = max(progress(end,:)); 

    %%
    t1 = Output.EST{1}.progress';t2 = Output.EST{2}.progress';t3 = Output.MEM.progress';
    t4 = Output.IPC.progress';t5 = Output.L3R.progress'; t6 = Output.RND.progress';
    
    max_load(i,:,:)= [max(t1);max(t2);max(t3);max(t4);max(t5);max(t6)];
    load_imbalance(i,:,:) = [max(t1)-min(t1);max(t2)-min(t2);max(t3)-min(t3);...
                      max(t4)-min(t4);max(t5)-min(t5);max(t6)-min(t6)];
end
Output.timee = timee;
Output.max_load = max_load;
Output.load_imbalance = load_imbalance;
end


function [Schedule,progress] = sched_cover_multi( queue, Y_rnd, Yhat, Nprocessors, varargin )
    parTimeCover = tic;                      
    opt     = propertylist2struct(varargin{:});
    opt     = set_defaults(opt, 'display',0,'name','Not given','LLF',[]);
    filename= Create_BM();
    m       = length(filename);
    
    for k = 1: Nprocessors; 
        Schedule{k}.work_done = zeros(m,1); 
        Schedule{k}.queue.app_queue = [];
        Schedule{k}.queue.W = [];
    end
    
    for l = 1: length(queue.W)
          parTime = tic;  
        % choice for index
        % the one with minimum time so far, but its unrealistic since we do
        % not know the future scheduling time.
        
        if(strcmp(opt.name,'ESP') || strcmp(opt.name,'ORACLE'))
            % Find which mahcine gives the smallest schedule when we add
            % the application.
            for i = 1:Nprocessors
                % filter Yhat so that same app does not run in parallel on
                % the same machine. If we have 1 instance of app 9 to run on 
                % machine 1. It shouldn't run on machine 2,3 or 4 in parallel.
                % If only 1 job is present, you cannot spit it to run as 2
                % at a time, if only 2 instances are present, you cannot
                % run 3 jobs at a time.
                Wtmp = Schedule{i}.work_done;
                Wtmp(queue.app_queue(l)) = Wtmp(queue.app_queue(l))+ queue.W(l);
                Yhat2 = filterr(Yhat,queue.app_queue(1:l),m,length(Y_rnd)+1);
                Y_rnd2 = filterr(Y_rnd,queue.app_queue(1:l),m,length(Y_rnd)+1);
                if(~isempty(opt.LLF))
                    Schedule_tmpp{i} = schedule_cover_controller(Yhat2, Y_rnd2, Wtmp ,'LLF',opt.LLF,'name',opt.name,'combb',1,'display',0);  
                else
                    Schedule_tmpp{i} = schedule_cover_controller(Yhat2, Y_rnd2, Wtmp ,'name',opt.name,'combb',1,'display',0); 
                end
                estimated_sched_time(i) = Schedule_tmpp{i}.time;
            end
            index = find(estimated_sched_time == min(estimated_sched_time),1);
            Wtmp = Schedule{index}.work_done;
            Wtmp(queue.app_queue(l)) = Wtmp(queue.app_queue(l))+ queue.W(l);
            Schedule_tmp = Schedule_tmpp{index};
        else
            index = mod(l,Nprocessors)+1;
            Wtmp = Schedule{index}.work_done;
            Wtmp(queue.app_queue(l)) = Wtmp(queue.app_queue(l))+ queue.W(l);
            %Y_rnd2 = filterr(Y_rnd,queue.app_queue(1:l),m,length(Y_rnd)+1);
            queue_reduced.app_queue = [Schedule{index}.queue.app_queue, queue.app_queue(l)];
            queue_reduced.W = [Schedule{index}.queue.W,queue.W(l)];
            Schedule_tmp = baseline_general( opt.LLF,Y_rnd, Wtmp, 'name',...
                opt.name,'combb',1,'queue',queue_reduced);
            Schedule{index}.queue = queue_reduced;
        end
                
        %%
        Schedule{index}.work_done       = Wtmp;
        Schedule{index}.time            = Schedule_tmp.time;
        Schedule{index}.schedule        = Schedule_tmp.schedule;
        Schedule{index}.work_done_total = sum(Wtmp);
        Schedule{index}.rate            = Y_rnd;
        Schedule{index}.name            = opt.name;
        
        for k = 1: Nprocessors
            if(k<=length(Schedule))
                if(isfield(Schedule{k},'time'))
                    progress(l,k)=Schedule{k}.time;
                else
                    progress(l,k)=0;
                end
            end
        end
        if(opt.display==1)
            fprintf('%d, %d -> , ',l,queue.app_queue(l));
            for k = 1: Nprocessors
                schedule_verifier(Schedule{k},'combb',1);
                if(k<=length(Schedule))
                    if(isfield(Schedule{k},'time'))
                        fprintf('[%d, %5.2f, %5.2f ], ',k, Schedule{k}.time, Schedule{k}.work_done_total);
                    end
                end   
            end
            fprintf('time = %5.2f\n',toc(parTime));
        end 
        
    end
    if(opt.display==1)
        fprintf('\n--done. name = %s, time = %f \n',opt.name,max(progress(end,:)),toc(parTimeCover));
    end
end


function Schedule = schedule_cover_controller(Yhat,Y_rnd, W, varargin )
    opt = propertylist2struct(varargin{:});
    opt = set_defaults(opt,  'tol', 1e-6,'tol2', 5, 'display',0,'eta',5,...
                       'maxiter',15, 'name','Not given','LLF',[],'draw',0,'combb',0);   
    
    eta   = opt.eta;
    itr   = 1;
    y     = 0;      
    m     = length(W);    
    work_rem  = W;
    work_sent = work_rem/eta;
    work_done_all = zeros(m,1);   
    schedule_time = tic;
    % this condition says that since its expensive to run LP if the amount
    % of work to be done is small just to baseline
    while(((~isempty(opt.LLF) && max(work_rem) > opt.tol2)||(max(work_rem) > opt.tol)) ...
            && itr < opt.maxiter)
        
        [inner_y, ~,~,~,work_output] = schedule_risk( Yhat,Y_rnd,work_sent,opt );
        Yhat      = update_Y( Yhat,Y_rnd, inner_y ,m,opt);
        work_rem  = max(work_rem-work_output,0);
        work_sent = work_rem/eta;
        y         = y     + inner_y; %schedule 
        itr       = itr + 1;
        work_done_all = work_done_all + work_output;
        if(opt.display==1)
            fprintf('work_rem =|%5.1f| %s\n---\n',sum(work_rem),sprintf('%5.1f ', work_rem)); 
        end
        if(sum(work_done_all)>10000)
            debughandle = 1;
        end
    end
    
    if(~isempty(opt.LLF) && max(work_rem) > opt.tol)
        if(opt.display==1)
            fprintf('Remaining work by baseline, ');
            fprintf('work rem = %f\n',max(work_rem));
        end
        if(opt.combb==0)
            sched = baseline_general( opt.LLF,Y_rnd, work_rem );
        else
            sched = baseline_general( opt.LLF,Y_rnd, work_rem,'combb',1 );
        end
        y     = y     + sched.schedule; %schedule 
        work_done_all = work_done_all + work_rem;
    end
    Schedule = set_defaults([],'time',sum(y),'schedule', y,'rate',Y_rnd,'name',opt.name,...
        'work_done_total',sum(work_done_all),'rate_assumed',Yhat,'work_done',work_done_all);
    
    if(opt.display==1)
        % may not perfectly work because rate assumed is different
        schedule_verifier( Schedule, 'combb',opt.combb ); 
        
        %Schedule
        fprintf('Time taken = %5.2f \n',toc(schedule_time));
    end
    if(opt.draw==1)
        drawSchedule_general( Schedule );
    end
end
function Yhat = update_Y( Yhat, Y_rnd,inner_y,m,varargin )
sched = inner_y;
sched(1:m)=[];
opt = propertylist2struct(varargin{:});
opt = set_defaults(opt, 'tol',1e-3, 'display',0,'combb',0); 
for i = 1:length(Yhat)
    if(opt.combb==0)
        sched_tmp = sched(1:nchoosek(m,i+1));
        sched(1:nchoosek(m,i+1))=[];
    else
        sched_tmp = sched(1:combbb(m,i+1));
        sched(1:length(sched_tmp))=[];
    end
    index = find(sched_tmp~=0);
    Yhat{i}(index,:) = Y_rnd{i}(index,:);
end
end
function [y,work_rem,Ahat,A,work_output] = schedule_risk( Yhat,Y,W,varargin )

% Linear program to schedule
% Input: 
%    R   : [mm,k] Original performance 
%    Rhat: [mm,k] Estimated performance
%    W   : [m,1]  Work to be finished     
% Output:
%    y   : Time for each group
%    work_rem: Remaining work
%lambda = 1;
opt = propertylist2struct(varargin{:});
opt = set_defaults(opt, 'tol',1e-3, 'display',0,'combb',0); 

if(length(Yhat)~=length(Y))
    error('Inputs have different sizes.')
else
    [m,~]= size(W);   % m in the number of applications
    Ahat = eye(m);
    A    = eye(m);
    S = zeros(1,m);
    for itr = 1:length(Y)
        R    = Y{itr};
        Rhat = Yhat{itr};
        [mm,k] = size(R); % k is the number of apps in group
        B      = zeros(m,mm);% mm is the number of groups
        Bhat   = zeros(m,mm);
        
        if((opt.combb==0 && mm~=nchoosek(m,k))||( opt.combb==1 && mm~=length(combbb(1:m,k))))
            error('Matrix dimensions of input matrix are not right. m=%d,mm=%d,k=%d',m,mm,k);
            exit(1);
        end
        if(opt.combb==0)
            temp = nchoosek( 1:m,k);
        else
            temp = combbb( 1:m,k);
        end
        % Transformation for the performance
        for i = 1:m
            for j = 1:k
                [index,~] = find(temp(:,j)==i);
                %index
                Bhat(i,index) = Rhat(index,j);
                B(i,index)    = R(index,j);
            end
        end
        Ahat = [Ahat,Bhat];
        A    = [A,B];
        
    end
    [~,mmm] = size(A);
    
    options = optimoptions('linprog','Display','off');
    y = linprog(ones(mmm,1),[],[],sparse(Ahat),W,zeros(mmm,1),[],[],options);
    %y = linprog(ones(mmm,1),-sparse(Ahat),-W,[],[],zeros(mmm,1),[],[],options);
   
    y(y<opt.tol)=0; % Some thresholding since we should have only m non zeros
    work_output = A*y;
 %   work_output
    work_rem    = max(W - work_output,0);  
    
    if(opt.display==1);
        fprintf('work_sent =|%5.1f| %s\n',sum(W),sprintf('%5.1f ', W));
        %fprintf('work_rem =|%5.1f| %s\n---\n',sum(work_rem),sprintf('%5.1f ', work_rem));        
            %work_est = repmat(y,1,2).*[ones(m,2);Y{1}]; 
            %fprintf('Inner time = %f,  work_input = %f, work_output = %f, \n',...
            %         sum(y), sum(W), sum(work_output));
    end   
end
end


