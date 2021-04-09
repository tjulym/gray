
%boxplot箱线图1
clc
clear
fontsize=16;
load dataKNN90_lcbe_bebe_lclc
load dataLR90_lcbe_bebe_lclc
load dataRFR90_lcbe_bebe_lclc
load dataSVR90_lcbe_bebe_lclc
load dataMLP90_lcbe_bebe_lclc
% load dataESP90_lcbe_bebe_lclc
% load dataPythia90_lcbe
%data_100=xlsread('boxplot_CPUcostatperiod.xls');
% data=data_100/100;
data1=dataKNN90_lcbe_bebe_lclc;
data2=dataLR90_lcbe_bebe_lclc;
data3=dataRFR90_lcbe_bebe_lclc;
data4=dataSVR90_lcbe_bebe_lclc;
data5=dataMLP90_lcbe_bebe_lclc;
% data6=dataESP90_lcbe_bebe_lclc;
% data7=dataPythia90_lcbe;
data1(isnan(data1))=0; %将数据中的NAN替换为0
data2(isnan(data2))=0; %将数据中的NAN替换为0 
data3(isnan(data3))=0; %将数据中的NAN替换为0
data4(isnan(data4))=0; %将数据中的NAN替换为0
data5(isnan(data5))=0; %将数据中的NAN替换为0
% data6(isnan(data6))=0; %将数据中的NAN替换为0
% data7(isnan(data7))=0; %将数据中的NAN替换为0 

axes1 = axes('Parent',figure,'YGrid','on');
hold(axes1,'all');
 
