clc
clear
load bar_data_snlci2; 
data = data_snlci;
%% 1
set(gcf,'position',[200 200 500 400])
  
 
fontsize1=24; 
lineWidth=1.5
LineWidth=3;

ha = tight_subplot(3,1,[.06 .008],[.19 .06],[0.16 .02]) % 图片之间[上下间距,左右间距] 画布[下,上间距] 画布[左,右间距]

%% LSTM
axes(ha(1))

hold on
stairs(data(:,1),'lineWidth',LineWidth,'DisplayName','IPC',...
    'LineStyle','-',...
    'Color',[53 141 238]/255);

% plot(data(:,1),'lineWidth',lineWidth,'DisplayName','IPC','MarkerFaceColor',[0 0 0],...
%     'MarkerEdgeColor',[1 0 0],...
%     'Marker','+',...
%     'LineWidth',2,...
%     'LineStyle','-.',...
%     'Color',[238 41 47]/255);
% [234 32 0]/255
set(ha(1),'XLim',[1 length(data)])
set(ha(1),'XTick',[]);%设置要显示坐标刻度
set(ha(1),'YLim',[0.8 1]);%X轴的数据显示范围
set(ha(1),'YTick',[0.8:0.1:1],'Fontsize',fontsize1);%设置要显示坐标刻度
set(ha(1),'YTickLabel',{'0.8','0.9','1.0'},'Fontsize',fontsize1);%设置要显示坐标刻度
set(ha(1),'ycolor',[128 128 128]/255);
set(ha(1),'xcolor',[128 128 128]/255);
grid on
set(gca,'FontName','Times New Roman','FontSize',22,'FontWeight','bold', 'GridLineStyle', ':','ticklength',[0.01 0]) 

hold on
plot([10 10],[0 100],'LineStyle','-.','Color',[20 20 20]/255,'LineWidth',lineWidth)
plot([20 20],[0 100],'LineStyle','-.','Color',[20 20 20]/255,'LineWidth',lineWidth)
plot([30 30],[0 100],'LineStyle','-.','Color',[20 20 20]/255,'LineWidth',lineWidth)
%plot([0 100],[0.9511 0.9511],'LineStyle','--','Color',[255 0 0]/255,'LineWidth',1.5)
% 
% ylabel('IPC')

% l1=legend('IPC')
% set(l1,...
%      'Position',[0.787291668842238 0.874971057831958 0.18399999755621 0.08749999769032],...
%     'FontSize',16,'box','off');
box off

 

% 创建 arrow 
ylabel('IPC','Color',[0 0 0]/255);
% ll=legend('IPC') 
% set(ll,...
%     'Position',[0.787291668842238 0.874971057831958 0.18399999755621 0.08749999769032],...
%     'FontSize',18);
 
%% EMA
axes(ha(2))
stairs(data(:,3)*1000,'lineWidth',LineWidth,'DisplayName','IPC',... 
    'LineStyle','-',...
    'Color',[242 89 0]/255);


% plot(data(:,3)*1000,'lineWidth',lineWidth,'DisplayName','99%ile latency (ms)','MarkerFaceColor',[0 0 1],...
%     'Marker','+',...
%     'LineWidth',2,...
%     'LineStyle','-.',...
%     'Color',[[51 52 106]/255]);
% [[69 36 214]/255]
set(ha(2),'XLim',[1 length(data)],'Fontsize',fontsize1)
set(ha(2),'xtick',[])

set(ha(2),'YLim',[30 80]);%X轴的数据显示范围
set(ha(2),'YTick',[30:20:80],'Fontsize',fontsize1);%设置要显示坐标刻度
set(ha(2),'ycolor',[128 128 128]/255);
set(ha(2),'xcolor',[128 128 128]/255);
grid on
set(gca,'FontName','Times New Roman','FontSize',22,'FontWeight','bold', 'GridLineStyle', ':','ticklength',[0.01 0]) 
hold on
plot([10 10],[0 100],'LineStyle','-.','Color',[20 20 20]/255,'LineWidth',lineWidth) 
plot([20 20],[0 100],'LineStyle','-.','Color',[20 20 20]/255,'LineWidth',lineWidth) 
plot([30 30],[0 100],'LineStyle','-.','Color',[20 20 20]/255,'LineWidth',lineWidth) 
%plot([0 100],[33 33],'LineStyle','--','Color',[255 0 0]/255,'LineWidth',1.5)
 
