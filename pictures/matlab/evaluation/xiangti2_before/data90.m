
%boxplot����ͼ1
clc
clear
% fontsize=16;
fontsize=24;
fontsize1=22;
load dataKNN90_lcbe_bebe_lclc
load dataLR90_lcbe_bebe_lclc
load dataRFR90_lcbe_bebe_lclc
load dataSVR90_lcbe_bebe_lclc
load dataMLP90_lcbe_bebe_lclc
load dataESP90_lcbe_bebe_lclc
load dataPythia90_lcbe
%data_100=xlsread('boxplot_CPUcostatperiod.xls');
% data=data_100/100;
data1=dataKNN90_lcbe_bebe_lclc;
data2=dataLR90_lcbe_bebe_lclc;
data3=dataRFR90_lcbe_bebe_lclc;
data4=dataSVR90_lcbe_bebe_lclc;
data5=dataMLP90_lcbe_bebe_lclc;
data6=dataESP90_lcbe_bebe_lclc;
data7=dataPythia90_lcbe;
data1(isnan(data1))=0; %�������е�NAN�滻Ϊ0
data2(isnan(data2))=0; %�������е�NAN�滻Ϊ0 
data3(isnan(data3))=0; %�������е�NAN�滻Ϊ0
data4(isnan(data4))=0; %�������е�NAN�滻Ϊ0
data5(isnan(data5))=0; %�������е�NAN�滻Ϊ0
data6(isnan(data6))=0; %�������е�NAN�滻Ϊ0
data7(isnan(data7))=0; %�������е�NAN�滻Ϊ0 

axes1 = axes('Parent',figure,'YGrid','on');
hold(axes1,'all');
 
% plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
% 'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
% 'MarkerFaceColor',[255,127,255]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
% 'MarkerSize',16)
% hold on 
% plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
% 'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
% 'MarkerFaceColor',[255,255,127]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
% 'MarkerSize',16)
% plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
% 'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
% 'MarkerFaceColor',[127,127,127]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
% 'MarkerSize',16)
% hold on 
% plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
% 'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
% 'MarkerFaceColor',[127,127,255]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
% 'MarkerSize',16)
% plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
% 'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
% 'MarkerFaceColor',[127,255,127]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
% 'MarkerSize',16)
% hold on 
% plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
% 'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
% 'MarkerFaceColor',[127,255,255]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
% 'MarkerSize',16)
% plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
% 'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
% 'MarkerFaceColor',[255,127,127]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
% 'MarkerSize',16)
plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
'MarkerFaceColor',[49 49 49]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
'MarkerSize',16)
hold on 
plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
'MarkerFaceColor',[93 93 93]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
'MarkerSize',16)
plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
'MarkerFaceColor',[236 34 0]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
'MarkerSize',16)
hold on 
plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
'MarkerFaceColor',[133 133 133]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
'MarkerSize',16)
plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
'MarkerFaceColor',[169 169 169]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
'MarkerSize',16)
hold on 
plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
'MarkerFaceColor',[203 203 203]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
'MarkerSize',16)
plot([1 1],[2 2],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
'MarkerFaceColor',[255 255 255]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
'MarkerSize',16)

% hold on 
% bone_class_f=[data1(:,1);data1(:,2);data1(:,3)]; % combine into a column 
% G_f = [zeros(size(data1(:,1)))+1;zeros(size(data1(:,2)))+2;zeros(size(data1(:,3)))+3]; 
% box1 = boxplot(bone_class_f,G_f,'Colors','kkkk','positions',0.7:1:3,'width',0.09,'symbol','');
% 
% bone_class_f2=[data2(:,1);data2(:,2);data2(:,3)]; % combine into a column 
% G_f2 = [zeros(size(data2(:,1)))+1;zeros(size(data2(:,2)))+2;zeros(size(data2(:,3)))+3]; 
% box2 = boxplot(bone_class_f2,G_f2,'Colors','kkkk','positions',0.8:1:3.1,'width',0.09,'symbol','');
% 
% bone_class_f3=[data3(:,1);data3(:,2);data3(:,3)]; % combine into a column 
% G_f3 = [zeros(size(data3(:,1)))+1;zeros(size(data3(:,2)))+2;zeros(size(data3(:,3)))+3]; 
% box3 = boxplot(bone_class_f3,G_f3,'Colors','kkkk','positions',0.9:1:3.2,'width',0.09,'symbol','');
% 
% bone_class_f4=[data4(:,1);data4(:,2);data4(:,3)]; % combine into a column 
% G_f4 = [zeros(size(data4(:,1)))+1;zeros(size(data4(:,2)))+2;zeros(size(data4(:,3)))+3]; 
% box4 = boxplot(bone_class_f4,G_f4,'Colors','kkkk','positions',1:1:3.3,'width',0.09,'symbol','');
% 
% bone_class_f5=[data5(:,1);data5(:,2);data5(:,3)]; % combine into a column 
% G_f5 = [zeros(size(data5(:,1)))+1;zeros(size(data5(:,2)))+2;zeros(size(data5(:,3)))+3]; 
% box5 = boxplot(bone_class_f5,G_f5,'Colors','kkkk','positions',1.1:1:3.4,'width',0.09,'symbol','');
% 
% bone_class_f6=[data6(:,1);data6(:,2);data6(:,3)]; % combine into a column 
% G_f6 = [zeros(size(data6(:,1)))+1;zeros(size(data6(:,2)))+2;zeros(size(data6(:,3)))+3]; 
% box6 = boxplot(bone_class_f6,G_f6,'Colors','kkkk','positions',1.2:1:3.5,'width',0.09,'symbol','');
%  
% bone_class_f7=[data7(:,1);data7(:,2);data7(:,3)]; % combine into a column 
% G_f7 = [zeros(size(data7(:,1)))+1;zeros(size(data7(:,2)))+2;zeros(size(data7(:,3)))+3]; 
% box7 = boxplot(bone_class_f7,G_f7,'Colors','kkkk','positions',1.3:1:3.6,'width',0.09,'symbol','');
hold on 
bone_class_f=[data1(:,1);data1(:,2);data1(:,3)]; % combine into a column 
G_f = [zeros(size(data1(:,1)))+1;zeros(size(data1(:,2)))+2;zeros(size(data1(:,3)))+3]; 
box1 = boxplot(bone_class_f,G_f,'Colors','kkkk','positions',0.75:0.8:3,'width',0.1,'symbol','');

