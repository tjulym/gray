% parallel scheduling with queue of jobs
% Example run:
% a) [ Output ] = singlenode_schedule(); % Function would run with default options.
% 
% b) [ Output ] = singlenode_schedule('k',4,'N',15,'display');
% Options:  k      - Maximum number of applications that can be scheduled together.
%           Nproc  - Number of processors
%           N      - Number of runs of the algorithm
%           Nqueue - Number of jobs in the queue
%           display- 0 to hide display, 1 to print output.
function [ Output ] = singlenode_schedule(varargin)
format bank;
addpath('../MatlabCommon/','../MatlabCommon/export_fig-master/','../../packages/glmnet_matlab');

filename = Create_BM();
m        = length(filename);
opt     = propertylist2struct(varargin{:});
opt     = set_defaults(opt,'display',1,'k',7,'N',1,'W',100*ones(m,1),'model','quadratic');
   
% Options
N           = opt.N;
k           = opt.k;
W           = opt.W;
% Load data
for i = 1:(k-1)
    dat{i}    = loaddata_general(i+1); 
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

for i = 1:N 
    main_itr_loop = tic;
    %% EST
    Y_rnd = normrnd_sp(Y, Yerror); 
    
    for j = 1:length(pp)   
        % Samples
        est_time_tic = tic;
        NumSamples = 0;
        for ii = 1:length(Y_rnd)
            p = pp(j);
            if(pp(j)~=1 && pp(j)~=0 ) 
                switch ii
                case 1
                    p = 0.7;
                case 2
                    p = 0.4;
                case 3
                    p = 0.1;
                case 4
                    p = 0.04;
                otherwise
                    p = 0.01;    
                end
            end
            NumSamples=NumSamples+p*size(Y_rnd{ii},1);
            [Yhat{ii},acc(ii),acc_est(ii) ,name,~,~ ] = glmnet_new( X{ii}, Y_rnd{ii}, p,'model',opt.model,'var_sel',0);
           if(opt.display==1)
                fprintf('p = %5.2f, multi-%d, acc_est = %5.2f, acc_train = %5.2f \n',...
                    p,ii+1,acc(ii),acc_est(ii));
            end
        end
        fprintf('p = %f\n',pp(j));
        fprintf('est_time = %f\n',toc(est_time_tic));
        lp_time_tic = tic;
        Schedule = schedule_cover_controller(Yhat,Y,Yerror, W ,'LLF',...
            MEM,'name',name,'display',0,'eta',3);   
        Output.EST{j}.sched = Schedule;  timee(i,j) = Schedule.time;
fprintf('lp_time = %f\n',toc(lp_time_tic));
    end
    Schedule = baseline_general( MEM,Y_rnd, W, 'name', 'MEM');
    Output.MEM.sched = Schedule;  timee(i,4) = Schedule.time;
    
    Schedule = baseline_general( IPC,Y_rnd, W, 'name', 'IPC');
    Output.IPC.sched = Schedule;   timee(i,5) = Schedule.time;
    
    Schedule = baseline_general( L3R,Y_rnd, W, 'name', 'L3R');
    Output.L3R.sched = Schedule;    timee(i,6) = Schedule.time;
    
    Schedule = baseline_general( randperm(m),Y_rnd, W, 'name','RND');
    Output.RND.sched = Schedule;    timee(i,7) = Schedule.time; 
    if(opt.display==1)
        fprintf('i = %d -- OPT = %.0f, EST = %.0f, MEM = %.0f, IPC = %.0f, L3R = %.0f, RND = %.0f \n',...
        i, timee(i,1),timee(i,2),timee(i,4),timee(i,5),timee(i,6),timee(i,7));
    end
       
    toc(main_itr_loop)
end
Output.timee = timee;
end