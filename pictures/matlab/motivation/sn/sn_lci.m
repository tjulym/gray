clc
clear
load data_snlci; 
data = data_snlci;
%% 1
set(gcf,'position',[200 200 500 400])
  
% fontsize=14;
fontsize=24;
fontsize1=22;
lineWidth=1;

ha = tight_subplot(3,1,[.020 .008],[.2 .0270],[.17 .02]) % 图片之间[上下间距,左右间距] 画布[下,上间距] 画布[左,右间距]

%% LSTM
axes(ha(1))
plot(data(:,1),'lineWidth',lineWidth,'DisplayName','IPC','MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor',[1 0 0],...
    'Marker','+',...
    'LineWidth',2,...
    'LineStyle','-.',...
    'Color',[238 41 47]/255);
% [234 32 0]/255
set(ha(1),'XLim',[0 length(data)])
set(ha(1),'XTick',[]);%设置要显示坐标刻度
set(ha(1),'YLim',[0.85 1.025]);%X轴的数据显示范围
set(ha(1),'YTick',[0.825:0.05:1.025],'Fontsize',fontsize1);%设置要显示坐标刻度
set(ha(1),'ycolor',[0 0 0]);
grid on
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0]) 
hold on
plot([1 1],[0 100],'LineStyle','-.','Color',[186 188 190]/255)
% [0 .2 1]
hold on
plot([10 10],[0 100],'LineStyle','-.','Color',[186 188 190]/255)
hold on
plot([19 19],[0 100],'LineStyle','-.','Color',[186 188 190]/255)
hold on
plot([28 28],[0 100],'LineStyle','-.','Color',[186 188 190]/255)
hold on
plot([0 100],[0.95 0.95],'LineStyle','-.','Color',[186 188 190]/255)
ll=legend('IPC') 
set(ll,...
    'Position',[0.787291668842238 0.874971057831958 0.18399999755621 0.08749999769032],...
    'FontSize',18);
 
axes(ha(2))
plot(data(:,2),'lineWidth',lineWidth,'DisplayName','CoV','MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor',[0 0 0],...
    'Marker','+',...
    'LineWidth',2,...
    'LineStyle','-',...
    'Color',[35 31 32]/255);
set(ha(2),'XLim',[0 length(data(:,2))])
set(ha(2),'xtick',[])

set(ha(2),'YLim',[0.25 .6]);%X轴的数据显示范围
set(ha(2),'YTick',[0.2:0.2:.6],'Fontsize',fontsize1);%设置要显示坐标刻度
set(ha(2),'ycolor',[0 0 0]);
grid on
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0]) 
hold on
plot([1 1],[0 100],'LineStyle','-.','Color',[186 188 190]/255)
hold on
plot([10 10],[0 100],'LineStyle','-.','Color',[186 188 190]/255)
hold on
plot([19 19],[0 100],'LineStyle','-.','Color',[186 188 190]/255)
hold on
plot([28 28],[0 100],'LineStyle','-.','Color',[186 188 190]/255)
hold on
plot([0 100],[0.3 0.3],'LineStyle','-.','Color',[186 188 190]/255)

l2=legend('CoV')
set(l2,...
    'Position',[0.778666669170062 0.611018460830271 0.195999997198582 0.0874999976903197],...
    'FontSize',18);

%% EMA
axes(ha(3))
plot(data(:,3)*1000,'lineWidth',lineWidth,'DisplayName','99%ile latency (ms)','MarkerFaceColor',[0 0 1],...
    'Marker','+',...
    'LineWidth',2,...
    'LineStyle','-.',...
    'Color',[[51 52 106]/255]);
% [[69 36 214]/255]
set(ha(3),'XLim',[0 length(data)],'Fontsize',fontsize1)
set(ha(3),'XTick',[0 1 3 5 7 9   10 12 14 16 18   19 21 23 25 27   28 30 32 34 36],'Fontsize',fontsize1);%设置要显示坐标刻度
set(ha(3),'xticklabel',{'0','1','3','5','7','9','1','3','5','7','9','1','3','5','7','9','1','3','5','7','9'})
set(ha(3),'YLim',[30 70]);%X轴的数据显示范围
set(ha(3),'YTick',[40:20:80],'Fontsize',fontsize1);%设置要显示坐标刻度
set(ha(3),'ycolor',[0 0 0]);
set(ha(3),'xcolor',[0 0 0]);
grid on
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0]) 
% xlabel('+MatMul        +dd         +iPerf3       +Video Pro.','Fontsize',fontsize1)
% xlabel('     +MatMul     +dd      +iPerf3  +Video Pro.','FontSize',fontsize1);
xlabel('     +matmul +dd +iperf3 +video pro.','FontSize',fontsize1);
hold on
plot([1 1],[0 100],'LineStyle','-.','Color',[186 188 190]/255)
hold on
plot([10 10],[0 100],'LineStyle','-.','Color',[186 188 190]/255)
hold on
plot([19 19],[0 100],'LineStyle','-.','Color',[186 188 190]/255)
hold on
plot([28 28],[0 100],'LineStyle','-.','Color',[186 188 190]/255)
hold on
plot([0 100],[33 33],'LineStyle','-.','Color',[186 188 190]/255)

% l3=legend('99%ile latency (ms)')
l3=legend('99%ile')
set(l3,...
    'Position',[0.72300952835257 0.348518460830271 0.247999995648861 0.0874999976903201],...
    'FontSize',18);
%% EMA 
