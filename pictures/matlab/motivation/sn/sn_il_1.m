clc
clear

load data_inter1;
data=data_inter1;
%% 1
set(gcf,'position',[200 200 500 400])

% fontsize=18;
fontsize=24;
fontsize1=22;
lineWidth=3;
  
x = 1:1:length(data);
hold on
plot(x,data(:,1),'linewidth',lineWidth,'Marker','s','LineStyle','-','Color',[35 31 32]/255)
plot(x,data(:,2),'linewidth',lineWidth,'Marker','s','LineStyle','-','Color',[238 41 47]/255)
plot(x,data(:,3),'linewidth',lineWidth,'Marker','s','LineStyle',':','Color',[35 31 32]/255)
plot(x,data(:,4),'linewidth',lineWidth,'Marker','s','LineStyle',':','Color',[238 41 47]/255)
%  [69 36 214]/255,[234 32 0]/255
set(gca,'XLim',[1 length(data(:,2))],'Fontsize',fontsize1)
set(gca,'xtick',[01: 9])

set(gca,'YLim',[0.4 1.2]);%X轴的数据显示范围
%set(gca,'YTick',[0.2:0.2:.6],'Fontsize',fontsize);%设置要显示坐标刻度
set(gca,'xcolor',[0 0 0]);
set(gca,'ycolor',[0 0 0]);
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0]) 
set(gca,'units','normalized','position',[0.17 0.2 0.8 0.77],'box','on')
box on 
grid on

ylabel('Normalized Performance','Fontsize',fontsize)
xlabel('# of Social Network Functions','Fontsize',fontsize)
ll=legend('99%ile latency (Gray Interference)','QPS (Gray Interference)','99%ile latency (Local Control)','QPS (Local Control)')
set(ll,...
    'Position',[0.14766668082277 0.19208338667949 0.587999985516072 0.223749993741512],...
    'FontSize',14);
