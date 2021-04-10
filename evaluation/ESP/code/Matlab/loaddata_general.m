function [dat ]  = loaddata_general(kk)    
%     % load data for quadruples
%     % Input: []  
%     % Output: dat
%     %    dat.xx    :[m choose k,k* (# low-level-features)]. predictor X
%     %    dat.yy    :[m choose k,k ]: Y
%     %    dat.err   :[m choose k,k ]: Standard deviation for the ratio
%     % where, 
%     %    m is the number of applications,
%     %    k is the number of applications in the group.
%     % Note, for k=1: its just actual performance since ratio is just 1.
%     %%

    %% Cache recording 
    extn = ['multi-',num2str(kk)];
    matlab_file  = [tmp_path(),'dat-',extn,'.mat'];        
    dat = load(matlab_file);
    dat = dat.dat;
    fprintf('Done %s.\n',extn);
end
