addpath('../MatlabCommon/','../../packages/glmnet_matlab','../../packages/export_fig-master/');
% main_general bar
P = [919.6290552	842.3223978	819.6922137	819.6905389	809.8597499	797.4485601
923.2111038	847.2887573	839.2792362	861.401456	856.5683434	849.1215588
1137.885599	1076.573042	1050.671923	1110.548347	1086.788922	1087.227282
1279.210701	1154.837947	1067.891486	1056.69494	1120.879481	1097.811661
1160.185936	1151.979145	1045.278974	1093.746364	1101.473739	1115.342575
1214.197675	1075.380995	1092.883667	1060.257285	1063.927558	1080.659665
];
Q = [12.93781016	2.276069631	3.645294057	4.923625872	3.596345359	2.648717133
15.53176832	2.449020385	8.369980913	19.34110726	13.29979947	19.39780402
3.418018207	27.98947425	6.044170507	13.31413227	2.880364939	7.521630742
24.42978958	8.39582505	8.840669874	7.50615631	6.000832868	6.350520097
3.680822518	6.945830578	5.903815738	12.94164166	6.573141257	4.338611144
74.1869792	84.28302639	27.88734842	49.64592195	44.70875654	37.51063648
];
close all;
A = P(:,1:5);
B = Q(:,1:5);
barweb(A',B',[],num2cell(2:6),[], [], [],   sched_color('color','RdBu'));
set(gca,'fontsize',17);
legend({'ORACLE', 'COAPE', 'MEM','IPC','L3R','RND'},'orientation','horizontal');
xlabel('Maximum co-scheduling group size');ylabel('Scheduling Time (in seconds)');
grid on;
%export_fig ../../osdi/figures/barmain.pdf -transparent -painters
% Numbers
clear oracle_est comp_est
comp_est   = 100*(A - repmat(A(2,:),size(A,1),1))./repmat(A(2,:),size(A,1),1);
oracle_est = 100*(A(2,:) - A(1,:))./A(1,:);
%     
% comp_est =
% 
%          -0.39         -0.59         -2.33         -4.84         -5.45         -6.09
%              0             0             0             0             0             0
%          23.25         27.06         25.19         28.92         26.88         28.04
%          38.56         36.30         27.24         22.67         30.86         29.29
%          25.67         35.96         24.54         26.97         28.59         31.35
%          31.52         26.92         30.22         23.09         24.21         27.27
% oracle_est =
% 
%           0.39          0.59          2.39          5.09          5.77          6.48
%% parallel_schedule_combb bar
P = [1299.24	851.2	656.46	1115.39	787.16	580.12	1073.5	658.78	499.16
1299.24	851.2	656.46	1162.33	822.66	628.51	1208.23	801.17	592.06
1677.65	1164.49	949.52	1570.58	1158.55	836.51	1673.59	1129.01	838.25
1650.09	1123.77	951.47	1515.64	1153.19	831.09	1656.34	1137.14	827.46
1693.61	1166.6	936.43	1540.24	1143.06	843.9	1597.41	1133.75	826.81
1661.17	1163.24	934.67	1550.44	1144.07	867.13	1613.4	1125.73	821.92
];
Q = [136.16	65.7	30.13	100.61	82.85	42.46	244.74	152.61	70.26
136.16	65.7	30.13	97.7	72.52	37.81	136.76	117.94	67.07
80.22	83.43	123.09	112.58	120.74	96.36	119.24	143.08	68.04
85.7	68.64	137.41	131.4	148.43	90.9	128.68	144.33	89.3
136.47	59.76	121.38	143.41	104.91	87.33	156.36	124.83	73.85
148.63	83.83	116.47	92.26	102.26	71.62	171.97	140.47	78.54
];
close all;
for i = 1:3
subplot(1,3,i);
A = P(:,(1+3*(i-1)):(3*i));
B = Q(:,(1+3*(i-1)):(3*i));
barweb(A',B',[],num2cell(2:4),[], [], [],   sched_color('color','RdBu'));
set(gca,'fontsize',13);
legend({'ORACLE', 'COAPE', 'MEM','IPC','L3R','RND'});
xlabel('Maximum permissible group size');
ylabel('Scheduling Time (in seconds)');
title([num2str(i+1),'-processors']);
ylim([0,1850]);
grid on;
end
%export_fig ../../osdi/figures/parallel_schedule_combb_all.pdf -transparent -painters


