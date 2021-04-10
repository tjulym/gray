clearvars;  close all;   format bank;
addpath('../MatlabCommon/','../../packages/glmnet_matlab');
% Options
filename = Create_BM();
m   = length(filename);
k   = 4;
N   = 1;
FONTSIZE = 13;
plot_variance = @(x,lower,upper,color) set(fill([x,x(end:-1:1)],[upper,lower(end:-1:1)],color),'EdgeColor',color);

% Load data
for i = 1:(k-1)
    dat{i}    = loaddata_general_combb(i+1); 
    Xsummary{i} = dat{i}.xx(:,summary_vectors());
    %Y{i}      = min(dat{i}.yy,1); % editted
    Y{i}      = dat{i}.yy;
    X{i}      = dat{i}.xx;
    Yerror{i} = dat{i}.err;
end
%%
pp = 0.1:0.1:1;
%pp = 0.7;
% linear
for j = 1:N    
    timeTemp = tic;
    for i = 1:(k-1)
        for l = 1:length(pp)
            [Yhat_l{i,j,l},acc_est_l(i,j,l),acc_est_train_l(i,j,l) ,~ ,beta_l{i,j,l},fitt_l{i,j,l}] =...
                glmnet_new( X{i}, Y{i}, pp(l),'model','linear');
            fprintf('p = %5.2f, multi-%d, acc_est = %5.2f, acc_train = %5.2f \n',...
                    pp(l),i+1,acc_est_l(i,j,l),acc_est_train_l(i,j,l));
        end
    end
    fprintf('time = %5.2f \n',toc(timeTemp));
end

% quadratic
pp = 0.1:0.1:1;
for j = 1:N    
    timeTemp = tic;
    for i = 1:(k-1)
        for l = 1:length(pp)
            [Yhat_q{i,j,l},acc_est_q(i,j,l),acc_est_train_q(i,j,l) ,~ ,beta_q{i,j,l},fitt_q{i,j,l}] =...
                glmnet_new( X{i}, Y{i}, pp(l),'model','quadratic');
            fprintf('p = %5.2f, multi-%d, acc_est = %5.2f, acc_train = %5.2f \n',...
                    pp(l),i+1,acc_est_q(i,j,l),acc_est_train_q(i,j,l));
        end
    end
    fprintf('time = %5.2f \n',toc(timeTemp));
end

% oos
i=3;
test_app = sort(randsample(1:m,floor((1-p)*m)));
[a,b,c,d] = glmnet_new_oos( X{i}, Y{i}, 0.7,test_app,'model','quadratic');

[aa,bb,cc,dd,ee,ff]=glmnet_new( X{i}, Y{i}, 0.3,'model','quadratic');

% plot 1
acc_est = acc_est_q; acc_est_train = acc_est_train_q;
close all;
remove_ind = find(acc_est<=0);
acc_est(remove_ind)=0;acc_est_train(remove_ind)=0;
figure(1);

