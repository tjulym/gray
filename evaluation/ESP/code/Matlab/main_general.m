%clear all hidden; % for biograph
clearvars;  close all;   format bank;
addpath('../MatlabCommon/','../MatlabCommon/export_fig-master/','../../packages/glmnet_matlab');

filename = Create_BM();

% Options
m   = length(filename);
N   = 15;
W   = 100*ones(m,1);
k   = 7;
plot_variance = @(x,lower,upper,color) set(fill([x,x(end:-1:1)],[upper,lower(end:-1:1)],color),'EdgeColor',color);

% Load data
for i = 1:(k-1)
    dat{i}    = loaddata_general(i+1); 
    Y{i}      = dat{i}.yy; Y{i}((find(Y{i}<=0))) = 0.0001;
    X{i}      = dat{i}.xx;
    Yerror{i} = dat{i}.err;
end

% Baseline in paper
xxraw     = load([tmp_path(),'X.raw']);
MEM       = sum(xxraw(:,443:444),2)'; 
IPC       = xxraw(:,434)';
L3HITRATE = xxraw(:,439)';            
L3MISS    = xxraw(:,437)';
L3R       = L3MISS./(1 - L3HITRATE);

%% glmnet Estimation method
fprintf('**************    Scheduling using glmnet Estimation method    **************\n');
pp = [1,0.5];
%acc_est   = zeros(N,length(pp),length(Y)); %test accuracy
%acc_train = acc_est;
y= Y;x=X;yerror=Yerror;
for l =1:(k-1)
    Y=y(1:l);
    X=x(1:l);
    Yerror=yerror(1:l);
    for i = 1:N 
        Y_rnd = normrnd_sp(Y, Yerror); 
        Schedule_MEM{i,l} = baseline_general( MEM,Y_rnd, W, 'name', 'MEM');
        Schedule_IPC{i,l} = baseline_general( IPC,Y_rnd, W, 'name', 'IPC');
        Schedule_L3R{i,l} = baseline_general( L3R,Y_rnd, W, 'name', 'L3R');
        Schedule_RND{i,l} = baseline_general( randperm(m),Y_rnd, W, 'name','RND');

        fprintf('-- MEM = %.0f, IPC = %.0f, L3R = %.0f, RND = %.0f \n',Schedule_MEM{i,l}.time,...
            Schedule_IPC{i,l}.time, Schedule_L3R{i,l}.time, Schedule_RND{i,l}.time);
       
        for j = 1:length(pp)   
            maintime = tic;
            NumSamples=0;
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
                [Yhat{ii},acc_est(i,j,ii),acc_est_train(i,j,ii) ,name ] = ...
                    glmnet_new( X{ii}, Y{ii}, p,'model','quadratic');
            end
            Schedule_EST{i,j,l} = schedule_cover_controller(Yhat,Y,Yerror, W ,'LLF',MEM,'name',name,'display',0);   
            Schedule_EST{i,j,l}.accuracy = squeeze(acc_est(i,j,:));
            Schedule_EST{i,j,l}.accuracy_train = squeeze(acc_est_train(i,j,:));
            fprintf('i = %d, j = %d, multi = %d, Acc = %5.2f, Sched time = %.0f, Work = %.0f, Time taken = %5.1f \n',...
                i, j, l+1,mean(acc_est(i,j,:),3),Schedule_EST{i,j,l}.time,Schedule_EST{i,j,l}.work_done_total,toc(maintime));
        end 
    end
end
