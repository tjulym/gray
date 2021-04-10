function [Yhat,acc,acc_train,name,beta,CVerr] = glmnet_new( X,Y,p,varargin)
%% glmnet
    %% seting defaults
    opt = propertylist2struct(varargin{:});
    opt = set_defaults(opt,  'model', 'linear', 'display',0,'var_sel',1, 'alpha',0.5,'boxcox',1,'plot',0);

    %%
    beta = [];CVerr = [];
    if(p==1)
        Yhat = Y;   acc  = 1;    acc_train=1;name   = 'ORACLE';
        CVerr.train_ind      = 1:size(Y,1);
        CVerr.test_ind       = [];
        return;
    elseif(p*length(Y)<30)
        Yhat = rand(size(Y)); name   = 'RND';acc = 0; acc_train=0; 
        CVerr.train_ind      = [];
        CVerr.test_ind       = 1:size(Y,1);
        return;
    else
        %name = ['EST-',num2str(p)];
        name = ['ESP'];
    end
    
    
    if(opt.boxcox == 1)
        Y((find(Y<=0))) = 0.0001; [tmp, lambda]= boxcox(Y(:));Y = reshape(tmp,size(Y));
    end
    if (strcmp(opt.model,'linear')==1)
        switch opt.var_sel
        case 0
            ind = 1:size(X,2);
        case 1
            ind = load([tmp_path(),'ind_x2fx_linear.txt']);
        otherwise
            error('variable selection for linear is only 1 or 0')
        end
        x = X(:,ind);
        for i = 1: length(ind)
             PredictorNames{i} = llf_name(ind(i));
        end
    elseif (strcmp(opt.model,'quadratic')==1)
        ind = load([tmp_path(),'ind_x2fx_linear.txt']);
        switch opt.var_sel
        case 0
            nn = length(ind);
            ind_x2fx_quadratic = 1:(1+2*nn+nn*(nn-1)/2);
        case 1
            ind_x2fx_quadratic = load([tmp_path(),'ind_x2fx_quadratic.txt']);
        otherwise
            error('variable selection for linear is only 1 or 0')
        end
        x = X(:,ind);   
        x = x2fx(x,opt.model); 
        x = x(:,ind_x2fx_quadratic);
        interactionn = [0,0;nchoosek([0,ind],2);repmat(ind',1,2)];
        for i = 1: size(interactionn,1)
            PredictorNames{i} = [llf_name(interactionn(i,1)),' : ',...
                                 llf_name(interactionn(i,2))];
        end
    else
        error('model type is not correct');
    end

    
    unknown_ind=find(prod(Y,2)==0)';
    unknown_ind_x = [];
    for i=1:size(Y,2); 
        unknown_ind_x = [unknown_ind_x ,(unknown_ind + (i-1)*size(Y,1)) ];
    end
    xtmphat = x;    x(unknown_ind_x,:)=[]; 
    y = Y;          y(unknown_ind,:)=[];

    %% Create training and testing samples
    [n,k] = size(y);    
    Sample_index = randsample(1:n,floor((1-p)*n));
    Sample_index_x = [];
    tmp = 1:n; tmp(Sample_index)=[];    train_ind=tmp; 
    for i=1:k;Sample_index_x = [Sample_index_x ,(Sample_index+(i-1)*n) ];end
         
    trainX = x; trainX(Sample_index_x,:) = [];  testX = x(Sample_index_x,:);    
    trainY = y; trainY(Sample_index,:) = [];    testY = y(Sample_index,:);
    
%     if(opt.boxcox == 1)
%         
%         %[tmp, lambda] = boxcox(trainY(:),0);
%         lambda=0; [tmp] = boxcox(trainY(:),0);
%         trainY        = reshape(tmp,size(trainY));
%         testY         = reshape(boxcox(testY(:),lambda),size(testY));
%         Y             = reshape(boxcox(Y(:),lambda)    ,size(Y));
%     end
    %% 
    option = glmnetSet;
    option.alpha = opt.alpha;
    modelling_time = tic;
    CVerr= cvglmnet(trainX,trainY(:),10,[],'response','gaussian',option,0);    
    modelling_time = toc(modelling_time);
    testing_time = tic;
    yhat = glmnetPredict(CVerr.glmnet_object,'link', testX, CVerr.lambda_min);
    fprintf('modelling time = %f, testing_time = %f\n',modelling_time, toc(testing_time));
    Yhat = glmnetPredict(CVerr.glmnet_object,'link', xtmphat, CVerr.lambda_min);
    yhat = reshape(yhat,size(testY));
    Yhat = reshape(Yhat,size(Y));
    
%     ytrain_hat = glmnetPredict(CVerr.glmnet_object,'link', trainX, CVerr.lambda_min);
%     
%     figure;hold on;plot(trainY(:),'r'); plot(ytrain_hat(:))
%     figure;hold on;plot(InverseBoxCox(trainY(:),lambda),'r'); plot(InverseBoxCox(ytrain_hat(:),lambda))
%     figure;hold on;plot(testY(:),'r'); plot(yhat(:))
%     figure;hold on;plot(InverseBoxCox(testY(:),lambda),'r'); plot(InverseBoxCox(yhat(:),lambda))
%     
    
    Yhat(train_ind,:)   = Y(train_ind,:);
    Yhat(unknown_ind,:) = Y(unknown_ind,:);
    if(opt.boxcox == 1)
        yhat  = InverseBoxCox(yhat,lambda);
        Yhat  = InverseBoxCox(Yhat,lambda);
        testY = InverseBoxCox(testY,lambda);
        Y     = InverseBoxCox(Y,lambda);
    end
    acc = accuracy_rss(testY, yhat, 'threshold',1 );   
    acc_train = accuracy_rss(Y,Yhat, 'threshold',1 );
%     acc = accuracy_rss(testY, yhat);   
%     acc_train = accuracy_rss(Y,Yhat );
    
    beta= CVerr.glmnet_object.beta(:,CVerr.lambda_1se==CVerr.glmnet_object.lambda); %beta
    if(opt.plot==1)
        f = CVerr;
        figure;
        subplot(2,1,1);
        cvglmnetPlot(f); 
        subplot(2,1,2);
        glmnetPlot(f.glmnet_object, 'lambda', true);
    end
    CVerr.PredictorNames = PredictorNames;
    CVerr.beta           = beta;
    CVerr.train_ind      = train_ind;
    CVerr.test_ind       = Sample_index;
end

function Z = InverseBoxCox(Y,lambda)
    if(lambda~=0)
        Z = exp(log(Y*lambda+1)/lambda);
        Z(imag(Z)~=0)=0;
    else
        Z = exp(Y);
        Z(imag(Z)~=0)=0;
    end
end

%ind = [2,26,37,41,84,94,136,175,183,195,273,288,321,364,365,367,395,398,400,417,440,442,445,452,464,473,483,484,485,597,608,621,650,706,764,804,813];