clc
clear
load TPCWSLA;
data=TPCWSLA;
figure1 = figure('PaperSize',[20.98404194812 29.67743169791]);

step=1

hold on;
l1=cdf(data(:,1),50);
hold on;
l2=cdf(data(:,2),50);  
hold on;
l3=cdf(data(:,3),50); 
lineWidth=4
hold on

plot([88,88],[0,1],'r','lineWidth',lineWidth,'Color',[238 41 47]/255)

% plot([92,92],[0,1],'color',[69 117 180]/255,'lineWidth',lineWidth)
% plot([92,92],[0,1],'color',[234 32 0]/255,'lineWidth',lineWidth)
% set(l1,'LineWidth',lineWidth,'color',[222 125 50]/255);
% set(l2,'LineWidth',lineWidth,'color',[119 172 48]/255); 
% set(l1,'LineWidth',lineWidth,'color',[0 0 255]/255);
% set(l2,'LineWidth',lineWidth,'color',[255 0 0]/255); 
% set(l1,'LineWidth',lineWidth,'color',[69 117 180]/255);
% set(l2,'LineWidth',lineWidth,'color',[119 172 48]/255); 
% set(l1,'LineWidth',lineWidth,'color',[69 117 180]/255);
% set(l2,'LineWidth',lineWidth,'color',[125 46 143]/255,'LineStyle',':');
% set(l3,'LineWidth',lineWidth,'color',[234 32 0]/255,'LineStyle','--');
set(l1,'LineWidth',lineWidth,'color',[35 31 32]/255);
set(l2,'LineWidth',lineWidth,'color',[35 31 32]/255,'LineStyle',':');
set(l3,'LineWidth',lineWidth,'color',[35 31 32]/255,'LineStyle','--');

% fontsize=20
fontsize=24
fontsize1=22
 
% set(c(1),'FaceColor',  [222 125 50]/255)
% set(c(2),'FaceColor', [119 172 48]/255)
% set(c(3),'FaceColor',  [94 60 153]/255)
% set(c(4),'FaceColor',  [165 165 165]/255)
% set(c(5),'FaceColor',[69 117 180]/255)
set(gca,'YLim',[0 1]);%X轴的数据显示范围
set(gca,'YTick',[0: 0.2: 1],'Fontsize',fontsize1);%设置要显示坐标刻度
% set(gca,'yticklabels', {'0','0.05','0.10','0.15','0.20','0.25','0.30','0.35','0.40'} )
% set(gca,'XLim',[800 1000]);
% set(gca , 'XTick',[800: 50: 1000])
% set(gca,'XLim',[0 160]);
% set(gca , 'XTick',[0: 40: 160])
set(gca,'XLim',[0 100]);
set(gca , 'XTick',[0: 20: 100],'Fontsize' ,fontsize1)
% set(gca,'xticklabels', {'95','90','85','80'} );

% set(gcf,'position',[200 200 480 400])
% set(gcf,'position',[200 200 290 240])
% set(gcf,'position',[200 200 400 340])
set(gcf,'position',[200 200 600 340])
grid on
% set(gca,'units','normalized','position',[0.16 0.19 0.78 0.77],'box','on','Xgrid','on')
% set(gca,'units','normalized','position',[0.21 0.25 0.74 0.72],'box','on','Xgrid','on')
set(gca,'units','normalized','position',[0.14 0.25 0.82 0.72],'box','on','Xgrid','on')

xlabel('Latency (ms)','Fontsize' ,fontsize)
ylabel('CDF', 'Fontsize' ,fontsize)

set(gca, 'GridLineStyle', ':','ticklength',[0.015 0])  
% legend1=legend('Gsight','Pythia','Worst Fit')
% set(legend1,...
%     'Position',[0.540342439109339 0.271825986742682 0.394999992027879 0.305882344263442],...
%     'FontSize',20,...
%     'EdgeColor',[0 0 0]);

% 创建 textbox
annotation(figure1,'textbox',...
    [0.660402298850577 0.332431374113641 0.208333327745398 0.0774999984353781],...
    'Color',[238 41 47]/255,...
    'String',{'SLA=88'},...
    'LineStyle','none',...
    'FontSize',20,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1],...
    'FontWeight','bold');

set(gca,'xcolor',[0 0 0]);
set(gca,'ycolor',[0 0 0]);