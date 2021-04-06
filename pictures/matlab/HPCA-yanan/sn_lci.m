clc
clear
load data_snlci; 
data = data_snlci;
%% 1
set(gcf,'position',[200 200 500 400])
  
fontsize=14;
lineWidth=1;

ha = tight_subplot(3,1,[.020 .008],[.14 .0170],[.11 .02]) % 图片之间[上下间距,左右间距] 画布[下,上间距] 画布[左,右间距]

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
set(ha(1),'YTick',[0.825:0.05:1.025],'Fontsize',fontsize);%设置要显示坐标刻度
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
    'Position',[0.806291668574017 0.903721057571188 0.165999998092651 0.0699999982118606],...
    'FontSize',14);
 
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
set(ha(2),'YTick',[0.2:0.2:.6],'Fontsize',fontsize);%设置要显示坐标刻度
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
    'Position',[0.796666668872039 0.614768460569501 0.175999997794628 0.0699999982118605],...
    'FontSize',14);

%% EMA
axes(ha(3))
plot(data(:,3)*1000,'lineWidth',lineWidth,'DisplayName','99th Latency (ms)','MarkerFaceColor',[0 0 1],...
    'Marker','+',...
    'LineWidth',2,...
    'LineStyle','-.',...
    'Color',[[51 52 106]/255]);
% [[69 36 214]/255]
set(ha(3),'XLim',[0 length(data)],'Fontsize',fontsize)
set(ha(3),'XTick',[0 1 3 5 7 9   10 12 14 16 18   19 21 23 25 27   28 30 32 34 36],'Fontsize',fontsize);%设置要显示坐标刻度
set(ha(3),'xticklabel',{'0','1','3','5','7','9','1','3','5','7','9','1','3','5','7','9','1','3','5','7','9'})
set(ha(3),'YLim',[30 70]);%X轴的数据显示范围
set(ha(3),'YTick',[40:20:80],'Fontsize',fontsize);%设置要显示坐标刻度
set(ha(3),'ycolor',[0 0 0]);
set(ha(3),'xcolor',[0 0 0]);
grid on
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0]) 
xlabel('+MatMul        +dd         +iPerf3       +Video Pro.')
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

l3=legend('99th Latency (ms)')
set(l3,...
    'Position',[0.570666675607363 0.329768460569501 0.401999991059303 0.0699999982118607],...
    'FontSize',14);
%% EMA 