%% May 2016
%google doc
P = [927,848,838;944,886,896;1139,1081,1050;1291,1154,1071;1160,1154,1046;1184,1112,1088]';
P_exploration = [0,0,0; 21,122,251; 0,0,0; 0,0,0; 0,0,0; 0,0,0]';
Q_exploration_error = [0,0,0; 2,6,8.4; 0,0,0; 0,0,0; 0,0,0; 0,0,0]';
Q=[4,13,12;9,5.5,5.5;4,26,6;32,7,10; 4,5,6; 73,59,46]';
addpath('C:\Users\Nikita\acads\University of Chicago\Winter 2016\code\MatlabCommon');

% close all;
% mat(:,:,1)=P_exploration;
% mat(:,:,2)=P-P_exploration;
% plotBarStackGroups(mat,{'2','3','4'})
% set(gca,'fontsize',13);
% errorbar(P,err,'.');

close all;hold on;
A = P;
B = Q;

barweb(A,B,[],num2cell(2:4),[], [], [],   sched_color('color','RdBu'));
set(gca,'fontsize',13);
legend({'ORACLE', 'COAPE', 'MEM','IPC','L3R','RND'});
xlabel('Maximum permissible group size');ylabel('Scheduling Time (in seconds)');
grid on;
%bar(P_exploration,'FaceColor','k','EdgeColor','k','LineWidth',1.5);
bar(P_exploration);
bar(P_exploration,'FaceColor','r','EdgeColor','r');
% barweb(P_exploration , Q_exploration_error,[],num2cell(2:4),[], [], []);

% close all;hold on;
% bar(b,'grouped');
% errorbar(b,err);

% set(gca, 'XTick', 1:size(tmp,2), 'XTickLabel', Labels);
% title(['k = ',num2str(k)]);
% hold off;
% end

%%
%% parallel_schedule_combb bar
% 2 proc
P2 = [1102.73177618522	1076.77256176059	1302.43883696815	1297.64728697463	1339.40712977943	1536.41471364516
1636.07168891924	1504.27839851837	1905.69228789873	1928.43678479750	1905.55504821084	1962.32827931818
894.500442537562	783.910504661267	1459.61253143777	2656.67574761780	1410.45996065335	1595.02129286019];

P3 = [812.888288281333	780.132968468089	1226.78880385238	1207.54586288245	1124.98436045485	1135.67146475540
854.666483393518	811.784521182839	1281.85847176752	1357.48450796813	1881.49012696989	1753.82178217318
853.173415484763	641.512688289094	1107.69713112428	1168.39948477669	1311.89200291194	1202.57631178713];

P4 = [703.855458734124	694.660750138792	948.799265678466	948.799265678466	1233.75500164099	947.202543437098
635.161742868624	655.853475757676	1703.71909467997	1703.71909467997	1966.28993864933	1703.71909467997
447.766391702428	409.014376921735	673.368997097863	2975.0372527259	756.489707048471	2033.44211152678];
T{1}=P2;
T{2}=P3;
T{3}=P4;

close all;
for i = 1:3
subplot(1,3,i);
A = T{i};
B = zeros(size(A));
barweb(A,B,[],num2cell(2:4),[], [], [],   sched_color('color','RdBu'));
set(gca,'fontsize',13);
legend({ 'COAPE','ORACLE', 'MEM','IPC','L3R','RND'});
xlabel('Maximum permissible group size');
ylabel('Scheduling Time (in seconds)');
title([num2str(i+1),'-processors']);
%ylim([0,1850]);
grid on;
end
%export_fig ../../osdi/figures/parallel_schedule_combb_all_may.pdf -transparent -painters

%% parallel_schedule_combb load imbalance
OP = load('../../tmp/parallel_schedule_combb_4_4_100.mat');
max_load       = OP.Output.max_load;        
load_imbalance = OP.Output.load_imbalance;  
indices = [(1:4)*10,100];
A = squeeze(nanmean(max_load,1)); A = A(:,indices);
B = squeeze(stdev(max_load));    B = B(:,indices);
P = squeeze(nanmean(load_imbalance,1)); P = P(:,indices);
Q = squeeze(stdev(load_imbalance));    Q = Q(:,indices);

close all;
subplot(1,2,1);
    barweb(A',B',[],num2cell(indices),[], [], [], sched_color('color','RdBu'));
    set(gca,'fontsize',13);
    %legend({'ORACLE', 'COAPE', 'MEM','IPC','L3R','RND'},'location','NorthWest');
    %legend({'ORACLE', 'COAPE', 'MEM','IPC','L3R','RND'},'orientation','horizontal');
    xlabel('Number of jobs processed');
    ylabel('Scheduling Time (in seconds)');
    grid on;
