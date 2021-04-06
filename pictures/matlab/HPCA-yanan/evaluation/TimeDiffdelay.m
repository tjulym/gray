
load('time_stack');
data=time_stack;

% c=[data(:,3) data(:,4)  data(:,1)  data(:,2)]
% C = reshape(data', [7 2 2]); 
bar(data,'Stack','BarWidth',0.6);
% fontsize = 18
fontsize=24
fontsize1=20
set(gca,'YLim',[0 1.2]);%X轴的数据显示范围
 set(gca,'YTick',[0:.2:1.2],'Fontsize',fontsize1);%设置要显示坐标刻度
% set(gca,'yticklabels', {'G1','G2','G3','G4','G5','G6','G7'} );
 set(gca,'XLim',[0.5 12.5]);
 set(gca , 'XTick',1:1:12, 'Fontsize',fontsize1)
 set(gca , 'XTickLabel',[10:10:120], 'Fontsize',fontsize1) 
 set(gcf,'position',[200 200 600 340])
 grid on
 set(gca,'units','normalized','position',[0.14 0.23 0.85 0.72],'box','on','Xgrid','on')


xlabel('# of Function Instances','Fontsize' ,fontsize)
ylabel('Time (s)', 'Fontsize' ,fontsize)

set(gca, 'GridLineStyle', ':','ticklength',[0.005 0])  
set(gca,'xcolor',[0 0 0]);
set(gca,'ycolor',[0 0 0]);
l1=legend('Invocation forwarding','Scheduling decision','Start instance','Resource allocation')
set(l1,...
    'Position',[0.14972223441634 0.531862784951341 0.508333320717017 0.404411753135569],...
    'FontSize',20);
 
