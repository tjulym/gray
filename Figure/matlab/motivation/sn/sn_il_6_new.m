clc
clear
load data_inter2;
data=data_inter2;
%% 1
set(gcf,'position',[200 200 500 400])

% fontsize=18;
fontsize=20
fontsize1=20;
lineWidth=3;

ha = tight_subplot(2,1,[.08 .008],[.18 .0270],[.153 .03]); % 图片之间[上下间距,左右间距] 画布[下,上间距] 画布[左,右间距]

%% LSTM
axes(ha(1))

x = 1:1:length(data);
hold on
plot(x,data(:,1),'linewidth',lineWidth,'Marker','s','LineStyle','-','Color',[35 31 32]/255)
plot(x,data(:,3),'linewidth',lineWidth,'Marker','s','LineStyle',':','Color',[35 31 32]/255)

set(ha(1),'XLim',[1 length(data(:,2))],'Fontsize',fontsize1)
set(ha(1),'xtick',[1:1:length(data(:,2))])
%set(ha(1),'XTickLabel',[1:1:length(data(:,2))])

set(ha(1),'YLim',[0.3 1.2]);%X轴的数据显示范围
set(ha(1),'ytick',[0.3:0.3:1.2]);%X轴的数据显示范围
set(ha(1),'YTickLabel',[0.3:0.3:1.2])
%set(gca,'YTick',[0.2:0.2:.6],'Fontsize',fontsize);%设置要显示坐标刻度
set(ha(1),'xcolor',[0 0 0]);
set(ha(1),'ycolor',[0 0 0]);
set(ha(1), 'GridLineStyle', ':','ticklength',[0.005 0]) 
%set(gca,'units','normalized','position',[0.17 0.2 0.8 0.77],'box','on')
box on 
grid on
ll=legend('99th latency (under gray interference)','99th latency (after restore)');
set(ll,... 
    'FontSize',14);

%%
axes(ha(2))
hold on
plot(x,data(:,2),'linewidth',lineWidth,'Marker','s','LineStyle','-','Color',[238 41 47]/255)
plot(x,data(:,4),'linewidth',lineWidth,'Marker','s','LineStyle',':','Color',[238 41 47]/255)
%  [69 36 214]/255,[234 32 0]/255
set(ha(2),'XLim',[1 length(data(:,2))],'Fontsize',fontsize1)
set(ha(2),'xtick',[1:1:length(data(:,2))])
set(ha(2),'XTickLabel',[1:1:length(data(:,2))])

set(ha(2),'YLim',[0.3 1.2]);%X轴的数据显示范围
set(ha(2),'ytick',[0.3:0.3:1.2]);%X轴的数据显示范围
set(ha(2),'YTickLabel',[0.3:0.3:1.2])
set(ha(2),'xcolor',[0 0 0]);
set(ha(2),'ycolor',[0 0 0]);
set(ha(2), 'GridLineStyle', ':','ticklength',[0.005 0]) 
%set(gca,'units','normalized','position',[0.17 0.2 0.8 0.77],'box','on')
box on 
grid on

ylabel('Normalized Performance','Fontsize',fontsize)
xlabel('# of Social Network Functions','Fontsize',fontsize)
ll=legend('QPS (under gray interference)','QPS (after restore)');
set(ll,...
    'FontSize',14);