%export_fig ../../osdi/figures/parallel_schedule_combb_100jobs_load_4_4_max_load.pdf -transparent -painters
subplot(1,2,2);
    barweb(P',Q',[],num2cell(indices),[], [], [], sched_color('color','RdBu'));
    set(gca,'fontsize',13);
    %legend({'ORACLE', 'COAPE', 'MEM','IPC','L3R','RND'},'location','NorthWest');
    legend({'ORACLE', 'COAPE', 'MEM','IPC','L3R','RND'},'orientation','horizontal');
    xlabel('Number of jobs processed');
    ylabel('Processor load imbalance (in seconds)');
    grid on;
 %   export_fig ../../osdi/figures/parallel_schedule_combb_100jobs_load_4_4_load_imbalance.pdf -transparent -painters
%export_fig ../../osdi/figures/parallel_schedule_combb_100jobs_load_4_4_load_imbalance_combined.pdf -transparent -painters
% how good is COAPE compared to benchmarks

% comp_est = 100*(A - repmat(A(2,:),size(A,1),1))./repmat(A(2,:),size(A,1),1);
% oracle_est = 100*(A(2,:) - A(1,:))./A(1,:);
% comp_est =
% 
%          -2.74         -8.57         -9.73         -9.94        -10.54
%              0             0             0             0             0
%          32.71         48.42         55.10         48.93         70.36
%          32.71         47.41         58.87         44.27         70.23
%          32.71         43.79         57.68         49.51         64.47
%          32.71         43.57         58.97         55.84         64.05
% oracle_est =
% 
%           2.81          9.37         10.78         11.03         11.79

%% parallel_schedule different number of processors
OP = load('../../tmp/parallel_schedule_combb_3_3_40_15.mat');
for i = 1:3
    for k = 1:3
        tmp = OP.Output{i,k}.timee;
        %tmp(tmp>3000)=NaN;
        median_time(i,k,:) = squeeze(nanmean(tmp));
        mad_time(i,k,:) = squeeze(stdev(tmp));
%         median_time(i,k,:) = squeeze(median(tmp));
%         mad_time(i,k,:) = squeeze(mad(tmp));       
    end
end


close all;
for i = 1:3
    subplot(1,3,i);
    A = squeeze(median_time(i,:,:)) ;
    B = squeeze(mad_time(i,:,:));
    %B = zeros(size(A));
    barweb(A,B,[],num2cell(2:4),[], [], [],   sched_color('color','RdBu'));
    set(gca,'fontsize',13);
    legend({ 'ORACLE','COAPE','EST-SUMM' 'MEM','IPC','L3R','RND'});
    xlabel('Maximum co-scheduling group size');
    ylabel('Scheduling Time (in seconds)');
    title([num2str(i+1),'-processors']);
    ylim([0,2200]);
    grid on;
end

%export_fig ../../osdi/figures/parallel_schedule_combb_all_may.pdf -transparent -painters

% Numbers
clear oracle_est comp_est
for i = 1:3
    for k = 1:3
        tmp = OP.Output{i,k}.timee;
        tmp(tmp>3000)=NaN;
        median_time(i,k,:) = squeeze(nanmean(tmp));
        mad_time(i,k,:) = squeeze(stdev(tmp));
        A = squeeze(median_time(i,k,:));
        comp_est(i,k,:) = 100*(A - repmat(A(2),size(A,1),1))./repmat(A(2),size(A,1),1);
        oracle_est(i,k) = 100*(A(2) - A(1))/A(1);
    end
end
% in percent
% oracle_est =
% 
%           3.09         11.05         10.72
%           3.47          6.18         11.39
%           4.58          9.95         12.96
% 
% comp_est(:,:,3) =
% 
%          31.34         32.55         45.98
%          31.21         48.62         51.12
%          36.05         39.63         51.63
% 
% 
% comp_est(:,:,4) =
% 
%          24.49         37.77         42.65
%          28.99         48.03         48.47
%          34.92         40.40         51.75
% 
% 
% comp_est(:,:,5) =
% 
%          34.18         40.24         50.67
%          44.58         55.82         54.38
%          47.45         55.00         52.31
% 
% 
% comp_est(:,:,6) =
% 
%          37.66         39.84         54.33
%          47.12         56.82         51.60
%          42.65         52.37         58.02
