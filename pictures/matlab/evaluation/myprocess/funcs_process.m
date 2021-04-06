clc
clear

load data_funcs_process;
data=data_funcs_process;
%% 1
set(gcf,'position',[200 200 800 250])

fontsize=18;
lineWidth=4;
 
hold on
C = linspecer(20);  
place=20
for i=1:length(data)
plot(data(i,:),[place place],'linewidth',lineWidth,'LineStyle','-','Color',C(i,:))

   place=place-1
end
place=20
hold on
for i=1:length(data)
    plot([data(i,1) data(i,1)],[0 place],'linewidth',0.5,'LineStyle','-.','Color',C(i,:))
   % plot([data(i,2) data(i,2)],[0 place],'linewidth',0.5,'LineStyle','-.','Color',C(i,:))
    place=place-1
end
set(gca,'XLim',[0 1920],'Fontsize',fontsize)
set(gca,'xtick',[0:480: 1920])

set(gca,'YLim',[0 20.5]);%X轴的数据显示范围
%set(gca,'YTick',[0.2:0.2:.6],'Fontsize',fontsize);%设置要显示坐标刻度
set(gca,'xcolor',[0 0 0]);
set(gca,'ycolor',[0 0 0]);
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0])
set(gca,'units','normalized','position',[0.105 0.28 0.65 0.7],'box','on')
box on
grid on

ylabel('Workload Arrivals Queue','Fontsize',fontsize)
xlabel('Timeline (s)','Fontsize',fontsize)
% columnlegend(2, {'SN','FG^1','EC','FG^2','MM^1','VP^1','FG^3',...
%     'RNN','DD','MT^1','iPerf3^1','FG^4','Json','VP^2',...
%     'FO','iPerf3^2','FG^5','MT^2','iPerf3^3','MM^2'},'FontSize',9); 
columnlegend(2, {'SN','FG^1','EC','FG^2','MM','VP','ALU-seq',...
    'RNN','DD','MT','iPerf3','Sum-nes','Json','ALU',...
    'CNN','ALU-par','IP','Sum-cha','DA','ALU-in'},'FontSize',9);
%columnlegend(3, {'SN-LC','FR^1-BE','EC-LC','FG^2-BE','MM_1-BE','VP^1-BE','FG^3-BE',...
 %   'RNN','DD','MT^1-BE','iPerf3^1-BE','FG^4-BE','Json','VP^2-BE',...
 %   'FO-LC','iPerf3^2-BE','FG^5-BE','MT^2-BE','iPerf3^3-BE','MM^2-BE'},'FontSize',10); 