bone_class_f2=[data2(:,1);data2(:,2);data2(:,3)]; % combine into a column 
G_f2 = [zeros(size(data2(:,1)))+1;zeros(size(data2(:,2)))+2;zeros(size(data2(:,3)))+3]; 
box2 = boxplot(bone_class_f2,G_f2,'Colors','kkkk','positions',0.85:0.8:3.1,'width',0.1,'symbol','');

bone_class_f3=[data3(:,1);data3(:,2);data3(:,3)]; % combine into a column 
G_f3 = [zeros(size(data3(:,1)))+1;zeros(size(data3(:,2)))+2;zeros(size(data3(:,3)))+3]; 
box3 = boxplot(bone_class_f3,G_f3,'Colors','kkkk','positions',0.95:0.8:3.2,'width',0.1,'symbol','');

bone_class_f4=[data4(:,1);data4(:,2);data4(:,3)]; % combine into a column 
G_f4 = [zeros(size(data4(:,1)))+1;zeros(size(data4(:,2)))+2;zeros(size(data4(:,3)))+3]; 
box4 = boxplot(bone_class_f4,G_f4,'Colors','kkkk','positions',1.05:0.8:3.3,'width',0.1,'symbol','');

bone_class_f5=[data5(:,1);data5(:,2);data5(:,3)]; % combine into a column 
G_f5 = [zeros(size(data5(:,1)))+1;zeros(size(data5(:,2)))+2;zeros(size(data5(:,3)))+3]; 
box5 = boxplot(bone_class_f5,G_f5,'Colors','kkkk','positions',1.15:0.8:3.4,'width',0.1,'symbol','');

bone_class_f6=[data6(:,1);data6(:,2);data6(:,3)]; % combine into a column 
G_f6 = [zeros(size(data6(:,1)))+1;zeros(size(data6(:,2)))+2;zeros(size(data6(:,3)))+3]; 
box6 = boxplot(bone_class_f6,G_f6,'Colors','kkkk','positions',1.25:0.8:3.5,'width',0.1,'symbol','');
 
bone_class_f7=[data7(:,1);data7(:,2);data7(:,3)]; % combine into a column 
G_f7 = [zeros(size(data7(:,1)))+1;zeros(size(data7(:,2)))+2;zeros(size(data7(:,3)))+3]; 
box7 = boxplot(bone_class_f7,G_f7,'Colors','kkkk','positions',1.35:0.8:3.6,'width',0.1,'symbol','');

h = findobj(gca,'Tag','Box'); 
% colorlist ={'r','r','r','c','c','c','g','g','g','b','b','b','k','k','k','y','y','y','m','m','m'};
colorlist ={[255 255 255]/255,[255 255 255]/255,[255 255 255]/255,...
    [203 203 203]/255,[203 203 203]/255,[203 203 203]/255,...
    [169 169 169]/255,[169 169 169]/255,[169 169 169]/255,...
    [133 133 133]/255,[133 133 133]/255,[133 133 133]/255,...
    [236 34 0]/255,[236 34 0]/255,[236 34 0]/255,...
    [93 93 93]/255,[93 93 93]/255,[93 93 93]/255,...
    [49 49 49]/255,[49 49 49]/255,[49 49 49]/255};
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
set(gca,'YLim',[0 0.6])
set(gca,'YTick', [0:0.15:0.6]); % ����X��ļǺŵ�
set(gca,'yTickLabel',[0:0.15:0.6]*100,'Fontsize',fontsize1);
% set(gca,'XLim',[0.5 3.5])
% set(gca, 'XTick', [1,2,3]); % ����X��ļǺŵ�
set(gca,'XLim',[0.5 3.1])
set(gca, 'XTick', [1.05,1.85,2.65]); % ����X��ļǺŵ�
set(gca,'XTickLabel',{'LS+SC/BG','SC+SC/BG','LS+LS'},'Fontsize',fontsize1);
% set(gca,'units','normalized','position',[0.075 0.25 0.92 0.7],'box','on')
% set(gca,'units','normalized','position',[0.078 0.14 0.92 0.72],'box','on')
set(gca,'units','normalized','position',[0.1 0.18 0.89 0.62],'box','on')
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0]) 
% set(gcf,'position',[200 200 800 250]) %�ֱ����x�᳤��,y�᳤��,ͼ�񳤶�,ͼ��߶�
set(gcf,'position',[200 200 800 250]) %�ֱ����x�᳤��,y�᳤��,ͼ�񳤶�,ͼ��߶�
grid on
ll=legend('IKNN','ILR','IRFR','ISVR','IMLP','ESP','Pythia') 
% set(ll,'Fontsize',14,'Orientation','horizon')
set(ll,...
    'Position',[0.0866598767104245 0.877721102555354 0.868749987408519 0.123999996781349],...
    'Orientation','horizontal',...
    'FontSize',20);