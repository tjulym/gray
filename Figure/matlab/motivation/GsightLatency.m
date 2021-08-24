clc
clear
load GsightLatencyData;
figure1 = figure('PaperSize',[20.98404194812 29.67743169791]);

axes1 = axes('Parent',figure1,'YGrid','on');
box(axes1,'on');
hold(axes1,'all'); 
  
a1 = GsightLatencyData(:,1);%EFR
b1 = GsightLatencyData(:,2);%ElaX
c1 = GsightLatencyData(:,3);%EFRA
d1 = GsightLatencyData(:,4);%peak
e1 = GsightLatencyData(:,5);%PRESS

hold on
lw = 3 
figureSize=22
xi = linspace(min(a1),max(a1),100);
F = ksdensity(a1,xi,'function','cdf');
plot(xi,F,'--', 'LineWidth',lw ,'LineStyle','-.',...
   'Color',[0.313725490196078 0.376470588235294 0.815686274509804]);
 
xi = linspace(min(b1),max(b1),100);
F = ksdensity(b1,xi,'function','cdf');
plot(xi,F,':', 'LineWidth',lw ,'LineStyle',':',...
    'Color',[0.949019607843137 0.349019607843137 0]);

xi = linspace(min(c1),max(c1),100);
F = ksdensity(c1,xi,'function','cdf');
plot(xi,F,'-', 'LineWidth',lw ,'LineWidth',3,...
    'Color',[0.627450980392157 0 0]);

xi = linspace(min(d1),max(d1),100);
F = ksdensity(d1,xi,'function','cdf');
plot(xi,F,'-', 'LineWidth',lw ,'Color',[0 0.627450980392157 0]);

xi = linspace(min(e1),max(e1),100);
F = ksdensity(e1,xi,'function','cdf');
plot(xi,F,'-.', 'LineWidth',lw ,'LineStyle','-',...
    'Color',[0.137254901960784 0.12156862745098 0.125490196078431]);
% aa1 = plot(a1,x,'-', 'LineWidth',lw ,'color',[255 215 0]/255); %��ɫ  
% bb1 = plot(b1,x,'-', 'LineWidth',lw ,'color', [153 102 153]/255); %��ɫ
% cc1 = plot(c1,x,'-', 'LineWidth',lw ,'color', [51 153 51]/255);  %��ɫ   
% dd1 = plot(e1,x,'-.', 'LineWidth',1.5,'color', [149 14 8]/255) %��ɫ  
% ee1 = plot([0 1400],[0.99 0.99],'-.', 'LineWidth',1.5,'color', [0 0 255]/255) %  
% hold on;
% plot(967,0.9,'or', 'MarkerSize',12,'LineWidth',2.5) %��ɫ  
% hold on;
% plot(542,0.9,'or', 'MarkerSize',12,'LineWidth',2.5) %��ɫ  
set(gca,'YLim',[0  1]);%X���������ʾ��Χ
set(gca,'YTick',[0:1:1]);%����Ҫ��ʾ����̶�
% %set(gca,'yticklabels',{'0' ,'24'  ,'48',  '72', '96',  '120'});
set(gca,'XLim',[100  1300]);%X���������ʾ��Χ
set(gca,'XTick',[100 : 400: 1300]);%����Ҫ��ʾ����̶�
set(gca,'xticklabels',[50 : 200: 1300]);%����Ҫ��ʾ����̶�

 %set(gca,'XTicklabel',{0:2:10});%����Ҫ��ʾ����̶�

% title('EMU of redis with BE Tasks', 'FontSize' , 13)

set(gca,'FontName','Times New Roman','FontSize',figureSize,'FontWeight','bold', 'GridLineStyle', ':','ticklength',[0.01 0]) 
set(gca,'xcolor',[128 128 128]/255);
 set(gca,'ycolor',[128 128 128]/255);
 xlabel('Latency (ms)', 'Fontsize' ,figureSize,'Color',[0 0 0])
ylabel('CDF', 'Fontsize' ,figureSize,'Color',[0 0 0])
%set the position of figure and axis 
 set(gcf,'position',[100 100 300 240])
%  set(gca,'units','normalized','position',[0.2 0.3 0.6 0.5],'box','off')
 set(gca,'units','normalized','position',[0.18 0.305 0.745 0.65])
 box off
 %legend content  
legend({'KNN','LR','RFR','SVR','MLP'},'FontSize',18,'box','off')
grid on