plot([10 10],[12 12],'s','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[255,127,255]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[255,127,255]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)
hold on 
plot([10 10],[12 12],'s','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[255,255,127]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[255,255,127]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)
hold on
plot([10 10],[12 12],'s','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[127,127,127]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[127,127,127]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)
hold on 
plot([10 10],[12 12],'s','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[127,127,255]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[127,127,255]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)
hold on
plot([10 10],[12 12],'s','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[127,255,127]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[127,255,127]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)
% hold on 
% plot([1 1],[2 2],'s','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
% 'MarkerEdgeColor',[127,255,255]/255,... %marker边缘颜色设du定为黑色
% 'MarkerFaceColor',[127,255,255]/255,... %marker内部颜色设定为绿色
% 'MarkerSize',16)
% hold on 
% plot([1 1],[2 2],'s','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
% 'MarkerEdgeColor',[255,127,127]/255,... %marker边缘颜色设du定为黑色
% 'MarkerFaceColor',[255,127,127]/255,... %marker内部颜色设定为绿色
% 'MarkerSize',16)

hold on 
bone_class_f=[data1(:,1);data1(:,2);data1(:,3)]; % combine into a column 
G_f = [zeros(size(data1(:,1)))+1;zeros(size(data1(:,2)))+2;zeros(size(data1(:,3)))+3]; 
box1 = boxplot(bone_class_f,G_f,'Colors','kkkk','positions',0.7:1:3,'width',0.1,'symbol','');

bone_class_f2=[data2(:,1);data2(:,2);data2(:,3)]; % combine into a column 
G_f2 = [zeros(size(data2(:,1)))+1;zeros(size(data2(:,2)))+2;zeros(size(data2(:,3)))+3]; 
box2 = boxplot(bone_class_f2,G_f2,'Colors','kkkk','positions',0.8:1:3.1,'width',0.1,'symbol','');

bone_class_f3=[data3(:,1);data3(:,2);data3(:,3)]; % combine into a column 
G_f3 = [zeros(size(data3(:,1)))+1;zeros(size(data3(:,2)))+2;zeros(size(data3(:,3)))+3]; 
box3 = boxplot(bone_class_f3,G_f3,'Colors','kkkk','positions',0.9:1:3.2,'width',0.1,'symbol','');

bone_class_f4=[data4(:,1);data4(:,2);data4(:,3)]; % combine into a column 
G_f4 = [zeros(size(data4(:,1)))+1;zeros(size(data4(:,2)))+2;zeros(size(data4(:,3)))+3]; 
box4 = boxplot(bone_class_f4,G_f4,'Colors','kkkk','positions',1:1:3.3,'width',0.1,'symbol','');

bone_class_f5=[data5(:,1);data5(:,2);data5(:,3)]; % combine into a column 
G_f5 = [zeros(size(data5(:,1)))+1;zeros(size(data5(:,2)))+2;zeros(size(data5(:,3)))+3]; 
box5 = boxplot(bone_class_f5,G_f5,'Colors','kkkk','positions',1.1:1:3.4,'width',0.1,'symbol','');

% bone_class_f6=[data6(:,1);data6(:,2);data6(:,3)]; % combine into a column 
% G_f6 = [zeros(size(data6(:,1)))+1;zeros(size(data6(:,2)))+2;zeros(size(data6(:,3)))+3]; 
% box6 = boxplot(bone_class_f6,G_f6,'Colors','kkkk','positions',1.2:1:3.5,'width',0.1,'symbol','');
%  
% bone_class_f7=[data7(:,1);data7(:,2);data7(:,3)]; % combine into a column 
% G_f7 = [zeros(size(data7(:,1)))+1;zeros(size(data7(:,2)))+2;zeros(size(data7(:,3)))+3]; 
% box7 = boxplot(bone_class_f7,G_f7,'Colors','kkkk','positions',1.3:1:3.6,'width',0.1,'symbol','');

h = findobj(gca,'Tag','Box'); 
% colorlist ={'r','r','r','c','c','c','g','g','g','b','b','b','k','k','k','y','y','y','m','m','m'};
colorlist ={'g','g','g','b','b','b','k','k','k','y','y','y','m','m','m'};
for m=1:length(h)
    patch(get(h(m),'XData'),get(h(m),'YData'),cell2mat(colorlist(m)),'FaceAlpha',.5);
end
set(box1,'lineWidth',1)
set(box2,'lineWidth',1)
% xlabel('Combination','Fontsize',fontsize);
% ylabel('Prediction Error (%)','Fontsize',fontsize);
ylabel('Error (%)','Fontsize',fontsize);
set(gca,'xcolor',[0 0 0],'Fontsize',fontsize);
set(gca,'ycolor',[0 0 0],'Fontsize',fontsize);
% set(gca,'YLim',[0 0.6])
% set(gca,'YTick', [0:0.15:0.6]); % 添加X轴的记号点
% set(gca,'yTickLabel',[0:0.15:0.6]*100,'Fontsize',fontsize);
set(gca,'YLim',[0 2])
set(gca,'YTick', [0:0.25:2]); % 添加X轴的记号点
set(gca,'yTickLabel',[0:0.25:2]*100,'Fontsize',fontsize);
% set(gca,'XLim',[0.5 3.5])
% set(gca, 'XTick', [1,2,3]); % 添加X轴的记号点
set(gca,'XLim',[0.5 3.5])
set(gca, 'XTick', [0.9,1.9,2.9]); % 添加X轴的记号点
set(gca,'XTickLabel',{'90th latency','95th latency','99th latency'},'Fontsize',fontsize);
% set(gca,'units','normalized','position',[0.075 0.25 0.92 0.7],'box','on')
set(gca,'units','normalized','position',[0.09 0.15 0.9 0.8],'box','on')
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0]) 
% set(gcf,'position',[200 200 800 250]) %分别代表x轴长度,y轴长度,图像长度,图像高度
set(gcf,'position',[200 200 800 250]) %分别代表x轴长度,y轴长度,图像长度,图像高度
grid on
% ll=legend('IKNN','ILR','IRFR','ISVR','IMLP','ESP','Pythia') 
ll=legend('IKNN','ILR','IRFR','ISVR','IMLP') 
set(ll,'Fontsize',14,'Orientation','horizon')
set(ll,...
    'Position',[0.096109927527529 0.819721102376541 0.577499992288649 0.111999997138977],...
    'Orientation','horizontal',...
    'FontSize',14);
