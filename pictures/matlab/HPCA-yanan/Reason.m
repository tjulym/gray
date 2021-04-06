clc
clear
load data_reason;  
data=data_reason;
%% 1
set(gcf,'position',[200 200 500 400])

fontsize=10;
lineWidth=1;

ha = tight_subplot(4,1,[.034 .008],[.1 .0170],[.1 .03]) % 图片之间[上下间距,左右间距] 画布[下,上间距] 画布[左,右间距]

%% LSTM
axes(ha(1))
plot(data(:,1),'lineWidth',lineWidth,'Color',[1 0 0]);

hold on
% plot(data(:,1),'lineWidth',lineWidth);
plot([109:1:length(data)],data(109:length(data),2),'lineWidth',lineWidth,'Color',[0 0 1]);
hold on
plot([1048:1:length(data)],data(1048:length(data),3),'lineWidth',lineWidth,'Color',[0 0 0]);
% 
set(ha(1),'XLim',[0 length(data)])
set(ha(1),'Xtick',[])

set(ha(1),'YLim',[0.6 1]);%X轴的数据显示范围
set(ha(1),'YTick',[0.6:0.2:1],'Fontsize',fontsize);%设置要显示坐标刻度
grid on
ylabel('Workload');
set(ha(1),'ycolor',[0 0 0]);
l1=legend('SN','EC','FO') 
set(l1,'Fontsize',8,'Orientation','horizon');
%%
axes(ha(2)) 
plot(data(:,4),'lineWidth',lineWidth,'Color',[1 0 0]);
hold on
plot(data(:,5),'lineWidth',lineWidth,'Color',[0 0 1]);
hold on
plot(data(:,6),'lineWidth',lineWidth,'Color',[0 0 0]);
hold on
plot(data(:,12),'lineWidth',lineWidth);
set(ha(2),'XLim',[0 length(data)])
set(ha(2),'xtick',[])

set(ha(2),'YLim',[0 100]);%X轴的数据显示范围
set(ha(2),'YTick',[1 2 8  32  100],'Fontsize',fontsize,'YScale','log');%设置要显示坐标刻度
grid on

l2=legend('SN','EC','FO','BEs') 
set(l2,'Fontsize',8,'Orientation','horizon');
ylabel('# of Functions');
set(ha(2),'ycolor',[0 0 0]);

%% EMA
axes(ha(3)) 
plot([1 1920],[267 267],'LineStyle','-','Color',[1 0 0]);
hold on
plot([1 1920],[88 88],'LineStyle','-','Color',[0 0 1]);
hold on
plot([1 1920],[37 37],'LineStyle','-','Color',[0 0 0]);
plot(data(:,7),'MarkerSize',0.5,'Marker','.','LineStyle','none','Color',[1 0 0]);
hold on
plot(data(:,8),'MarkerSize',0.5,'Marker','.','LineStyle','none','Color',[0 0 1]);
hold on
plot(data(:,9),'MarkerSize',0.5,'Marker','.','LineStyle','none','Color',[0 0 0]);
hold on


l3=legend('SN-SLO','EC-SL0','FO-SLO') 
set(l3,'Fontsize',8,'Orientation','horizon');
set(ha(3),'XLim',[0 length(data)])
set(ha(3),'xtick',[])

set(ha(3),'YLim',[1 1000]);%X轴的数据显示范围
set(ha(3),'YTick',[1 100 1000],'Fontsize',fontsize,'YScale','log');%设置要显示坐标刻度
grid on
ylabel('Latency (ms)')
set(ha(3),'ycolor',[0 0 0]);
% %% EMA
% axes(ha(4)) 
% plot(data(:,10),'lineWidth',lineWidth); 
% 
% set(ha(4),'xtick',[])
% set(ha(4),'XLim',[0 length(data)])
% set(ha(4),'YLim',[0 .75]);%X轴的数据显示范围
% set(ha(4),'YTick',[0:.25:.75],'Fontsize',fontsize);%设置要显示坐标刻度 
% set(ha(4),'YTickLabel',[0:.25:.75]*100,'Fontsize',fontsize);%设置要显示坐标刻度
%  
% ylabel('CPU Util.');
% set(ha(4),'ycolor',[0 0 0]); 
% grid on
% l4=legend('CPU Utilization (%)') 
% set(l4,'Fontsize',8,'Orientation','horizon');
% set(ha(4),'ycolor',[0 0 0]);
% %% 
% axes(ha(5)) 
% plot(data(:,11),'lineWidth',lineWidth); 
% 
% set(ha(5),'xtick',[0 :480:1920])
% set(ha(5),'XLim',[0 length(data)])
% set(ha(5),'YLim',[0 .75]);%X轴的数据显示范围
% set(ha(5),'YTick',[0:.25:.75],'Fontsize',fontsize);%设置要显示坐标刻度
% set(ha(5),'YTickLabel',[0:.25:.75]*100,'Fontsize',fontsize);%设置要显示坐标刻度
%  
% ylabel('Mem Util. (%)');
%  
% xlabel('Time (s)');
% set(ha(5),'ycolor',[0 0 0]); 
% set(ha(5),'xcolor',[0 0 0]); 
% grid on
% l5=legend('Memory Utilization (%)') 
% set(l5,'Fontsize',8,'Orientation','horizon');

axes(ha(4)) 
plot(data(:,10),'lineWidth',lineWidth,'Color',[1 0 0]); 
hold on
plot(data(:,11),'lineWidth',lineWidth,'Color',[0 0 1]); 

set(ha(4),'xtick',[0 :480:1920])
set(ha(4),'XLim',[0 length(data)])
set(ha(4),'YLim',[0 1]);%X轴的数据显示范围
set(ha(4),'YTick',[0:.25:1],'Fontsize',fontsize);%设置要显示坐标刻度
set(ha(4),'YTickLabel',[0:.25:1]*100,'Fontsize',fontsize);%设置要显示坐标刻度
 
ylabel('Utilization (%)');
 
xlabel('Timeline (s)');
set(ha(4),'ycolor',[0 0 0]); 
set(ha(4),'xcolor',[0 0 0]); 
grid on
l5=legend('CPU','Memory') 
set(l5,'Fontsize',8,'Orientation','horizon');
