%AWS Lambda(Gsight,Pythia,Worst Fit)
%y=2.4978x-2.4443
%y=2.2070x-2.4443
%y=1.8601x-2.4443
%Google
%y=4.8245x-2.4443
%y=4.3197x-2.4443
%y=3.6436x-2.4443

clc
clear
figure1 = figure('PaperSize',[20.98404194812 29.67743169791]);

fontsize=18
fontsize1=16
lineWidth=3

x=0:1:3.1;

a1=2.4978;
b=-2.4443;
y1=a1*x+b;
plot1=plot(x,y1,'b')
hold on;

a2=2.2070;
y2=a2*x+b;
plot2=plot(x,y2,'b')
hold on;

a3=1.8601;
y3=a3*x+b;
plot3=plot(x,y3,'b')
hold on;

a4=4.8245;
y4=a4*x+b;
plot4=plot(x,y4,'b')
hold on;

a5=4.3197;
y5=a5*x+b;
plot5=plot(x,y5,'b')
hold on;

a6=3.6436;
y6=a6*x+b;
plot6=plot(x,y6,'b')
hold on;

set(gca,'YLim',[-4 14]);%Y轴的数据显示范围
set(gca,'YTick',[-4: 2: 14]);%设置要显示坐标刻度
% set(gca,'yticklabels', {'0','1','2','3','4'} )
set(gca,'XLim',[0 3.0]);
set(gca , 'XTick',[0: 0.5: 3.0], 'Fontsize',fontsize1)
% set(gca,'xticklabels', {'SN','EC','FO'} );

set(gcf,'position',[200 200 600 340])
grid on
set(gca,'units','normalized','position',[0.11 0.18 0.88 0.79],'box','on','Xgrid','on')

set(plot1,'LineWidth',lineWidth,'Color',[69 117 180]/255);
set(plot2,'LineWidth',lineWidth,'Color',[125 46 143]/255);
set(plot3,'LineWidth',lineWidth,'Color',[234 32 0]/255);
set(plot4,'LineWidth',lineWidth,'Color',[69 117 180]/255,'LineStyle','--');
set(plot5,'LineWidth',lineWidth,'Color',[125 46 143]/255,'LineStyle','--');
set(plot6,'LineWidth',lineWidth,'Color',[234 32 0]/255,'LineStyle','--');

xlabel('Years','Fontsize' ,fontsize)
ylabel('Revenue (10^9$)', 'Fontsize' ,fontsize)
set(gca,'xcolor',[0 0 0]);
set(gca,'ycolor',[0 0 0]);
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0])  

% xlim(axes1,[0 3]);

legend1=legend('AWS Gsight','AWS Pythia','AWS Worst Fit','Google Gsight','Google Pythia','Google Worst Fit')
set(legend1,...
    'Position',[0.131250903175937 0.513745928044421 0.318333326379458 0.44264704620137],...
    'FontSize',14);