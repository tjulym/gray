clc
clear
figure1 = figure('PaperSize',[20.98404194812 29.67743169791]);

load CostEfficiency
A=CostEfficiency  
for i=1:3
AA(:,i)=CostEfficiency(:,3-i+1)
end
A=AA
fontsize=22
fontsize1=20
c  = bar(A', 'BarWidth', 0.8)
% set(c(1),'FaceColor', [222 125 50]/255)
% set(c(2),'FaceColor', [119 172 48]/255)
% set(c(3),'FaceColor', [69 117 180]/255)
set(c(1),'FaceColor', [69 117 180]/255)
set(c(2),'FaceColor', [125 46 143]/255)
set(c(3),'FaceColor', [234 32 0]/255)
set(gca,'YLim',[0 4]);%Y轴的数据显示范围
set(gca,'YTick',[0: 1: 4]);%设置要显示坐标刻度
set(gca,'yticklabels', {'0','1','2','3','4'} )
set(gca,'XLim',[0.5 3.5]);
set(gca , 'XTick',1:3, 'Fontsize',fontsize1)
set(gca,'xticklabels', {'SN','EC','FO'} );

% set(gcf,'position',[200 200 600 220])
set(gcf,'position',[200 200 400 340])
grid on
set(gca,'units','normalized','position',[0.14 0.22 0.84 0.75],'box','on','Xgrid','on')

xlabel('Functions','Fontsize' ,fontsize)
ylabel('Relative price', 'Fontsize' ,fontsize)
set(gca,'xcolor',[0 0 0]);
set(gca,'ycolor',[0 0 0]);
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0])  

legend1 = legend('Gsight','Pythia','Worst Fit');
% set(legend1,...
%     'Position',[0.149583342683812 0.893872557039939 0.830416657316188 0.0955882328398089],...
%     'Orientation','horizontal',...
%     'FontSize',17);
set(legend1,...
    'Position',[0.153584466242445 0.87925253666289 0.807499987334013 0.0764705863069085],...
    'Orientation','horizontal',...
    'FontSize',13);
