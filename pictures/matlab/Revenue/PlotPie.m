clc
clear
figure1 = figure('PaperSize',[20.98404194812 29.67743169791]);

% function createfigure
%CREATEFIGURE

%  由 MATLAB 于 01-Aug-2020 13:29:45 自动生成

% 创建 figure
% figure1 = figure;

% 创建 axes
axes1 = axes('Parent',figure1);
axis off

u=[42,33,14,11]
pie(u)

% pie 当前不支持代码生成，请输入正确输入语法对应的 'doc pie'
% pie(...);

% pie 当前不支持代码生成，请输入正确输入语法对应的 'doc pie'
% pie(...);

% pie 当前不支持代码生成，请输入正确输入语法对应的 'doc pie'
% pie(...);

% pie 当前不支持代码生成，请输入正确输入语法对应的 'doc pie'
% pie(...);

% pie 当前不支持代码生成，请输入正确输入语法对应的 'doc pie'
% pie(...);

% pie 当前不支持代码生成，请输入正确输入语法对应的 'doc pie'
% pie(...);

% pie 当前不支持代码生成，请输入正确输入语法对应的 'doc pie'
% pie(...);

% 取消以下行的注释以保留坐标区的 X 范围
% xlim(axes1,[-1.2 1.2]);
% 取消以下行的注释以保留坐标区的 Y 范围
% ylim(axes1,[-1.2 1.2]);
% 设置其余坐标区属性

set(gcf,'position',[200 200 400 340])
grid on
% set(gca,'units','normalized','position',[0.01 0.2 1.0 0.87],'box','on','Xgrid','on')
set(gca,'units','normalized','position',[0.18 0.20 0.6 0.87],'box','on','Xgrid','on')

set(axes1,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1.2 1.2 1]);
% 创建 legend
% legend1 = legend(axes1,'show');
% set(legend1,...
%     'Position',[0.554166684503707 0.0448412907502067 0.416071418885672 0.174999995174862],...
%     'FontSize',10);

legend1 = legend('Site infrastructure capital costs','IT capital costs','Other operating expenses','Energy costs');
set(legend1,...
    'Position',[0.554166684503707 0.0448412907502067 0.416071418885672 0.174999995174862],...
    'FontSize',16);

