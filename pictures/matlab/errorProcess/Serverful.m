clc
clear

load dataserverful;
data=dataserverful;
%% 1
% set(gcf,'position',[200 200 800 340])
set(gcf,'position',[200 200 400 340])
% set(gcf,'position',[200 200 600 340])

fontsize=24;
fontsize1=22;
lineWidth=3;
 
% y = data(:,1:4);
x = 1:1:length(data);
 
% h = area(x,y,'LineStyle','none')
% h(1).FaceColor = [217 83 25]/255 ;
% h(2).FaceColor = [0 114 189]/255 ;
% h(3).FaceColor = [255 215 0]/255 ;
% h(4).FaceColor = [119 172 48]/255 ;
% h(1).FaceColor = [120 171 48]/255 ;
% h(2).FaceColor = [0 114 189]/255 ;
% h(3).FaceColor = [237 176 33]/255 ;
% h(4).FaceColor = [125 46 143]/255 ;
% set(gca,'units','normalized','position',[0.10 0.26 0.85 0.7],'box','on','Xgrid','off')
% set(gca,'units','normalized','position',[0.2 0.27 0.73 0.69],'box','on','Xgrid','off')
set(gca,'units','normalized','position',[0.2 0.26 0.725 0.70],'box','on','Xgrid','off') %400*300
% set(gca,'units','normalized','position',[0.14 0.26 0.81 0.705],'box','on','Xgrid','off')
set(gca,'YLim',[0  0.5]);%y轴的数据显示范围
set(gca,'YTick', [0: .1:0.5],'Fontsize',fontsize1 )
set(gca,'yticklabels', {'0','10','20','30','40','50'} )

% set(gca,'XLim',[0  900]);%x轴的数据显示范围
% set(gca,'XTick', [0: 100:900],'Fontsize',fontsize )
set(gca,'XLim',[0  30000]);%x轴的数据显示范围
% set(gca,'XTick', [0: 5000:30000],'Fontsize',fontsize )
% set(gca,'xticklabels', {'0','5000','10000','15000','20000','25000','30000'} )
set(gca,'XTick', [0: 10000:30000],'Fontsize',fontsize1 )
set(gca,'xticklabels', {'0','10k','20k','30k'} )
grid on
hold on;
% plot(x,data(:,1),'Color',[222 125 50]/255,'LineStyle','--','linewidth',1.5)
% plot(x,data(:,2),'Color',[119 172 48]/255,'LineStyle',':','linewidth',1.5)
% plot(x,data(:,3),'Color',[94 60 153]/255,'linewidth',1.5)
% plot(x,data(:,4),'Color',[236 173 31]/255,'LineStyle','-','linewidth',1.5)
% plot(x,data(:,5),'Color',[69 117 180]/255,'LineStyle','-.','linewidth',1.5)
% plot(x,data(:,1),'Color',[119 172 48]/255,'LineStyle','--','linewidth',1.5)
% plot(x,data(:,2),'Color',[119 172 48]/255,'LineStyle',':','linewidth',1.5)
% plot(x,data(:,3),'Color',[94 60 153]/255,'linewidth',1.5)
% plot(x,data(:,4),'Color',[119 172 48]/255,'LineStyle','-','linewidth',1.5)
% plot(x,data(:,5),'Color',[119 172 48]/255,'LineStyle','-.','linewidth',1.5)
plot(x,data(:,1),'Color',[35 31 32]/255,'LineStyle','--','linewidth',lineWidth)
plot(x,data(:,2),'Color',[35 31 32]/255,'LineStyle',':','linewidth',lineWidth)
plot(x,data(:,3),'Color',[238 41 47]/255,'linewidth',lineWidth)
plot(x,data(:,4),'Color',[35 31 32]/255,'LineStyle','-','linewidth',lineWidth)
plot(x,data(:,5),'Color',[35 31 32]/255,'LineStyle','-.','linewidth',lineWidth)
% [69 117 180]/255,[234 32 0]
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0]) 

% set(gca,'xtick',[])  %去掉x轴的刻度

ylabel('Error (%)','Fontsize',fontsize)
xlabel('Number of samples','Fontsize',fontsize)
ll=legend('IKNN','ILR','IRFR','ISVR','IMLP')
% set(ll,...
%     'Position',[0.622666670213143 0.439087036731939 0.287499995231628 0.502941162007696],...
%     'FontSize',20);
set(ll,...
    'Position',[0.634767942826261 0.455744305779393 0.287499995231628 0.502941162007696],...
    'FontSize',20);
