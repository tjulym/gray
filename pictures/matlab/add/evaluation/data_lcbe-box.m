
%boxplot箱线图1
clc
clear
fontsize=16;
load data_lcbe_KNN
load data_lcbe_LR
load data_lcbe_RFR
load data_lcbe_SVR
load data_lcbe_MLP
load data_lcbe_ESP
load data_lcbe_Pythia
%data_100=xlsread('boxplot_CPUcostatperiod.xls');
% data=data_100/100;
data1=data_lcbe_KNN;
data2=data_lcbe_LR;
data3=data_lcbe_RFR;
data4=data_lcbe_SVR;
data5=data_lcbe_MLP;
data6=data_lcbe_ESP;
data7=data_lcbe_Pythia;
data1(isnan(data1))=0; %将数据中的NAN替换为0
data2(isnan(data2))=0; %将数据中的NAN替换为0 
data3(isnan(data3))=0; %将数据中的NAN替换为0
data4(isnan(data4))=0; %将数据中的NAN替换为0
data5(isnan(data5))=0; %将数据中的NAN替换为0
data6(isnan(data6))=0; %将数据中的NAN替换为0
data7(isnan(data7))=0; %将数据中的NAN替换为0 

axes1 = axes('Parent',figure,'YGrid','on');
hold(axes1,'all');
 
