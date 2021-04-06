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

% fontsize=18
% fontsize1=16
fontsize=24
fontsize1=22
lineWidth=2

x=0:0.5:3;

% a1=2.4978;
% b=-2.4443;
% y1=a1*x+b;
% plot1=plot(x,y1,'b')
% hold on;
% 
% a2=2.2070;
% y2=a2*x+b;
% plot2=plot(x,y2,'b')
% hold on;
% 
% a3=1.8601;
% y3=a3*x+b;
% plot3=plot(x,y3,'b')
% hold on;
% 
% a4=4.8245;
% y4=a4*x+b;
% plot4=plot(x,y4,'b')
% hold on;
% 
% a5=4.3197;
% y5=a5*x+b;
% plot5=plot(x,y5,'b')
% hold on;
% 
% a6=3.6436;
% y6=a6*x+b;
% plot6=plot(x,y6,'b')
% hold on;

%11.29month
a1=2.5978;
b=-2.4443;
y1=a1*x+b;
plot1=plot(x,y1,'b')
hold on;

%12.71month
a2=2.3070;
y2=a2*x+b;
plot2=plot(x,y2,'b')
hold on;

%14.96month
a3=1.9601;
y3=a3*x+b;
plot3=plot(x,y3,'b')
hold on;

%4.77month
a4=6.1506;
y4=a4*x+b;
plot4=plot(x,y4,'b')
hold on;

%5.53month
a5=5.3039;
y5=a5*x+b;
plot5=plot(x,y5,'b')
hold on;

%6.57month
a6=4.4671;
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
% set(gca,'units','normalized','position',[0.11 0.18 0.88 0.79],'box','on','Xgrid','on')
set(gca,'units','normalized','position',[0.13 0.08 0.85 0.89],'box','on','Xgrid','on')

% set(plot1,'LineWidth',lineWidth,'Color',[69 117 180]/255,'Marker','*');
% set(plot2,'LineWidth',lineWidth,'Color',[125 46 143]/255,'Marker','s');
% set(plot3,'LineWidth',lineWidth,'Color',[234 32 0]/255,'Marker','diamond');
% set(plot4,'LineWidth',lineWidth,'Color',[69 117 180]/255,'LineStyle','--','Marker','*');
% set(plot5,'LineWidth',lineWidth,'Color',[125 46 143]/255,'LineStyle','--','Marker','s');
% set(plot6,'LineWidth',lineWidth,'Color',[234 32 0]/255,'LineStyle','--','Marker','diamond');
set(plot1,'LineWidth',lineWidth,'Color',[238 41 47]/255,'Marker','*');
set(plot2,'LineWidth',lineWidth,'Color',[238 41 47]/255,'Marker','s');
set(plot3,'LineWidth',lineWidth,'Color',[238 41 47]/255,'Marker','diamond');
set(plot4,'LineWidth',lineWidth,'Color',[35 31 32]/255,'LineStyle','--','Marker','*');
set(plot5,'LineWidth',lineWidth,'Color',[35 31 32]/255,'LineStyle','--','Marker','s');
set(plot6,'LineWidth',lineWidth,'Color',[35 31 32]/255,'LineStyle','--','Marker','diamond');

xlabel('Years','Fontsize' ,fontsize)
% ylabel('Revenue ($10^{10})', 'Fontsize' ,fontsize)
ylabel('Revenue ($10 billion)', 'Fontsize' ,fontsize)
set(gca,'xcolor',[0 0 0]);
set(gca,'ycolor',[0 0 0]);
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0])  

plot(get(gca, "XLim"), [0,0],'k','LineWidth',1.2);
X=get(gca,'Xtick');
Yoff=diff(get(gca,'YLim'))./40;
Xoff=diff(get(gca,'XLim'))./40;
for i=2:length(X)
plot([X(i) X(i)],[0 Yoff],'-k','LineWidth',1.0);%LineWidth可以改变新轴的线宽
end;
%XL=get(gca,'XtickLabel');
XL = {"0.0", "0.5", " 1 ", "1.5", " 2 ", "2.5", " 3 "};
for i=2:length(X)
text(X(i)-Xoff,-2.*Yoff,XL(i),'FontSize',fontsize1);%LineWidth可以改变新轴的线宽
end;
box off;

ax = gca;
ax.XAxis.Visible = "off";
text(1.32, -4.8, 'Years','Fontsize',fontsize)

legend1=legend('AWS Gsight','AWS Pythia','AWS Worst Fit','Google Gsight','Google Pythia','Google Worst Fit')
set(legend1,...
    'Position',[0.134584237005976 0.523837061629941 0.335415762994024 0.44264704620137],...
    'FontSize',14);

% 创建 arrow
annotation(figure1,'arrow',[0.305 0.140000000000001],...
    [0.120588235294117 0.141176470588235],...
    'Color',[0.137254901960784 0.12156862745098 0.125490196078431],...
    'LineWidth',3,...
    'LineStyle','-.');

% 创建 textbox
annotation(figure1,'textbox',...
    [0.305000000000004 0.0813529432801632 0.616666666666663 0.099999997896307],...
    'String','Initial capital cost is $24.443 billion',...
    'FontWeight','bold',...
    'FontSize',16,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1],...
    'BackgroundColor',[0.749019607843137 0.752941176470588 0.764705882352941]);

% 创建 doublearrow
annotation(figure1,'doublearrow',[0.506666666666677 0.506666666666675],...
    [0.28235294117647 0.964705882352941],...
    'Color',[0.137254901960784 0.12156862745098 0.125490196078431],...
    'LineWidth',3,...
    'LineStyle','-.');

% 创建 textbox
annotation(figure1,'textbox',...
    [0.520000000000004 0.825470590338987 0.18749999490877 0.0999999978963069],...
    'String','Net profit',...
    'FontWeight','bold',...
    'FontSize',16,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1],...
    'BackgroundColor',[0.749019607843137 0.752941176470588 0.764705882352941]);