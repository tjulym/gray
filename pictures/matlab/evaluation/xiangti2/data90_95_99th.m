%99th
%boxplot箱线图1
clc
clear
fontsize=24;
fontsize1=22;
load RFR90th
load RFR95th
load RFR99th

data1=RFR90th;
data2=RFR95th;
data3=RFR99th;

data1(isnan(data1))=0; %将数据中的NAN替换为0
data2(isnan(data2))=0; %将数据中的NAN替换为0 
data3(isnan(data3))=0; %将数据中的NAN替换为0

axes1 = axes('Parent',figure,'YGrid','on');
hold(axes1,'all');
 
%给图例上色
plot([1 1],[2 2],'s','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[63 62 64]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[63 62 64]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)
hold on 
plot([1 1],[2 2],'s','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[63 62 64]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[191 192 195]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)
plot([1 1],[2 2],'s','LineWidth',2,... %线型为红色bai虚线，marker为方框，线粗细设定为2
'MarkerEdgeColor',[63 62 64]/255,... %marker边缘颜色设du定为黑色
'MarkerFaceColor',[255 255 255]/255,... %marker内部颜色设定为绿色
'MarkerSize',16)

hold on 
bone_class_f=[data1(:,1)];
G_f = [zeros(size(data1(:,1)))+1]; 
% bone_class_f=[data1(:,1);data1(:,2);data1(:,3)]; % combine into a column   
% G_f = [zeros(size(data1(:,1)))+1;zeros(size(data1(:,2)))+2;zeros(size(data1(:,3)))+3]; 
box1 = boxplot(bone_class_f,G_f,'Colors','kkkk','positions',0.7,'width',0.1,'symbol','');

bone_class_f2=[data2(:,1)];
G_f2 = [zeros(size(data2(:,1)))+1]; 
% bone_class_f2=[data2(:,1);data2(:,2);data2(:,3)]; % combine into a column 
% G_f2 = [zeros(size(data2(:,1)))+1;zeros(size(data2(:,2)))+2;zeros(size(data2(:,3)))+3]; 
box2 = boxplot(bone_class_f2,G_f2,'Colors','kkkk','positions',0.8,'width',0.1,'symbol','');

bone_class_f3=[data3(:,1)];
G_f3 = [zeros(size(data3(:,1)))+1]; 
% bone_class_f3=[data3(:,1);data3(:,2);data3(:,3)]; % combine into a column 
% G_f3 = [zeros(size(data3(:,1)))+1;zeros(size(data3(:,2)))+2;zeros(size(data3(:,3)))+3]; 
box3 = boxplot(bone_class_f3,G_f3,'Colors','kkkk','positions',0.9,'width',0.1,'symbol','');

h = findobj(gca,'Tag','Box'); 
% colorlist ={'r','r','r','c','c','c','g','g','g','b','b','b','k','k','k','y','y','y','m','m','m'};
% colorlist ={'k','y','m'};
colorlist ={[255 255 255]/255,[191 192 195]/255,[63 62 64]/255};
for m=1:length(h)
    patch(get(h(m),'XData'),get(h(m),'YData'),cell2mat(colorlist(m)),'FaceAlpha',.5);
end
set(box1,'lineWidth',1)
set(box2,'lineWidth',1)
% xlabel('Combination','Fontsize',fontsize);
% ylabel('Prediction Error (%)','Fontsize',fontsize);
ylabel('Error (%)','Fontsize',fontsize);
set(gca,'xcolor',[0 0 0],'Fontsize',fontsize1);
set(gca,'ycolor',[0 0 0],'Fontsize',fontsize1);
% set(gca,'YLim',[0 0.6])
% set(gca,'YTick', [0:0.15:0.6]); % 添加X轴的记号点
% set(gca,'yTickLabel',[0:0.15:0.6]*100,'Fontsize',fontsize);
set(gca,'YLim',[0 1])
set(gca,'YTick', [0:0.25:1]); % 添加X轴的记号点
set(gca,'yTickLabel',[0:0.25:1]*100,'Fontsize',fontsize1);
% set(gca,'XLim',[0.5 3.5])
% set(gca, 'XTick', [1,2,3]); % 添加X轴的记号点
% set(gca,'XTickLabel',{'LC+BE','BE+BE','LC+LC'},'Fontsize',fontsize);
set(gca,'XLim',[0.4 1.2])
set(gca, 'XTick', [0.8]); % 添加X轴的记号点
set(gca,'XTickLabel',{'Latency (ms)'},'Fontsize',fontsize1);
% set(gca,'units','normalized','position',[0.075 0.25 0.92 0.7],'box','on')
% set(gca,'units','normalized','position',[0.075 0.25 0.92 0.7],'box','on')
set(gca,'units','normalized','position',[0.24 0.18 0.75 0.77],'box','on')
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0]) 
% set(gcf,'position',[200 200 800 250]) %分别代表x轴长度,y轴长度,图像长度,图像高度
% set(gcf,'position',[200 200 800 250]) %分别代表x轴长度,y轴长度,图像长度,图像高度
set(gcf,'position',[200 200 400 250]) %分别代表x轴长度,y轴长度,图像长度,图像高度
grid on
% ll=legend('IKNN','ILR','IRFR','ISVR','IMLP','ESP','Pythia') 
ll=legend('90%','95%','99%') 
% ll=legend('IMLP','ISVR','IRFR','ILR','IKNN') 
set(ll,'Fontsize',20,'Orientation','horizon')
set(ll,...
    'Position',[0.720781253771856 0.522355744985479 0.262499995976687 0.415999988198281],...
    'Orientation','vertical',...
    'FontSize',20);