plot([1 1],[2 2],'s','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[255,127,255]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[255,127,255]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)
hold on 
plot([1 1],[2 2],'cs','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[255,127,127]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[255,127,127]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)
plot([1 1],[2 2],'gs','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[127,255,127]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[127,255,127]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)
hold on 
plot([1 1],[2 2],'bs','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[255,127,127]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[255,127,127]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)
plot([1 1],[2 2],'ks','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[127,255,127]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[127,255,127]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)
hold on 
plot([1 1],[2 2],'ys','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[255,127,127]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[255,127,127]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)
plot([1 1],[2 2],'ms','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[127,255,127]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[127,255,127]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)

hold on 
bone_class_f=[data1(:,1);data1(:,2);data1(:,3);data1(:,4)]; % combine into a column 
G_f = [zeros(size(data1(:,1)))+1;zeros(size(data1(:,2)))+2;zeros(size(data1(:,3)))+3;zeros(size(data1(:,4)))+4]; 
box1 = boxplot(bone_class_f,G_f,'Colors','kkkk','positions',0.7:1:3.7,'width',0.1,'symbol','');

 

bone_class_f2=[data2(:,1);data2(:,2);data2(:,3);data2(:,4)]; % combine into a column 
G_f2 = [zeros(size(data2(:,1)))+1;zeros(size(data2(:,2)))+2;zeros(size(data2(:,3)))+3;zeros(size(data2(:,4)))+4]; 
box2 = boxplot(bone_class_f2,G_f2,'Colors','kkkk','positions',0.8:1:3.8,'width',0.1,'symbol','');


bone_class_f3=[data3(:,1);data3(:,2);data3(:,3);data3(:,4)]; % combine into a column 
G_f3 = [zeros(size(data3(:,1)))+1;zeros(size(data3(:,2)))+2;zeros(size(data3(:,3)))+3;zeros(size(data3(:,4)))+4]; 
box3 = boxplot(bone_class_f3,G_f3,'Colors','kkkk','positions',0.9:1:3.9,'width',0.1,'symbol','');


bone_class_f4=[data4(:,1);data4(:,2);data4(:,3);data4(:,4)]; % combine into a column 
G_f4 = [zeros(size(data4(:,1)))+1;zeros(size(data4(:,2)))+2;zeros(size(data4(:,3)))+3;zeros(size(data4(:,4)))+4]; 
box4 = boxplot(bone_class_f4,G_f4,'Colors','kkkk','positions',1:1:4,'width',0.1,'symbol','');


bone_class_f5=[data5(:,1);data5(:,2);data5(:,3);data5(:,4)]; % combine into a column 
G_f5 = [zeros(size(data5(:,1)))+1;zeros(size(data5(:,2)))+2;zeros(size(data5(:,3)))+3;zeros(size(data5(:,4)))+4]; 
box5 = boxplot(bone_class_f5,G_f5,'Colors','kkkk','positions',1.1:1:4.1,'width',0.1,'symbol','');

bone_class_f6=[data6(:,1);data6(:,2);data6(:,3);data6(:,4)]; % combine into a column 
G_f6 = [zeros(size(data6(:,1)))+1;zeros(size(data6(:,2)))+2;zeros(size(data6(:,3)))+3;zeros(size(data6(:,4)))+4]; 
box6 = boxplot(bone_class_f6,G_f6,'Colors','kkkk','positions',1.2:1:4.2,'width',0.1,'symbol','');
 
bone_class_f7=[data7(:,1);data7(:,2);data7(:,3);data7(:,4)]; % combine into a column 
G_f7 = [zeros(size(data7(:,1)))+1;zeros(size(data7(:,2)))+2;zeros(size(data7(:,3)))+3;zeros(size(data7(:,4)))+4]; 
box7 = boxplot(bone_class_f7,G_f7,'Colors','kkkk','positions',1.3:1:4.3,'width',0.1,'symbol','');

h = findobj(gca,'Tag','Box'); 
colorlist ={'r','r','r','r','c','c','c','c','g','g','g','g','b','b','b','b','k','k','k','k','y','y','y','y','m','m','m','m'};
for m=1:length(h)
    patch(get(h(m),'XData'),get(h(m),'YData'),cell2mat(colorlist(m)),'FaceAlpha',.5);
end
set(box1,'lineWidth',1)
set(box2,'lineWidth',1)
xlabel('Machine Learning Model','Fontsize',fontsize);
ylabel('Prediction Error (%)','Fontsize',fontsize);
set(gca,'xcolor',[0 0 0],'Fontsize',fontsize);
set(gca,'ycolor',[0 0 0],'Fontsize',fontsize);
set(gca,'YLim',[0 0.6])
set(gca,'YTick', [0:0.15:0.6]); % 添加X轴的记号点
set(gca,'yTickLabel',[0:0.15:0.6]*100,'Fontsize',fontsize);
set(gca,'XLim',[0.5 4.5])
set(gca, 'XTick', [1,2,3,4]); % 添加X轴的记号点
set(gca,'XTickLabel',{'80','85','90','95'},'Fontsize',fontsize);
set(gca,'units','normalized','position',[0.12 0.25 0.85 0.7],'box','on')
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0]) 
set(gcf,'position',[200 200 800 250]) %分别代表x轴长度,y轴长度,图像长度,图像高度
grid on
ll=legend('IKNN','ILR','IRFR','ISVR','IMLP','ESP','Pythia') 
set(ll,'Fontsize',14,'Orientation','horizon')

% set(legend1, 'Box', 'off')
 
% 
% %boxplot箱线图2
% clc
% clear
% fontsize=30;
% data_100=xlsread('boxplot_CPUcostatnum3.xls');
% % data=data_100/100;
% data=data_100/100;
% data(isnan(data))=0; %将数据中的NAN替换为0
% figure;
% bone_class_f=[data(:,1);data(:,2);data(:,3);data(:,4)]; % combine into a column 
% G_f = [zeros(size(data(:,1)))+1;zeros(size(data(:,2)))+2;zeros(size(data(:,3)))+3;zeros(size(data(:,4)))+4]; 
% %box = boxplot(bone_class_f,G_f, 'boxstyle' ,'filled');
% box = boxplot(bone_class_f,G_f,'Colors','kkkk');
% set(box,'LineWidth',2);
% %h_f = strcat(header{j},' female mean', info);
% % title('female mean');
% % xlabel('Probing interval (s)');
% xlabel('Number of packets');
% ylabel('CPU%');
% % ylabel('Average MEM%');
% set(gca,'xcolor',[0 0 0]);
% set(gca,'ycolor',[0 0 0]);
% set(gca, 'XTick', [1,2,3,4]); % 添加X轴的记号点
% set(gca, 'YGrid','on'); % Y轴的网格
% set(gca,'YLim',[0.15 0.35])
% set(gca,'YTick',[0.15: 0.05: 0.35])
% set(gca,'YTickLabel',{'15%','20%','25%','30%','35%'}, 'Fontsize',fontsize,'linewidth',2);
% set(gcf,'position',[200 200 600 350]) %分别代表x轴长度,y轴长度,图像长度,图像高度
% grid on
% set(gca,'units','normalized','position',[0.15 0.24 0.83 0.7],'box','on','Xgrid','on')
% % set(gca,'XTickLabel',{'0.1','1','10','inf'},'Fontsize',fontsize,'linewidth',2);
% set(gca,'XTickLabel',{'5','15','30','50'},'Fontsize',fontsize);
% hold on;
% % mean_bone_class=[median(data(:,1));median(data(:,2));median(data(:,3));median(data(:,4))];% combine into a column 
% % mean_bone_class=[mean(data(:,1));mean(data(:,2));mean(data(:,3));mean(data(:,4))]-0.005;% period,period=1
% mean_bone_class=[mean(data(:,1))-0.01;mean(data(:,2));mean(data(:,3));mean(data(:,4))]+0.005;% num,period=1 
% % mean_bone_class=[mean(data(:,1));mean(data(:,2));mean(data(:,3));mean(data(:,4))]-0.005;% period,period=10
% % mean_bone_class=[mean(data(:,1))-0.01;mean(data(:,2));mean(data(:,3));mean(data(:,4))]+0.005;% num,period=10 
% plot(mean_bone_class ,'kx-','linewidth',4,'MarkerSize',10);
% legend1=legend('Average CPU%');
% set(legend1, 'Box', 'off')
% set(legend1,'FontSize',26)
% h = findobj(gca,'Tag','Box');
% %colorlist ={'g','g','g','g','g','g'};%% 全用斜线填充
% colorlist ={'r','g','b','y'};
% for m=1:length(h)
%     patch(get(h(m),'XData'),get(h(m),'YData'),cell2mat(colorlist(m)),'FaceAlpha',.5);
% end
% % applyhatch_plusC(1,'+-x.','rkgb');
% % hold off;
% % filename_f=[path_save,'female\',imag_type,'\',h_f,'.jpeg'];
% % print(gcf,'-djpeg',filename_f);



% 
% load carsmall
% boxplot(MPG,Origin, 'Color', 'kkk');
% h = findobj(gca,'Tag','Box');
% colorlist ={'r','g','b','y','r','g'};
% for j=1:length(h)
% patch(get(h(j),'XData'),get(h(j),'YData'),cell2mat(colorlist(j)),'FaceAlpha',.5);
% end
% applyhatch_plusC(1,'+-x./x','rkgbrg');



% % 内存开销柱形图1
% clc
% clear
% figure1 = figure('PaperSize',[20.98404194812 29.67743169791]);
% 
% fontsize=30;
% y=[0.007,0.007,0.007,0.007];
% b=bar(y, 'BarWidth', 0.65);
% axis([0.4 4.6 0 1]);  %修改坐标轴显示范围，[x-min  x-max  y-min  y-max]
% set(b,'FaceColor', [222 125 50]/255,'linewidth',2)
% grid on;
% hold on
% set(gca,'YLim',[0 0.012])
% set(gca,'YTick',[0: 0.003: 0.012])
% set(gca,'XGrid','off');
% ch = get(b,'children');
% % set(gca,'XTickLabel',{'5','15','30','50'},'Fontsize',fontsize,'linewidth',2);
% set(gca,'XTickLabel',{'0.1','1','10','inf'},'Fontsize',fontsize,'linewidth',2);
% % set(ch,'FaceVertexCData',[1 0 1;0 0 0;])
%  
% % set(gca,'YTick',1:1:11);
% set(gca,'YTickLabel',{'0%','0.3%','0.6%','0.9%','1.2%'}, 'Fontsize',fontsize,'linewidth',2);
% set(gcf,'position',[200 200 600 350]) %分别代表x轴长度,y轴长度,图像长度,图像高度
% grid on
% set(gca,'units','normalized','position',[0.15 0.24 0.83 0.7],'box','on','Xgrid','on')
% %legend('最优结果','非最优结果');
% xlabel('Probing interval (s)');
% % xlabel('Number of packets');
% ylabel('MEM%');
% set(gca,'xcolor',[0 0 0]);
% set(gca,'ycolor',[0 0 0]);
% % set(gca, 'GridLineStyle', ':','ticklength',[0.005 0])



% % 内存开销柱形图2
% clc
% clear
% figure1 = figure('PaperSize',[20.98404194812 29.67743169791]);
% 
% fontsize=30;
% y=[0.007,0.007,0.007,0.007];
% b=bar(y, 'BarWidth', 0.65);
% axis([0.4 4.6 0 1]);  %修改坐标轴显示范围，[x-min  x-max  y-min  y-max]
% set(b,'FaceColor', [222 125 50]/255,'linewidth',2)
% grid on;
% hold on
% set(gca,'YLim',[0 0.012])
% set(gca,'YTick',[0: 0.003: 0.012])
% set(gca,'XGrid','off');
% ch = get(b,'children');
% set(gca,'XTickLabel',{'5','15','30','50'},'Fontsize',fontsize,'linewidth',2);
% % set(gca,'XTickLabel',{'period=0.1','period=1','period=10','period=inf'},'Fontsize',fontsize);
% % set(ch,'FaceVertexCData',[1 0 1;0 0 0;])
%  
% % set(gca,'YTick',1:1:11);
% set(gca,'YTickLabel',{'0%','0.3%','0.6%','0.9%','1.2%'}, 'Fontsize',fontsize,'linewidth',2);
% set(gcf,'position',[200 200 600 350]) %分别代表x轴长度,y轴长度,图像长度,图像高度
% grid on
% set(gca,'units','normalized','position',[0.15 0.24 0.83 0.7],'box','on','Xgrid','on')
% %legend('最优结果','非最优结果');
% % xlabel('Probing interval (s)');
% xlabel('Number of packets');
% ylabel('MEM%');
% set(gca,'xcolor',[0 0 0]);
% set(gca,'ycolor',[0 0 0]);
% % set(gca, 'GridLineStyle', ':','ticklength',[0.005 0])





% 
% clc
% clear
% figure1 = figure('PaperSize',[20.98404194812 29.67743169791]);
% 
% fontsize=15;
% y=[0.2853,0.2674,0.2589,0.2561];
% b=bar(y, 'BarWidth', 0.6);
% set(b,'FaceColor', [119 172 48]/255)
% grid on;
% hold on
% set(gca,'YLim',[0.24 0.29])
% set(gca,'YTick',[0.24: 0.01: 0.29])
% set(gca,'XGrid','off');
% ch = get(b,'children');
% set(gca,'XTickLabel',{'period=0.1','period=1','period=10','period=inf'},'Fontsize',fontsize);
% % set(ch,'FaceVertexCData',[1 0 1;0 0 0;])
%  
% % set(gca,'YTick',1:1:11);
% set(gca,'YTickLabel',{'24%','25%','26%','27%','28%','29%'}, 'Fontsize',fontsize);
% set(gcf,'position',[200 200 600 350]) %分别代表x轴长度,y轴长度,图像长度,图像高度
% grid on
% set(gca,'units','normalized','position',[0.15 0.24 0.83 0.7],'box','on','Xgrid','on')
% %legend('最优结果','非最优结果');
% xlabel('Probing period (s)');
% ylabel('Average CUP%');
% set(gca,'xcolor',[0 0 0]);
% set(gca,'ycolor',[0 0 0]);
% set(gca, 'GridLineStyle', ':','ticklength',[0.005 0])  




% color_set=[0.12 0.24 0.88];
% 
% %bar的颜色索引
% 
% color_background=['c' 'm' 'y' 'k' 'r' 'g' 'b'];
% 
% %对figure的标题、横坐标、纵坐标的标注进行设置
% 
% hold on
% 
% title('Tiltle Name');
% 
% ylabel('Y label Name');
% 
% ax = gca;
% 
% ax.XTick = [1 2 3];
% 
% ax.XTickLabels = {'label1','label2','label3'};
% 
% %对不同的数据所对应的bar进行不同颜色条的设计
% 
% color_bar=bar(1,10);
% 
% set(color_bar,'FaceColor',color_background(1));%选择‘c’这个颜色
% 
% color_bar=bar(2,20);
% 
% set(color_bar,'FaceColor',color_background(2));%选择‘m’这个颜色
% 
% color_bar=bar(3,23);
% 
% set(color_bar,'FaceColor',color_background(3));%选择‘y’这个颜色