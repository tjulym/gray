clc
clear
figure1 = figure('PaperSize',[20.98404194812 29.67743169791]);

% function createfigure
%CREATEFIGURE

%  �� MATLAB �� 01-Aug-2020 13:29:45 �Զ�����

% ���� figure
% figure1 = figure;

% ���� axes
axes1 = axes('Parent',figure1);
axis off

u=[42,33,14,11]
pie(u)

% pie ��ǰ��֧�ִ������ɣ���������ȷ�����﷨��Ӧ�� 'doc pie'
% pie(...);

% pie ��ǰ��֧�ִ������ɣ���������ȷ�����﷨��Ӧ�� 'doc pie'
% pie(...);

% pie ��ǰ��֧�ִ������ɣ���������ȷ�����﷨��Ӧ�� 'doc pie'
% pie(...);

% pie ��ǰ��֧�ִ������ɣ���������ȷ�����﷨��Ӧ�� 'doc pie'
% pie(...);

% pie ��ǰ��֧�ִ������ɣ���������ȷ�����﷨��Ӧ�� 'doc pie'
% pie(...);

% pie ��ǰ��֧�ִ������ɣ���������ȷ�����﷨��Ӧ�� 'doc pie'
% pie(...);

% pie ��ǰ��֧�ִ������ɣ���������ȷ�����﷨��Ӧ�� 'doc pie'
% pie(...);

% ȡ�������е�ע���Ա����������� X ��Χ
% xlim(axes1,[-1.2 1.2]);
% ȡ�������е�ע���Ա����������� Y ��Χ
% ylim(axes1,[-1.2 1.2]);
% ������������������

set(gcf,'position',[200 200 400 340])
grid on
% set(gca,'units','normalized','position',[0.01 0.2 1.0 0.87],'box','on','Xgrid','on')
set(gca,'units','normalized','position',[0.18 0.20 0.6 0.87],'box','on','Xgrid','on')

set(axes1,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1.2 1.2 1]);
% ���� legend
% legend1 = legend(axes1,'show');
% set(legend1,...
%     'Position',[0.554166684503707 0.0448412907502067 0.416071418885672 0.174999995174862],...
%     'FontSize',10);

legend1 = legend('Site infrastructure capital costs','IT capital costs','Other operating expenses','Energy costs');
set(legend1,...
    'Position',[0.554166684503707 0.0448412907502067 0.416071418885672 0.174999995174862],...
    'FontSize',16);

