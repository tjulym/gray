function [Yhistory, Zhistory, BM] = loaddataharper()
%clear all; close all; format bank;

BM = {'blackscholes','bodytrack', 'cfd'      ,'fluidanimate','HOP',...
       'Jacobi'      ,'Kmeans'   , 'lud'      ,'nn'          ,'particlefilter', ...
       'PLSA'        ,'Scalparc' , 'swaptions','Swish'       ,'vips', ...
       'x264'        ,'apr'      , 'btree'    ,'semphy'      ,'streamcluster', ...
       'svmrfe'      ,'backprop' , 'bfs'      ,'Kmeansnf'    ,'filebound',...
       'dijkstra'    ,'STREAM' };
m = length(BM);
sep = filesep;
n = 1024;
% loaddata takes time
for i = 1:m
    benchMark = BM{i}; 
    filename{i} = benchMark;
%    file1 = strcat('..',sep,'shmoo_results',sep,'savedData',sep,'Mat',benchMark,'.txt');
    file2 = strcat('..',sep,'datafromharper',sep, benchMark, sep, benchMark,'32threads.results');
%    file1
    file2    
    %% Get Harper's data
    A = importdata( file2);
    [a,b] = size(A);
        % removing the on-chip power and energy
    
    if (b == 7)            
        A(:,5) = [];
    elseif (b == 8)
        A(:,5:6) = [];                
    end   
    Y(:,i) = A(1:n,4);
    Z(:,i) = A(1:n,5);   
end
Yhistory = Y;
Zhistory = Z;
end