ylabel('99%ile','Color',[0 0 0]/255);
 
box off
%% 

axes(ha(3))
stairs(data(:,2),'lineWidth',LineWidth,'DisplayName','IPC','LineStyle','-',...
    'Color',[35 31 32]/255);
% plot(data(:,2),'lineWidth',lineWidth,'DisplayName','CoV','MarkerFaceColor',[0 0 0],...
%     'MarkerEdgeColor',[0 0 0],...
%     'Marker','+',...
%     'LineWidth',2,...
%     'LineStyle','-',...
%     'Color',[35 31 32]/255);
set(ha(3),'XLim',[1 length(data)])
set(ha(3),'XTick',[1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41]+1,'Fontsize',fontsize1);%设置要显示坐标刻度
set(ha(3),'xticklabel',{'2','4','6','8',' ','2','4','6','8','','2','4','6','8','','2','4','6','8',''})
%set(ha(3),'xticklabel',{'1','','5','','9','','','dd','','','','iperf3','','','','','','video pro.','','',''})
set(ha(3),'YLim',[0.2 .7]);%X轴的数据显示范围
set(ha(3),'YTick',[0.2:0.2:.7],'Fontsize',fontsize1);%设置要显示坐标刻度
set(ha(3),'ycolor',[128 128 128]/255);
set(ha(3),'xcolor',[128 128 128]/255);
grid on
set(gca,'FontName','Times New Roman','FontSize',22,'FontWeight','bold', 'GridLineStyle', ':','ticklength',[0.01 0]) 

hold on
 
plot([10 10],[0 100],'LineStyle','-.','Color',[20 20 20]/255,'LineWidth',lineWidth)
plot([20 20],[0 100],'LineStyle','-.','Color',[20 20 20]/255,'LineWidth',lineWidth)
plot([30 30],[0 100],'LineStyle','-.','Color',[20 20 20]/255,'LineWidth',lineWidth) 
%plot([0 100],[0.3 0.3],'LineStyle','--','Color',[255 0 0]/255,'LineWidth',1.5)

ylabel('CoV','Color',[0 0 0]/255);

% l2=legend('CoV')
% set(l2,...
%     'Position',[0.778666669170062 0.611018460830271 0.195999997198582 0.0874999976903197],...
%     'FontSize',18);


% xlabel('+MatMul        +dd         +iPerf3       +Video Pro.','Fontsize',fontsize1)
% xlabel('     +MatMul     +dd      +iPerf3  +Video Pro.','FontSize',fontsize1);
xlabel('Combinations','FontSize',fontsize1,'Color',[0 0 0]/255);
set(gca,'XTickLabelRotation',0)
box off
 
% 创建 textbox
annotation(gcf,'textbox',...
    [0.415000000000002 0.935000001862645 0.204999994486568 0.0874999981373552],...
    'String','dd',...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',20,...
    'FontName','Times New Roman',...
    'FitBoxToText','off');

% 创建 textbox
annotation(gcf,'textbox',[0.75 0.915 0.28 0.1075],'String','video pro.',...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',20,...
    'FontName','Times New Roman',...
    'FitBoxToText','off');

% 创建 textbox
annotation(gcf,'textbox',...
    [0.593000000000001 0.937500001862645 0.20499999448657 0.0874999981373552],...
    'String','iperf',...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',20,...
    'FontName','Times New Roman',...
    'FitBoxToText','off');

% 创建 textbox
annotation(gcf,'textbox',...
    [0.149 0.935000001862645 0.20499999448657 0.0874999981373552],...
    'String','Matmul',...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',20,...
    'FontName','Times New Roman',...
    'FitBoxToText','off');

% 创建 line
annotation(gcf,'line',[0.768000000000004 0.768000000000004],...
    [0.165 0.09],'LineWidth',1);

% 创建 line
annotation(gcf,'line',[0.56 0.560000000000001],...
    [0.1625 0.0874999999999998],'LineWidth',1);

% 创建 line
annotation(gcf,'line',[0.35 0.350000000000001],...
    [0.1625 0.0874999999999998],'LineWidth',1);

