
function Schedule = schedule_cover_controller(Yhat,Y,Yerror, W, varargin )
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
        Y_rnd = normrnd_sp(Y, Yerror);
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
