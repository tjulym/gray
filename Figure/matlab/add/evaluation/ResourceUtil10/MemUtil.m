clc
clear

load MemUtil;
data=MemUtil;
%% 1
set(gcf,'position',[200 200 670 340])

fontsize=22;
fontsize1=20;
lineWidth=2;
 
% y = data(:,1:2);
x = 1:1:length(data);
 
% h = area(x,y,'LineStyle','none')
% h(1).FaceColor = [44 154 70]/255 ;
% h(2).FaceColor = [14 102 153]/255 ;
set(gca,'units','normalized','position',[0.1 0.23 0.88 0.74],'box','on','Xgrid','off')
% set(gca,'YLim',[0  0.8]);%y轴的数据显示范围
% set(gca,'YTick', [0 0.2 0.4 0.6 0.8],'Fontsize',fontsize1 )
set(gca,'YLim',[0  0.8]);%y轴的数据显示范围
set(gca,'YTick', [0: .2:0.8],'Fontsize',fontsize1 )
set(gca,'yticklabels', {'0','20','40','60','80'} )

set(gca,'XLim',[0  740]);%X轴的数据显示范围
set(gca,'XTick', [0: 120:740],'Fontsize',fontsize1 )
set(gca,'xticklabels', {'0','1200','2400','3600','4800','6000','7200'} )
grid on
hold on;
plot(x,data(:,1),'color',[69 117 180]/255,'linewidth',lineWidth)
plot(x,data(:,2),'color',[125 46 143]/255,'linewidth',lineWidth,'LineStyle',':')
plot(x,data(:,3),'color',[234 32 0]/255,'linewidth',lineWidth,'LineStyle','--')
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0]) 

% set(gca,'xtick',[])  %去掉x轴的刻度

ylabel('Mem Util.(%)','Fontsize',fontsize)
xlabel('Timeline (s)','Fontsize',fontsize)
% ll=legend('Gsight','Pythia','Worst Fit')
% set(ll,...
%     'Position',[0.106208329652746 0.85961467001398 0.451249992251396 0.0911764682215804],...
%     'Orientation','horizontal',...
%     'FontSize',16);
