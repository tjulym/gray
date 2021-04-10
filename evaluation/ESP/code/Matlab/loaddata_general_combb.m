function [dat ]  = loaddata_general_combb(kk)    
    % load data for quadruples
    % Input: []  
    % Output:
    %    X         :[m choose k,k* (# low-level-features)]. predictor X
    %    Y         :[m choose k,k ]: Y
    %    Ratio_err :[m choose k,k ]: Standard deviation for the ratio
    % where, 
    %    m is the number of applications,
    %    k is the number of applications in the group.
    % Note, for k=1: its just actual performance since ratio is just 1.
    %%
%     switch kk
%     case 1
%         global_ind = [7];  global_wt  = [8];   
%     case 2
%         global_ind = [8,17];  global_wt  = [9,18];
%     case 3
%         global_ind = [9,18,27];  global_wt  = [10,19,28];
%     case 4
%         global_ind = [10,19,28,37]; global_wt  = [11,20,29,38];
%     case num2cell(5:15)
%         global_ind = [10:10:(10+10*(kk-1))]; global_wt = [12:10:(10+10*(kk-1))];
%     otherwise
%         disp('Input is not a valid number')
%         return
%     end
    
    
    %% Cache recording 
    extn = ['multi-',num2str(kk),'-combb'];
%     summary_file = ['../../tmp/mat.',extn];        b1 = exist(summary_file, 'file');
%     x_file       = ['../../tmp/X.',extn];          b2 = exist(x_file, 'file');
%     y_file       = ['../../tmp/Y.',extn];          b3 = exist(y_file, 'file');
%     r_file       = ['../../tmp/Ratio_err.',extn];  b4 = exist(r_file, 'file');
    matlab_file  = [tmp_path(),'dat-',extn,'.mat']; 
%     b5 = exist(matlab_file, 'file');
%     z_file       = ['../../tmp/Z.',extn];          b6 = exist(y_file, 'file');
%     if(~b1||~b2||~b3||~b4||~b5||~b6)
%         mat = Create_Rapl( global_ind, global_wt);
%         [ xx, yy, err ] =  Create_X_Y( mat(:,global_ind),sqrt(mat(:,global_wt)));
%         %
%         yy(yy<0)=0;
%         err(err<0)=0;
%         if(kk>=2)
%             
%             yy(yy>5)=0;
%             err(err>5)=0;
%         end
%         %err(isnan(err))=0;
%         dat.xx  = xx;
%         dat.yy  = yy;
%         dat.zz  = [mat(:,end-4),mat(:,end-3)];
%         dat.err = err;
%         % Write
%         dlmwrite(summary_file, mat);
%         dlmwrite(x_file, xx);
%         dlmwrite(y_file, yy(:));
%         dlmwrite(z_file, dat.zz);
%         dlmwrite(r_file, err);
%         save(matlab_file,'dat');
%     else
        dat = load(matlab_file);
        dat = dat.dat;
%     end
    fprintf('Done %s.\n',extn);
end
% function [ mat ] = Create_Rapl( global_ind, global_wt)
%     % Summarize individual Rapl files to remove outlier
% 
%     BM   = Create_BM();
%     m    = length(BM);
%     k    = size(global_ind,2);
%     temp = combbb( 1:m,k);
%     n    = length(temp);
%     numcols = global_wt(end)+11; % remains same
%     mat  = zeros(n,numcols);
%     
%     global_ind_combb = [7:10:(10+10*(k-1))]; global_wt_combb = [8:10:(12+10*(k-1))];
%     for i = 1:n
%         benchMark = BM{temp(i,1)};
%         for j = 1:(k-1);
%             benchMark = [benchMark,'_',BM{temp(i,j+1)}];
%         end
%         %benchMark = ['blackscholes_cfd_cfd_HOP'];
%         filename = strcat('../../data/dataclover_general/',benchMark,'/Raplmulti.results');
%         %fprintf('-------------------> App: %s\n',benchMark  );
%         fmt = repmat('%f',1,numcols);
%         if(exist(filename,'file'))
%             fid = fopen(filename, 'rt');
%             indata = textscan(fid, fmt, 'Delimiter', ' ', 'TreatAsEmpty', 'NA', 'CollectOutput', 1);
%             fclose(fid);
%             line = indata{1,1};line(line<0)=NaN;
%             %line(any(isnan(line(:,[global_ind_combb,global_wt_combb])),2),:) = [];
%             line(line(:,1)~=1024,:)=[];
%             
%             nrows = size(line,1);
%             if(length(unique(temp(i,:))) ~= length(temp(i,:)))
%                 global_ind_use = global_ind_combb;  global_wt_use = global_wt_combb;
%             else
%                 global_ind_use = global_ind;  global_wt_use = global_wt;% small bug fix later
%             end
%             [ tmp_perf,tmp_var ] = pool( line(:,global_ind_use), line(:,global_wt_use));
%             line = nanmedian(line,1); 
%             
%             line(global_ind) = tmp_perf;      
%             line(global_wt)  = tmp_var;
%             line(global_wt+6)  = nrows*ones(size(global_wt));
%             mat(i,:)  = line;
%             debughold=1;
%         end
%     end
% end
% 
% function [ omean,ovar ] = pool( global_ind, global_wt )
% %Pool data
% global_ind(global_ind<0)=NaN;
% global_wt(global_wt<0)=NaN;
% omean = nanmedian(global_ind,1);
% ovar  = nanmin(sqrt(nanvar(global_ind,1)), 1.483*mad(nanvar(global_ind,1))).^2;
% if(sum(ovar)==0)
%     ovar =global_wt(1,:);
% end
% %n = size(global_int,1); % number of data points
% %weights = 1./global_wt;
% %omean   = nansum(global_int.*weights,1)./sum(weights,1);
% 
%  %ovar    = sum(std_tmp.^2,1)/n^2;
%  if(isempty(global_ind))
%      omean=zeros(size(global_ind));
%      ovar=zeros(size(global_wt));
%  end
%   if(isempty(global_wt))
%      ovar=zeros(size(global_wt));
%  end
% end
% 
% function [ X,Y,Ratio_err ] = Create_X_Y( perf, STdev )
%  
% k    = size(perf,2);
% if(k==1)
%     
%     Y         = perf;
%     Ratio_err = STdev;
%     BM        = Create_BM();
%     X = [];
%     m = length(BM);
%     for i = 1:m
%         % LLF
%         benchMark = BM{i};
%         file      = strcat('../../tmp/dataLLF_summarized/',benchMark,'.txt');  
%         LLF       = [importdata(file)];
%         X(i,:) = LLF(1024,:); 
%     end
%     dlmwrite('../../tmp/X.raw', X);
%     X(:,max(X) == min(X)) = [];  % All columns which have repeated entries
%     X = X./repmat(max(X),m,1);
%     return;
% end
% dat = loaddata_general_combb(1);
% 
% Single_LLF = dat.xx;
% Single_perf = dat.yy;
% Single_STdev = dat.err;
% m    = length(Single_perf);
% temp = combbb( 1:m,k);
% perf(isnan(perf)) = 0 ;
% muR = perf;
% muS = Single_perf(temp);
% sigmaR = STdev;
% sigmaS = Single_STdev(temp);
% covRS  = 0;
% %
% Y = muR./muS - covRS./(muS.^2)+ ((sigmaS).^2.*muR)./(muS.^3);
% t1  = size(temp,1);
% t2 = size(Single_LLF,2);
% X = [];
% for j=1:k
%     Xtmp = zeros(t1,t2);
%     for i = 1:k;    
%         if(i~=j)
%             Xtmp = Xtmp + Single_LLF(temp(:,i),:); 
%         end
%     end
%     X=[X;[Single_LLF(temp(:,j),:),Xtmp]];
% end
% 
% % Error    % Standard deviation of ratio for R and S is given by,
%     % Standard_devation = (mu_R/mu_S)sqrt(sigma_R^2/mu_R^2 + sigma_S^2/mu_S^2);
% Ratio_err = (muR./muS).*sqrt( sigmaR.^2./muS.^2 -2*((covRS)./(muR.*muS))  +sigmaS.^2./muS.^2);
% 
% end
