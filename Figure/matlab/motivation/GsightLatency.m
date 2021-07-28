clc
clear
load GsightLatencyDataNew;
figure1 = figure('PaperSize',[20.98404194812 29.67743169791]);

axes1 = axes('Parent',figure1,'YGrid','on');
box(axes1,'on');
hold(axes1,'all');
lw=3;
plot(GsightLatencyDataNew(:,2),GsightLatencyDataNew(:,1),'--', 'LineWidth',lw ,'color',[35 31 32]/255); %��ɫ  
plot(GsightLatencyDataNew(:,4),GsightLatencyDataNew(:,3),':', 'LineWidth',lw ,'color',[35 31 32]/255); %��ɫ
plot(GsightLatencyDataNew(:,6),GsightLatencyDataNew(:,5),'-', 'LineWidth',lw ,'color', [238 41 47]/255);  %��ɫ   
plot(GsightLatencyDataNew(:,8),GsightLatencyDataNew(:,7),'-', 'LineWidth',lw ,'color', [35 31 32]/255) %��ɫ  
plot(GsightLatencyDataNew(:,10),GsightLatencyDataNew(:,9),'-.', 'LineWidth',lw ,'color', [35 31 32]/255) %��ɫ  
 
set(gca,'YLim',[0  1]);%X���������ʾ��Χ
set(gca,'YTick',[0 : .2: 1]);%����Ҫ��ʾ����̶� 
set(gca,'XLim',[100  1300]);%X���������ʾ��Χ
set(gca,'XTick',[100 : 300: 1300]);%����Ҫ��ʾ����̶�
set(gca,'xticklabels',[50 : 150: 1300]);%����Ҫ��ʾ����̶�
set(gca, 'Fontsize' ,18) 
 
xlabel('Latency (ms)', 'Fontsize' ,18)
ylabel('CDF', 'Fontsize' ,18)
set(gca, 'GridLineStyle', ':','ticklength',[0.002 0]) 
set(gca,'xcolor',[0 0 0]);
set(gca,'ycolor',[0 0 0]); 
set(gcf,'position',[100 100 300 240]) 
set(gca,'units','normalized','position',[0.24 0.3 0.7 0.65],'box','off') 
legend('KNN','LR','RFR','SVR','MLP','90th')
box on
grid on

