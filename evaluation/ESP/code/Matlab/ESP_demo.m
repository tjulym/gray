% Options
clear; close all; format bank;
filename = Create_BM();
m   = length(filename);
k   = 7;
N   = 1;
FONTSIZE = 13;
plot_variance = @(x,lower,upper,color) set(fill([x,x(end:-1:1)],[upper,lower(end:-1:1)],color),'EdgeColor',color);

% Load data
for i = 1:(k-1)
    dat{i}    = loaddata_general(i+1); 
    Y{i}      = dat{i}.yy;
    X{i}      = dat{i}.xx;
    Z{i}      = dat{i}.zz;
    Yerror{i} = dat{i}.err;
end

%%
%pp = 0.1:0.1:1;
pp = 0.7;
% linear
fprintf('Linear model');
for j = 1:N    
    timeTemp = tic;
    for i = 1:(k-1)
        for l = 1:length(pp)
            [Yhat_l{i,j,l},acc_est_l(i,j,l),acc_est_train_l(i,j,l) ,~ ,beta_l{i,j,l},fitt_l{i,j,l}] =...
                glmnet_new( X{i}, Y{i}, pp(l),'model','linear','boxcox',0);
            fprintf('p = %5.2f, multi-%d, acc_est = %5.2f, acc_train = %5.2f \n',...
                    pp(l),i+1,acc_est_l(i,j,l),acc_est_train_l(i,j,l));
        end
    end
    fprintf('time = %5.2f \n',toc(timeTemp));
end

% quadratic
fprintf('Quadratic model');
%pp = 0.1:0.1:1;
for j = 1:N    
    timeTemp = tic;
    for i = 1:(k-1)
        for l = 1:length(pp)
            [Yhat_q{i,j,l},acc_est_q(i,j,l),acc_est_train_q(i,j,l) ,~ ,beta_q{i,j,l},fitt_q{i,j,l}] =...
                glmnet_new( X{i}, Y{i}, pp(l),'model','quadratic','boxcox',0);
            fprintf('p = %5.2f, multi-%d, acc_est = %5.2f, acc_train = %5.2f \n',...
                    pp(l),i+1,acc_est_q(i,j,l),acc_est_train_q(i,j,l));
        end
    end
    fprintf('time = %5.2f \n',toc(timeTemp));
end