for i=1:4 
    subplot(1,4,i); hold on; threshold = 0.9;
    y1      = squeeze(acc_est(i,:,:)); y2      = squeeze(acc_est_train(i,:,:)); 
    ym1     = mean(y1,1);              ym2     = mean(y2,1); 
    margin1 = sqrt(var(y1,1));         margin2 = sqrt(var(y2,1));
    ind = find(ym2>= threshold,1);
     
    plot_variance(pp, ym1 - margin1, ym1 + margin1,[0.9 0.9 0]);
    plot_variance(pp, ym2 - margin2, ym2 + margin2,[0.9 0.9 0])
    h2 = plot(pp,ym1,'r','linewidth',2);
    h3 = plot(pp,ym2,'b','linewidth',2);
    ylim([0,1]);
   
    if(isempty(ind))
        hline(threshold);
        %vline(1);
        vline(1,'--k',['n = ',num2str(nchoosek(m,i+1))]);
        %text(1-0.1,-0.075,['n = ',num2str(nchoosek(m,i+1))]);
    else
        %hline(ym(ind)); 
        hline(threshold,'--k');    
        xx1 = pp(ind-1); xx2 = pp(ind); 
        yy1 = ym2(ind-1); yy2 = ym2(ind);
        w = (yy2 - threshold)/(yy2- yy1);
        xx = w*xx1 + (1-w)*xx2;
        vline(xx,'--k',['n = ',num2str(floor(xx*nchoosek(m,i+1)))]);
        %text(pp(ind)-0.1,-0.075,['n = ',num2str(floor(xx*nchoosek(m,i+1)))]);
    end
    title([num2str(i+1), '- Apps (','N = ',num2str(nchoosek(m,i+1)),')'],'fontsize',FONTSIZE);
    h4 = plot(0,0,'Color',[0.9 0.9 0]);
    set(gca,'YTick',0:0.1:1,'XTick',0:0.2:1,'fontsize',FONTSIZE);
    xlabel('Fraction of training samples');
    ylabel('Accuracy');
    %grid on;
    hold off;
end
legend([h2 h3 h4],{'Prediction on test data','Prediction on test and training data','1-Standard deviation'},...
    'Location','best');

%export_fig ../../osdi/figures/accuracy_boxcox_quadratic.pdf -transparent -painters

%% lasso vs ridge vs elastic net
N = 15;
alpha = [0,0.5,1];
pp = 0.7;
for j = 1:N    
    for i = 1:(k-1)
    timeTemp = tic;
        for l = 1:length(alpha)
            [Yhat{i,j,l},acc_est(i,j,l),acc_est_train(i,j,l) ,~ ,beta{i,j,l},fitt{i,j,l}] =...
                glmnet_new( X{i}, Y{i}, pp,'model','quadratic','alpha',alpha(l));
            fprintf('p = %5.2f, multi-%d, acc_est = %5.2f, acc_train = %5.2f, time =%5.2f \n',...
                    pp,i+1,acc_est(i,j,l),acc_est_train(i,j,l),toc(timeTemp));
        end
    end
end

for j = 1:N    
    for i = 1:(k-1)
    timeTemp = tic;
        for l = 1:length(alpha)
            [Yhat_l{i,j,l},acc_est_l(i,j,l),acc_est_train_l(i,j,l) ,~ ,beta_l{i,j,l},fitt_l{i,j,l}] =...
                glmnet_new( X{i}, Y{i}, pp,'alpha',alpha(l),'var_sel',1);
            %fprintf('p = %5.2f, multi-%d, acc_est = %5.2f, acc_train = %5.2f, time =%5.2f \n',...
             %       pp,i+1,acc_est(i,j,l),acc_est_train(i,j,l),toc(timeTemp));
        end
    end
end

for i = 1:(k-1)
    for l = 1:length(alpha)
        fprintf('i = %d, alpha = %5.2f, acc_est = %f\n',i+1,alpha(l),mean(acc_est(i,:,l)));
    end
end

