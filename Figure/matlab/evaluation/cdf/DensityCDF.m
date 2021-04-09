clc
clear
figure1 = figure('PaperSize',[20.98404194812 29.67743169791]);
gs=textread('D:\MatlabWorkspaces\paper\ISCA\ISCA-paper\cdf\Density\GsightDensity.txt','%f');
py=textread('D:\MatlabWorkspaces\paper\ISCA\ISCA-paper\cdf\Density\PythiaDensity.txt','%f');
wf=textread('D:\MatlabWorkspaces\paper\ISCA\ISCA-paper\cdf\Density\WorstFitDensity.txt','%f');

step=2

hold on;
l1=cdf(gs(1:step:length(gs)),50);
hold on;
l2=cdf(py(1:step:length(py)),50);
hold on;
l3=cdf(wf(1:step:length(wf)),50);

lineWidth=3
% [69 117 180]/255
set(l1,'LineWidth',lineWidth,'color',[35 31 32]/255);
set(l2,'LineWidth',lineWidth,'color',[35 31 32]/255,'LineStyle',':');
% set(l3,'LineWidth',lineWidth,'color',[234 32  0]/255,'LineStyle','--');
set(l3,'LineWidth',lineWidth,'color',[35 31 32]/255,'LineStyle','--');
fontsize=24
fontsize1=22

set(gca,'YLim',[0 1]);%Y轴的数据显示范围
set(gca,'YTick',[0: 0.2: 1], 'Fontsize',fontsize1);%设置要显示坐标刻度
% set(gca,'yticklabels', {'0','0.05','0.10','0.15','0.20','0.25','0.30','0.35','0.40'} )
set(gca,'XLim',[0 4]);
set(gca,'XTick',[0: 1: 4], 'Fontsize',fontsize1)
%  set(gca,'xticklabels', {'0','20','40','60','80','100'} )
set(gcf,'position',[200 200 400 340])

set(gca,'units','normalized','position',[0.22 0.25 0.725 0.705],'box','on','Xgrid','on','Ygrid','on')

xlabel('Density (inst./core)','Fontsize' ,fontsize)
ylabel('CDF', 'Fontsize' ,fontsize)

set(gca, 'GridLineStyle', ':','ticklength',[0.015 0])  
legend1=legend('Gsight','Pythia','Worst Fit')
set(legend1,...
    'Position',[0.561074768799844 0.271500778870296 0.367499992847443 0.288235285965836],...
    'FontSize',18,...
    'EdgeColor',[0 0 0]);

set(gca,'xcolor',[0 0 0]);
set(gca,'ycolor',[0 0 0]);
box on