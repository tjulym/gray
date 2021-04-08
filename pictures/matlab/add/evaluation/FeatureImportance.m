
load('featureImportance');
data=featureImportance;

% c=[data(:,3) data(:,4)  data(:,1)  data(:,2)]
% C = reshape(data', [7 2 2]); 
bar(data,'Stack','BarWidth',0.5, 'FaceColor',[0.749019607843137 0.752941176470588 0.764705882352941]);
% fontsize = 18
fontsize=18
fontsize1=18
set(gca,'YLim',[0 0.06]);%X轴的数据显示范围
 set(gca,'YTick',[0:.02:0.06],'Fontsize',fontsize1);%设置要显示坐标刻度
% set(gca,'yticklabels', {'G1','G2','G3','G4','G5','G6','G7'} );
 set(gca,'XLim',[0.5 16.5]);
 set(gca , 'XTick',1:1:16, 'Fontsize',fontsize1)
 set(gca , 'XTickLabel',{'IPC','MemUtil','cpuUtil','LLC','ContextSwitch','L3MPKI','MLP','MemBW','NetworkIO','TLBDMPKI','L1IMPKI','TLBIMPKI','BranchMPKI','L2MPK2','LIDMKPI','DiskIO'}, 'Fontsize',fontsize1) 
 set(gcf,'position',[200 200 1000 340])
 grid on
 set(gca,'units','normalized','position',[0.09 0.4 0.89 0.55],'box','on','Xgrid','on')
xtl=get(gca,'XTickLabel'); 
 xt=get(gca,'XTick'); 
% 获取ytick的值          
yt=get(gca,'YTick');   
% 设置text的x坐标位置们          
xtextp=xt;                   
 % 设置text的y坐标位置们      
 ytextp=(yt(1)-0.2*(yt(2)-yt(1)))*ones(1,length(xt)); 
 text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',40,'fontsize',fontsize); 
  set(gca,'xticklabel','');
box on
grid on 

xlabel('Input Features','Fontsize' ,fontsize)
ylabel('Feature Importances', 'Fontsize' ,fontsize)

set(gca, 'GridLineStyle', ':','ticklength',[0.005 0])  
set(gca,'xcolor',[0 0 0]);
set(gca,'ycolor',[0 0 0]);
l1=legend('Feature importmance')
set(l1,...
    'FontSize',18);
 