acc_est(acc_est<0)=0; acc_est_l(acc_est_l<0)=0;
figure
for i = 1:(k-1)
    subplot(1,4,i);
    set(gca,'fontsize',FONTSIZE);
    %boxplot([squeeze(acc_est_l(i,:,:)),squeeze(acc_est(i,:,:))],'Labels',...
    %    {'Ridge','Enet','Lasso'},'Whisker',1)
    boxplot([squeeze(acc_est_l(i,:,:)),acc_est(i,:,2)'],'Whisker',1,...
    'Labels',{'Ridge-Lin','Enet-Lin','Lasso-Lin','Enet-Quad'});
   % set(gca,'ylim',[0 1])
    
    title([num2str(i+1),'- Apps']);
    
    ylabel('Accuracy');
end

%export_fig ../../osdi/figures/accuracy_boxplot_ridge_lasso_enet2.pdf -transparent -painters

%% plot variable in out
close all;N=1; k=2; pp=0.9;
for j = 1:N    
    timeTemp = tic;
    for i = (k-1):(k-1)
        for l = 1:length(pp)
            [Yhat_q{i,j,l},acc_est_q(i,j,l),acc_est_train_q(i,j,l) ,~ ,beta_q{i,j,l},fitt_q{i,j,l}] =...
                glmnet_new( X{i}, Y{i}, pp(l),'model','quadratic');
            fprintf('p = %5.2f, multi-%d, acc_est = %5.2f, acc_train = %5.2f \n',...
                    pp(l),i+1,acc_est_q(i,j,l),acc_est_train_q(i,j,l));
            f = fitt_q{i,j,1};    
            fit = options_genericLasso(f);
            h = subplot(1,1,1);lassoPlot2(f.glmnet_object.beta,fit, 'PlotType','Lambda','XScale','log','PredictorNames',f.PredictorNames,'Parent',h);
            pause;
            %lassoPlot(f.glmnet_object.beta,fit,'PlotType','CV','XScale','log')
        end
    end
    fprintf('time = %5.2f \n',toc(timeTemp));
end
%export_fig ../../osdi/figures/solution_path2.pdf -transparent -painters



%% 90%
%105+247+159+267 = 778.00
%778/(105+455+1365+3003)=          0.16
% 89%
%105+240+149+225= 719.00
%719/(105+455+1365+3003) =  0.15


for i = 1:(k-1);    
    ind{i} = find(beta{i}~=0)'; 
end
indices = unique([ind{1},ind{2},ind{3},ind{4},ind{5}]);
%indices = [2,26,37,41,84,94,136,175,183,195,273,288,321,364,365,367,395,398,400,417,440,442,445,452,464,473,483,484,485,597,608,621,650,706,764,804,813];
    
range = 1:length(indices);
close all; hold on;
i=1;scatter(range(beta{i}~=0),beta{i}(beta{i}~=0),'filled');
i=2;scatter(range(beta{i}~=0),beta{i}(beta{i}~=0),'k','filled');
i=3;scatter(range(beta{i}~=0),beta{i}(beta{i}~=0),'r','filled');
i=4;scatter(range(beta{i}~=0),beta{i}(beta{i}~=0),'g','filled');
i=5;scatter(range(beta{i}~=0),beta{i}(beta{i}~=0),'c','filled');
text(range-0.1,-0.25*ones(length(range),1),num2cell(indices))
legend('2','3','4','5','6');

plot(mean(squeeze(acc_est(4,:,:)),1));

%% print LLF important names
% for i = 1: 818
%     if(beta{1}(i)~=0 || beta{2}(i)~=0 || beta{3}(i)~=0 || beta{4}(i)~=0)
%         fprintf('%d : %s : %5.2f : %5.2f : %5.2f : %5.2f\n',i,...
%             llf_name(i),beta{1}(i),beta{2}(i),beta{3}(i),beta{4}(i));
%     end
% end

% print interaction terms
ind = [2,26,37,41,84,94,136,175,183,195,273,288,321,364,365,367,395,398,400,417,440,442,445,452,464,473,483,484,485,597,608,621,650,706,764,804,813];
ind2 = x2fx(ind,'quadratic');
interactionn = [0,0;nchoosek([0,ind],2);repmat(ind',1,2)];
% only non-zero beta
for i = 1: 741
    %if(beta{1}(i)~=0 || beta{2}(i)~=0 || beta{3}(i)~=0 || beta{4}(i)~=0 || beta{5}(i)~=0)
    if(abs(beta{1}(i))>0.1 || abs(beta{2}(i))>0.1 || abs(beta{3}(i))>0.1...
            || abs(beta{4}(i))>0.1 || abs(beta{5}(i))>0.1)
        fprintf('%d : %d : %d: %s : %s : %5.2f : %5.2f : %5.2f : %5.2f : %5.2f\n',...
                i, interactionn(i,1),interactionn(i,2), llf_name(interactionn(i,1)),...
                llf_name(interactionn(i,2)), beta{1}(i),beta{2}(i),beta{3}(i),beta{4}(i),beta{5}(i));
    end
end
 % all
for i = 1: 741
     label_beta_interaction{i} = [llf_name(interactionn(i,1)),' : ',llf_name(interactionn(i,2))];
 end

%% plot residue
for i = 1:(k-1)
    subplot(4,2,i);  
    residue = Yhat{i,1,end}(:)-Y{i}(:);
    scatter(Y{i}(:),residue,3);
    subplot(4,2,i+4); 
    qqplot(residue);
    %PlotCompare(Y{i}(:),Yhat{i,1,end}(:))
    %plot(ksdensity(residue,'bandwidth',0.01));
end


%% print quadratic for R
for i = 1:(k-1)
    x = X{i}; 
    y = Y{i};
    extn = ['multi-',num2str(i+1),'.x2fxq'];
    x_file       = ['../../tmp/X.',extn]; 
    y_file       = ['../../tmp/Y.',extn];  
    ind = [2,26,37,41,84,94,136,175,183,195,273,288,321,364,365,367,...
        395,398,400,417,440,442,445,452,464,473,483,484,485,597,608,621,650,706,764,804,813];
    unknown_ind=find(prod(y,2)==0)';
    unknown_ind_x = [];
    for i=1:size(y,2); 
        unknown_ind_x = [unknown_ind_x ,(unknown_ind + (i-1)*size(y,1)) ];
    end
    
    x = x2fx(x(:,ind),'quadratic');
    x(unknown_ind_x,:)=[]; 
    y(unknown_ind,:)=[];
    y = y(:);
    dlmwrite(x_file, x);
    dlmwrite(y_file, y);
end
%%

% ind2 = [804];
% for i = 1:(k-1);    X{i}(:,ind2)      = X{i}(:,ind2)/(i+1); end

% % Elapsed time is 0.354766 seconds.
% % p = 0.700000,multi- 2, acc_est = 0.781177, acc_train = 0.972336 
% % Elapsed time is 49.323336 seconds.
% % p = 0.500000,multi- 3, acc_est = 0.871784, acc_train = 0.943102 
% % Elapsed time is 34.978076 seconds.
% % p = 0.200000,multi- 4, acc_est = 0.940078, acc_train = 0.951291 
% % Elapsed time is 17.950619 seconds.
% % p = 0.200000,multi- 5, acc_est = 0.899087, acc_train = 0.919662 
% % 
% % Elapsed time is 0.232879 seconds.
% % p = 0.700000,multi- 2, acc_est = 0.218796, acc_train = 0.907148 
% % Elapsed time is 39.721532 seconds.
% % p = 0.500000,multi- 3, acc_est = 0.859416, acc_train = 0.937921 
% % Elapsed time is 22.459233 seconds.
% % p = 0.200000,multi- 4, acc_est = 0.941188, acc_train = 0.952578 
% % Elapsed time is 23.535291 seconds.
% % p = 0.200000,multi- 5, acc_est = 0.896794, acc_train = 0.922911
% % N = 0.7*105+0.5*455+1365*0.2+3003*0.2 = 1175 out of 4928 = 0.24% data
%  performance of cfd>4 {'cfd','particlefilter','svm_rfe'},{'cfd','particlefilter'} and {'cfd','svm_rfe'}
%% energy
% for i = 1:(k-1)
%     Xe{i}      = X{i}(1:nchoosek(m,i+1),1:409) + X{i}(1:nchoosek(m,i+1),410:818);
% end
% p = 0.5;
% 
% i = 4;
% remove_ind = isnan(zz);
% xx = Xe{i};     xx(remove_ind,:)=[];
% zz = Z{i}(:,1); zz(remove_ind)=[];
% [Zhat{i},acc_est_energy(i),acc_est_train_energy(i) ,~ ,beta_energy{i}] ...
%     =  glmnet_new( xx, zz, p);

% for i = 2:(k-1)
% [Zhat{i},acc_est_energy(i),acc_est_train_energy(i) ,~ ,beta_energy{i}] ...
%     =  glmnet_new( Xe{i}, Z{i}(:,1), p);
% end

% 56 % acc

%% concatenate
% yy = [Y{1}(:);Y{2}(:);Y{3}(:);Y{4}(:)];
% xx = [X{1};X{2};X{3};X{4}];
% [a,b,c,d,e] = glmnet_new( xx, yy, 0.5);
% close all;
% n = 1;
% for i = 1:4
%     np = n;
%     n = n+length(Y{i}(:));
%     subplot(2,2,i);PlotCompare(Y{i}(:),a(np:n-1));
% end
% 
% %%
% yy = [Y{1}(:);Y{2}(:);Y{3}(:);Y{4}(:)];
% xx = [X{1};X{2};X{3};X{4}];
% range = 1:length(yy);
% 
% remove_ind = find(yy==0);
% yy(remove_ind)=[]; 
% xx(remove_ind,:)=[];
% range(remove_ind)=[];
% ind = [2,26,37,41,84,94,136,175,183,195,273,288,321,364,365,367,395,398,400,417,440,442,445,452,464,473,483,484,485,597,608,621,650,706,764,804,813];
% xx  = x2fx(xx(:,ind),'quadratic');
% 
% %
% [n,m] = size(yy);
% p = 0.1;    
% 
% Sample_index = sort(randsample(1:n,floor((1-p)*n)));
% n = 1;
% for i = 1:4
%     np = n; n = n+length(Y{i}(:));
%     test_index{i}=Sample_index(find((Sample_index<n).*(Sample_index>np )==1));
% end
% 
% trainX = xx; trainX(Sample_index,:) = [];    testX = xx(Sample_index,:);    
% trainY = yy; trainY(Sample_index,:) = [];    testY = yy(Sample_index,:);
% 
% glmnet = {};
% CVerr  = cvglmnet(trainX,trainY,10,[],'response','gaussian',glmnetSet,0);    
% yhat   = glmnetPredict(CVerr.glmnet_object,'link', testX, CVerr.lambda_min);
% acc  =  accuracy_rss(testY, yhat )
% Yhat = glmnetPredict(CVerr.glmnet_object,'link', xx, CVerr.lambda_min);
% beta = sparse(CVerr.glmnet_object.beta(:,CVerr.lambda_min==CVerr.glmnet_object.lambda));
% 
% close all;
% for i = 1:4; 
%     subplot(2,2,i);PlotCompare(yy(test_index{i}),Yhat(test_index{i}));
% end
% 
% 
% %
% ind_x2fx_quadratic = find(beta~=0)';
% xx = xx(:,ind_x2fx_quadratic);



%%
for i = 1:(k-1)
%[a,b,c,d,e,f]=glmnet_new( X{i}, Y{i}, pp(l));
fit = options_genericLasso(fitt{i});
lassoPlot(f.glmnet_object.beta,fit,'PlotType','Lambda','XScale','log');
lassoPlot(f.glmnet_object.beta,fit,'PlotType','CV','XScale','log')

% subplot(2,k,i);
% cvglmnetPlot(f)
% subplot(2,k,i+k);
% glmnetPlot(f.glmnet_object, 'lambda', true);
%pause;
end

i = 5;
figure(i);
f = fitt{i};
subplot(2,k,1);   cvglmnetPlot(f);
subplot(2,k,2);   glmnetPlot(f.glmnet_object, 'lambda', true);

for i = 1:k
     
     subplot(2,k,i+k);qqplot(Y{4}(:));
     subplot(2,k,i);qqplot(boxcox(Y{4}(:)))
end



for i = 1:(k-1)
   
    f1 = fitt{i,1,1};
    f2 = fitt{i,1,2};
    f3 = fitt{i,1,3};
    subplot(3,1,1); glmnetPlot(f1.glmnet_object, 'lambda', true);
    subplot(3,1,2); glmnetPlot(f2.glmnet_object, 'lambda', true);
    subplot(3,1,3); glmnetPlot(f3.glmnet_object, 'lambda', true);
end


f = options_genericLasso(fitt{4,1,2});
lassoPlot(fitt{4,1,2}.glmnet_object.beta,f,'PlotType','Lambda','XScale','log',);

%
close all;
kk=6;
for l = 1:kk
f = fitt_q{l,1};
fit = options_genericLasso(f);
h = subplot(2,kk,l);lassoPlot2(f.glmnet_object.beta,fit,'PlotType','Lambda','XScale','log','PredictorNames',f.PredictorNames,'Parent',h);
h = subplot(2,kk,kk+l);lassoPlot2(f.glmnet_object.beta,fit,'PlotType','CV','XScale','log','Parent',h);
end
l=1;
f = fitt_q{l,1};    fit = options_genericLasso(f);
h = subplot(1,1,1);lassoPlot2(f.glmnet_object.beta,fit,'PlotType','Lambda','XScale','log','PredictorNames',f.PredictorNames,'Parent',h);
%h = subplot(2,1,2);lassoPlot2(f.glmnet_object.beta,fit,'PlotType','CV','XScale','log','Parent',h);
%%
% tmp = {'a','b','c','d','e','f','g'};
% index=0;
% for i = 1:15
%     for j= i:15
%         for k = j:15
%             %for l = k:15
%                
%                     %fprintf('%s,%s,%s\n',filename{i},filename{j},filename{k});%,filename{l});
%                     index = index+1;
%                 
%            % end
%         end
%     end
% end

%% spam
i = 3;[yhat, f] = spam_l1(Y{i}(:), X{i}, 1); % out of memory for i = 4
%%
%%
pp = 0.1:0.1:1;
%pp = 0.7;
% linear
fprintf('Summary--linear');
for j = 1:N    
    timeTemp = tic;
    for i = 1:(k-1)
        for l = 1:length(pp)
            [Yhat_l{i,j,l},acc_est_l(i,j,l),acc_est_train_l(i,j,l) ,~ ,beta_l{i,j,l},fitt_l{i,j,l}] =...
                glmnet_new( Xsummary{i}, Y{i}, pp(l),'model','linear','boxcox',0,'var_sel',0);
            fprintf('p = %5.2f, multi-%d, acc_est = %5.2f, acc_train = %5.2f \n',...
                    pp(l),i+1,acc_est_l(i,j,l),acc_est_train_l(i,j,l));
        end
    end
    fprintf('time = %5.2f \n',toc(timeTemp));
end

% quadratic

for i = 1:(k-1)
    Xsummary_quadratic{i} = x2fx( Xsummary{i},'interaction');
end
pp = 0.1:0.1:0.9;
fprintf('Summary--quadratic');
for j = 1:N    
    timeTemp = tic;
    for i = 1:(k-1)
        for l = 1:length(pp)
            [Yhat_q{i,j,l},acc_est_q(i,j,l),acc_est_train_q(i,j,l) ,~ ,beta_q{i,j,l},fitt_q{i,j,l}] =...
                glmnet_new( Xsummary_quadratic{i}, Y{i}, pp(l),'model','linear','boxcox',0,'var_sel',0);
            fprintf('p = %5.2f, multi-%d, acc_est = %5.2f, acc_train = %5.2f \n',...
                    pp(l),i+1,acc_est_q(i,j,l),acc_est_train_q(i,j,l));
        end
    end
    fprintf('time = %5.2f \n',toc(timeTemp));
end