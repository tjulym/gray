
%boxplot����ͼ1
clc
clear
% fontsize=16;
fontsize=24;
fontsize1=22;
load data90thCompare
load data95thCompare
load data99thCompare

data1=data90thCompare;
data2=data95thCompare;
data3=data99thCompare;
data1(isnan(data1))=0; %�������е�NAN�滻Ϊ0
data2(isnan(data2))=0; %�������е�NAN�滻Ϊ0 
data3(isnan(data3))=0; %�������е�NAN�滻Ϊ0

axes1 = axes('Parent',figure,'YGrid','on','LineWidth',2);
hold(axes1,'all');
 
%��ͼ����ɫ
plot([1 1],[20 20],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
'MarkerFaceColor',[238 41 47]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
'MarkerSize',16)
hold on 
plot([1 1],[20 20],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
'MarkerFaceColor',[63 62 64]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
'MarkerSize',16)
plot([1 1],[20 20],'s','LineWidth',2,... %����Ϊ��ɫbai���ߣ�markerΪ�����ߴ�ϸ�趨Ϊ2
'MarkerEdgeColor',[63 62 64]/255,... %marker��Ե��ɫ��du��Ϊ��ɫ
'MarkerFaceColor',[255 255 255]/255,... %marker�ڲ���ɫ�趨Ϊ��ɫ
'MarkerSize',16)

hold on 
bone_class_f=[data1(:,1);data1(:,2);data1(:,3)]; % combine into a column 
G_f = [zeros(size(data1(:,1)))+1;zeros(size(data1(:,2)))+2;zeros(size(data1(:,3)))+3]; 
box1 = boxplot(bone_class_f,G_f,'Colors','kkkk','positions',0.6:1:3,'width',0.2,'symbol','');

bone_class_f2=[data2(:,1);data2(:,2);data2(:,3)]; % combine into a column 
G_f2 = [zeros(size(data2(:,1)))+1;zeros(size(data2(:,2)))+2;zeros(size(data2(:,3)))+3]; 
box2 = boxplot(bone_class_f2,G_f2,'Colors','kkkk','positions',0.8:1:3.2,'width',0.2,'symbol','');

bone_class_f3=[data3(:,1);data3(:,2);data3(:,3)]; % combine into a column 
G_f3 = [zeros(size(data3(:,1)))+1;zeros(size(data3(:,2)))+2;zeros(size(data3(:,3)))+3]; 
box3 = boxplot(bone_class_f3,G_f3,'Colors','kkkk','positions',1.0:1:3.4,'width',0.2,'symbol','');

h = findobj(gca,'Tag','Box'); 
% colorlist ={'r','r','r','c','c','c','g','g','g','b','b','b','k','k','k','y','y','y','m','m','m'};
% colorlist ={'k','k','k','y','y','y','m','m','m'};
% colorlist ={[255 255 255]/255,[255 255 255]/255,[255 255 255]/255,...
%     [191 192 195]/255,[191 192 195]/255,[191 192 195]/255,...
%     [63 62 64]/255,[63 62 64]/255,[63 62 64]/255};
colorlist ={[255 255 255]/255,[255 255 255]/255,[255 255 255]/255,...
    [63 62 64]/255,[63 62 64]/255,[63 62 64]/255,...
    [238 41 47]/255,[238 41 47]/255,[238 41 47]/255};
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
set(gca,'YLim',[0 2])
set(gca,'YTick', [0:0.5:2]); % ���Y��ļǺŵ�
set(gca,'yTickLabel',[0:0.5:2]*100,'Fontsize',fontsize1);
set(gca,'XLim',[0.3 3.3])
set(gca, 'XTick', [0.8,1.8,2.8]); % ���X��ļǺŵ�
set(gca,'XTickLabel',{'90%ile','95%ile','99%ile'},'Fontsize',fontsize1);
set(gca,'units','normalized','position',[0.24 0.18 0.75 0.62],'box','on')
% set(gca,'units','normalized','position',[0.24 0.18 0.75 0.6],'box','on')
% set(gca,'units','normalized','position',[0.075 0.25 0.92 0.7],'box','on')
set(gca, 'GridLineStyle', ':','ticklength',[0.005 0]) 
set(gcf,'position',[200 200 400 250]) %�ֱ����x�᳤��,y�᳤��,ͼ�񳤶�,ͼ��߶�
% set(gcf,'position',[200 200 800 250]) %�ֱ����x�᳤��,y�᳤��,ͼ�񳤶�,ͼ��߶�
grid on
% ll=legend('IKNN','ILR','IRFR','ISVR','IMLP','ESP','Pythia') 
ll=legend('Gsight-IRFR','ESP','Pythia') 
set(ll,...
    'Position',[0.00708154458558624 0.832825188457969 0.987499981969595 0.135999996423721],...
    'Orientation','horizontal',...
    'FontSize',17.5);