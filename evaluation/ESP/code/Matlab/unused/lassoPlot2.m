function [axh,figh] = lassoPlot2( B, plotData, varargin )
%LASSOPLOT Plot coefficient values or goodness of fit of lasso or elastic net fits. 
%  [AXH,FIGH] = LASSOPLOT(B, PLOTDATA) creates a Trace Plot showing the
%  sequence of coefficient values B produced by a lasso or elastic net fit.
%  B is a P by nLambda matrix of coefficients, with each column of B
%  representing a set of coefficients estimated by LASSO or LASSOGLM 
%  using a single penalty term Lambda.  AXH is an axes handle that gives
%  access to the axes used to plot the coefficient values B.  FIGH is a
%  handle to the figure window.
%
%  [AXH,FIGH] = LASSOPLOT(B) plots all the coefficient values contained in B 
%  against the L1-norm of B. The L1-norm is the  sum of the absolute value of 
%  all the coefficients. The plot is also annotated with the number of
%  non-zero coefficients of B ("df"), displayed along the top axis of 
%  the plot.
%
%  [AXH,FIGH] = LASSOPLOT(B,PLOTDATA) creates a plot with contents dependent
%  on the type of PLOTDATA.
%
%     If PLOTDATA is a vector, then
%     LASSOPLOT(B,PLOTDATA) uses the values of PLOTDATA to form the x-axis
%     of the plot, rather than the L1-norm of B. In this case, PLOTDATA 
%     must have the same length as the number of columns as B.
%
%     If PLOTDATA is a struct, then
%     LASSOPLOT(B,PLOTDATA,'PlotType',val) allows you to control aspects of
%     the plot depending on the value of the optional argument 'PlotType'.
%     The possible values for 'PlotType' are:
%
%        'L1'      The x-axis of the plot is formed from the L1-norm of
%                  the coefficients in B. This is the default plot. 
%
%        'Lambda'  The x-axis of the plot is formed from the values of
%                  the field named 'Lambda' in PLOTDATA.
%
%        'CV'      A different kind of plot is produced showing, for each
%                  lambda, an estimate of the goodness of fit on new data
%                  for the model fitted by lasso or elastic net with that
%                  value of lambda, plus error bars for the estimate. 
%                  For fits performed by LASSO, the goodness of fit is MSE,
%                  or mean squared prediction error. For fits performed by
%                  LASSOGLM, the goodness of fit criterion is Deviance,
%                  the goodness of fit measure used by GLMFIT.
%                  The 'CV' plot also indicates the value for lambda with
%                  the minimum cross-validated measure of goodness of fit, 
%                  and the greatest lambda (thus sparsest model) that is 
%                  within one standard error of the minimum goodness of fit.
%                  The 'CV' plot type is valid only if PLOTDATA was produced
%                  by a call to LASSO or LASSOGLM with cross-validation
%                  enabled. 
% 
%
%  LASSOPLOT(...,'PARAM',val)
%
%     'PredictorNames' A cell array of strings to label each of the coefficients
%                      of B. Default: {'B1', 'B2', ...}. If PREDICTORNAMES is of
%                      length less than the number of rows of B, the remaining
%                      labels will be padded with default values. 
%
%     'XScale'         'linear' for linear x-axis (Default),
%                      'log' for logarithmic scale on the x-axis.
%
%     'Parent'         Axes in which to draw the plot. 
%
%
%  Examples:
%
%     % Run the lasso on data obtained from the 1985 Auto Imports Database 
%     % of the UCI repository.  
%     % http://archive.ics.uci.edu/ml/machine-learning-databases/autos/imports-85.names
%     load imports-85;
%     Description
%
%     % Extract Price as the response variable and extract non-categorical
%     % variables related to auto construction and performance
%     %
%     X = X(~any(isnan(X(:,1:16)),2),:);
%     Y = X(:,16);
%     Y = log(Y);
%     X = X(:,3:15);
%     predictorNames = {'wheel-base' 'length' 'width' 'height' ...
%         'curb-weight' 'engine-size' 'bore' 'stroke' 'compression-ratio' ...
%         'horsepower' 'peak-rpm' 'city-mpg' 'highway-mpg'};
%
%     % Compute the default sequence of lasso fits.
%     [B,S] = lasso(X,Y,'CV',10,'PredictorNames',predictorNames);
%
%     % Display a trace plot of the lasso fits.
%     axTrace = lassoPlot(B,S);
%
%     % Display the sequence of cross-validated predictive MSEs.
%     axCV = lassoPlot(B,S,'PlotType','CV');
%
%   See also lasso, lassoglm, glmfit.

%   Copyright 2011-2012 The MathWorks, Inc.

if nargin<1
    error(message('stats:lassoPlot:NoArg'));
end

if ~ismatrix(B) || ~isnumeric(B) || ~isreal(B)
    error(message('stats:lassoPlot:BnotMatrix'));
end

% We treat all non-finite values the same.
B(~isfinite(B)) = NaN;

if nargin-length(varargin) == 1
    
    plotData = [];
    plotType = 'L1';
    xvals = nansum(abs(B),1);
    xvals(all(isnan(B),1)) = NaN;
    xscale   = 'linear';
    xdir     = 'normal';
    xlabel   = 'L1';
    ax1      = [];
    predictorNames = {};
    
else
    
    clArgs = processCommandLine(B, plotData, varargin{:});
    
    plotData = clArgs.plotData;
    plotType = clArgs.plotType;
    xvals    = clArgs.xvals;
    xscale   = clArgs.xscale;
    xdir     = clArgs.xdir;
    xlabel   = clArgs.xlabel;
    ax1      = clArgs.ax1;
    predictorNames = clArgs.predictorNames;
    criterionName  = clArgs.criterionName;
    lambdaMinName  = clArgs.lambdaMinName;
    indexMinName   = clArgs.indexMinName;
    
end

% If PredictorNames is empty or is shorter than the number of coefficients
% in B, we pad with strings of type 'B*' where '*' is the index for each 
% unassigned predictor name. If PredictorNames is supplied and is longer than
% the number of coefficients in B, we ignore the excess.
pad = length(predictorNames) + 1;
ncoef = size(B,1);
if pad <= ncoef
    cs = cellstr(strcat('B',int2str((pad:ncoef)')));
    for i=1:length(cs)
        csi=cs{i};
        cs{i} = csi(csi ~= ' ');
    end
    predictorNames = [predictorNames(:); cs]';
end

%
% Generate the Plot
% 

if isempty(ax1)
    figureHandle = figure;
    ax1 = axes('Visible','off');
else
    if ~ishandle(ax1) || ~isequal(get(ax1,'Type'),'axes')
        error(message('stats:lassoPlot:BadAxes'));
    end
    figureHandle = ancestor(ax1,'Figure');
end

dch = datacursormode(figureHandle);

if isequal(plotType,'CV')
    
    % Plot GoF Criterion (eg, MSE, Deviance) vs. Lambda with error bars
    %
    xvals = plotData.Lambda;
    criterion   = plotData.(criterionName);
    se    = plotData.SE;
    if isempty(xscale)
        xscale = 'log';
    end
    
    h = errorbar(ax1,xvals,criterion,se);    
    set(h,'color',[.7 .7 .7],'Marker','.','MarkerEdgeColor','red','LineStyle','none', ...
        'DisplayName',getString(message('stats:lassoPlot:CVPlot_LegendDisplay_ErrorBar',criterionName)), ...
        'Tag',criterionName);
    
    set(ax1,'XScale',xscale);
    set(ax1,'XDir',xdir);
    set(get(ax1,'XLabel'),'String',xlabel);
    set(get(ax1,'YLabel'),'String',criterionName);
    if plotData.Alpha == 1
        title(ax1, getString(message('stats:lassoPlot:CVPlot_FigureName_Lasso', criterionName)));
    else
        theTitle = cell(2,1);
        theTitle{1} = getString(message('stats:lassoPlot:CVPlot_FigureName_ElasticNet', criterionName));
        theTitle{2} = sprintf('Alpha = %s', num2str(plotData.Alpha));
        title(ax1,theTitle);
    end
        
    % Add extra graphics elements at the LambdaMin[Criterion] and Lambda1SE locations
    % and tag these elements lines so that the data cursor can recognize them.
    %    
    hold(ax1,'on');
    l4 = plot(ax1,xvals(plotData.(indexMinName)),criterion(plotData.(indexMinName)), ...
        'marker','o','color',[0 .40 0],'linestyle','none');
    l3 = plot(ax1,xvals(plotData.Index1SE),criterion(plotData.Index1SE), ...
        'marker','o','color','b','linestyle','none');
    l2 = plot(ax1,plotData.(lambdaMinName)*[1 1], ...
        get(ax1,'YLim'), 'LineStyle',':', 'Color',[0 .80 0]);
    l1 = plot(ax1,plotData.Lambda1SE*[1 1], ...
        get(ax1,'YLim'), 'LineStyle',':', 'Color',[0 0 1]);
    hold(ax1,'off');
    
    set(l4,'Tag',lambdaMinName,'DisplayName',lambdaMinName);
    set(l3,'Tag','Lambda1SE','DisplayName','Lambda1SE');
    set(l2,'Tag',lambdaMinName);
    set(l1,'Tag','Lambda1SE');
    set(get(get(l1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    set(get(get(l2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    
    set(dch,'Enable','off');
    set(dch,'UpdateFcn', ...
        {@cvCursor, plotData, criterionName, lambdaMinName, indexMinName});

else
    
    % Generate a Trace Plot of Coefficient Values vs. user-indicated abscissa
    % (L1, L2, Lambda, or Custom)
    %
    [ax1,ax2,theTraces] = basicTracePlot(ax1,B,xvals,xlabel,xdir,xscale,plotData,predictorNames);
    
%     for i=1:length(theTraces)
%         set(theTraces(i),'DisplayName',predictorNames{i});
%         set(theTraces(i),'Tag',predictorNames{i});
%     end
    
    uistack(ax1,'top');
    
    if isempty(plotData) || ~isstruct(plotData) || plotData.Alpha == 1
        theTitle = getString(message('stats:lassoPlot:TracePlot_FigureName_Lasso'));
    else
        theTitle = getString(message('stats:lassoPlot:TracePlot_FigureName_ElasticNet', ...
            num2str(plotData.Alpha)));
    end
    
%     title(ax2,'');
%     title(ax1,'');

    drawnow
%     set(get(ax1,'Title'),'Position',get(get(ax2,'Title'),'Position'));
%     set(get(ax2,'Title'),'Visible','off');
%     set(get(ax1,'Title'),'String',theTitle);
       
    if ~isempty(plotData) && isstruct(plotData) ...
        && all(isfield(plotData,{lambdaMinName, indexMinName, 'Index1SE'}))
        
        % Add vertical lines at the locations of LambdaMinMSE and Lambda1SE
        %
        switch(plotType)
            case 'L1'
                lambdaMinVal = sum(abs(B(:,plotData.(indexMinName))));
                lambda1SEVal = sum(abs(B(:,plotData.Index1SE)));
            case 'L2'
                lambdaMinVal = sqrt(sum(B(:,plotData.(indexMinName)).^2));
                lambda1SEVal = sqrt(sum(B(:,plotData.Index1SE).^2));
            case 'Lambda'
                lambdaMinVal = plotData.Lambda(plotData.(indexMinName));
                lambda1SEVal = plotData.Lambda(plotData.Index1SE);
        end
        hold(ax1,'on')
        % Nikita
        bopt = abs(B(:,plotData.IndexMinMSE));
        tmp = sort(bopt,'descend');
        indexx = find((bopt>tmp(7)));%.*( [1 ;tmp_diff]>0.001));
        b_marker = B(indexx,plotData.IndexMinMSE);
%         namee = predictorNames(indexx);
%         % 2nd filtering
%         index2 = [];
%         [aa,bb] = sort(b_marker,'descend');
%         for i = 1:(length(b_marker)-1)
%             if(b_marker(bb(i)) - b_marker(bb(i+1)) > 0.15)
%                 index2(end+1) = i;
%             end
%         end
%         %index2 = find(abs([1 ; diff(sort(b_marker,'descend'))])>0.15);
%         b_marker2 = b_marker(index2);
%         
        text(repmat(lambdaMinVal,size(b_marker)),b_marker,predictorNames(indexx),'FontSize',8,'Parent', ax1);
        
        
        l1 = plot(ax1, lambdaMinVal*[1 1], get(ax1,'YLim'), 'LineStyle',':', ...
            'Color',[0 .8 0]);
        l2 = plot(ax1, lambda1SEVal*[1 1], get(ax1,'YLim'), 'LineStyle',':', ...
            'Color',[0 0 1]);
        
        %set(ax1, 'ytick', sort(b_marker));  
        %set (gca (), 'yticklabel', num2cell(sort(b_marker)));
        %grid on;
        %set(ax1,'Yscale',sort(b_marker))
        hold(ax1,'off')
        %
        
        % Tag these lines so that the data cursor will recognize them as
        % different from the coefficient traces. Also, assign names
        % for the legend.
        %
        set(l1,'Tag',lambdaMinName,'DisplayName',lambdaMinName);
        set(l2,'Tag','Lambda1SE','DisplayName','Lambda1SE');
        
        % Put these lines last in the object list, so that the data cursor
        % won't select them if the cursor is over a coefficient trace.
        %
        set(ax1,'Children', circshift(get(ax1,'Children'),-2));
    end

    set(dch,'Enable','off');
    if nargin-length(varargin) == 1
        set(dch,'UpdateFcn', ...
            {@traceCursor, B, [], plotType, predictorNames, [], []})
    else
        set(dch,'UpdateFcn', ...
            {@traceCursor, B, plotData, plotType, predictorNames, lambdaMinName, indexMinName})
    end
    
    set(ax2,'Visible','on')
    set(figureHandle,'CurrentAxes',ax1);
    
end

% Leave a little horizontal space around the data.
%
xlims = get(ax1,'XLim');
if strcmp(xscale,'linear')
    whitespace = 0.05 * range(xvals);
    xlims(1) = min([xlims(1), min(xvals)-whitespace]);
    xlims(2) = max([xlims(2), max(xvals)+whitespace]);
    set(ax1,'XLim',xlims);
else
    xvalsPos = xvals(xvals>0);
    whitespace = 0.05 * range(log(xvalsPos));
    xlims(1) = exp(log(min(xvalsPos)) - whitespace);
    xlims(2) = exp(log(max(xvalsPos)) + whitespace);
    set(ax1,'XLim',xlims);
end

if nargout > 0
    axh  = ax1;
    figh = figureHandle;
end

end %-lassoPlot

% -------------
% SUBFUNCTIONS
% -------------

% ----------- basicTracePlot() ----------

function [ax1, ax2, theTraces] = basicTracePlot(ax1,B,xvals,xlabel,xdir,xscale,plotData,predictorNames)

axisPosition = get(ax1,'Position');
left = axisPosition(1);
bottom = axisPosition(2);
width  = axisPosition(3);
height = axisPosition(4);

% Leave some margin around the plot for labels, etc.
%
left   = left + 0.05*width;
bottom = bottom + 0.10*height;
width  = width * 0.90;
height = height * 0.75;
set(ax1,'Position',[left bottom width height]);
set(ax1,'XAxisLocation','bottom');

% The cast to double averts plot problem with matrix of class single.
% Nikita modified
%theTraces = plot(ax1,xvals,double(B));
%theTraces = plot(ax1,xvals,double(B),'Color',[0.9 0.9 0.9],'LineWidth',0.25,'LineStyle',':');
bopt = abs(B(:,plotData.IndexMinMSE));
tmp = sort(bopt,'descend');
indexx = find((bopt>tmp(7)));%.*( [1 ;tmp_diff]>0.001));

B_in = B(indexx,:); B_out = B; B_out(indexx,:)=[];
hold on;
plot(ax1,xvals,double(B_out),'Color',[0.9 0.9 0.9]);
theTraces = plot(ax1,xvals,double(B_in),'LineWidth',1);
legend(theTraces,predictorNames(indexx),'FontSize',8);
%text(repmat(max(xvals),size(B(indexx,end))),B(indexx,end),predictorNames(indexx),'FontSize',6);
%
%set(ax1,'FontSize',13);
set(ax1,'Box','off');
set(ax1,'XDir',xdir);
set(ax1,'XScale',xscale);
set(get(ax1,'XLabel'),'String',xlabel);

% The second axes is used to depict DF values (#nonzero coefficients)
% along the top of the plot.
%
ax2 = axes('Position',get(ax1,'Position'), ...
    'Color','none', ...
    'XAxisLocation','top', ...
    'XDir', get(ax1,'XDir'), ...
    'XLim', get(ax1,'XLim'), ...
    'XScale', get(ax1,'XScale'), ...
    'YAxisLocation','right', ...
    'YTick',[], ...
    'YLim',get(ax1,'YLim'), ...
    'Box','off', ...
    'Visible','on');

% The DF ticks (ax2) and the coefficient traces (ax1) need to
% stay commensurate wrt x-limits and log/lin so that DF values
% line up correctly.
%
linkaxes([ax2, ax1],'xy');
ll = linkprop([ax2, ax1],'XScale');
addprop(ll,'XDir');
setappdata(ax2,'link_axes',ll);
setappdata(ax1,'link_axes',ll);

% DF tick values get calculated in updateDFforXLim() whenever XLim changes
% (including pan/zoom) or whenever XScale is reset (linear vs. log).
%
xlimListener = addlistener(ax2,{'XLim'},'PostSet', ...
    @(src,evt) updateDFforXLim(src,ax2,B,xvals,[]));
xscaleListener = addlistener(ax2,{'XScale'},'PostSet', ...
    @(src,evt) updateDFforXLim(src,ax2,B,xvals,xlimListener));

% This will remove the 'df' tick labels if a subsequent plot command
% into ax1 overrides the trace plot (specifically, causes all the
% coefficient traces to be deleted).
clearDfAxes = @(s,e) monitorTraceDeletes(ax2,theTraces);
set(theTraces,'DeleteFcn',@(s,e) clearDfAxes(ax2));

set(ax2,'Parent',get(ax1,'Parent'));
set(ax2,'XMinorTick','off');
set(get(ax2,'XLabel'),'String','df');

%Nikita
%text(repmat(0.0001/2,size(B(indexx,end))),B(indexx,end),predictorNames(indexx),'FontSize',6);
%
end %-basicTracePlot()


% ----------- cvCursor() ----------

function output_txt = cvCursor(~,theEvent,S,criterionName,lambdaMinName,indexMinName)
%
pos = get(theEvent,'Position');
tgt = get(theEvent,'Target');
theTag = get(tgt,'Tag');

if strcmp(theTag,lambdaMinName)
    output_txt{1} = sprintf('%s: %s', lambdaMinName, num2str(S.(lambdaMinName)));
    xix = S.(indexMinName);
elseif strcmp(theTag,'Lambda1SE')
    output_txt{1} = sprintf('Lambda1SE: %s', num2str(S.Lambda1SE));
    xix = S.Index1SE;
else
    xix = find(get(tgt,'XData')==pos(1),1);
    output_txt{1} = sprintf('Lambda: %s', num2str(S.Lambda(xix)));
end
output_txt{2} = sprintf('%s: %s', criterionName, num2str(S.(criterionName)(xix)));
output_txt{3} = sprintf('SE: %s', num2str(S.SE(xix)));
output_txt{4} = getString(message('stats:lassoPlot:DataTip_Index',num2str(xix)));
%
end %-cvCursor()


% ----------- traceCursor() ----------

function output_txt = traceCursor(~,theEvent,B,S,plotType,predictorNames,lambdaMinName,indexMinName)
% 
pos = get(theEvent,'Position');
tgt = get(theEvent,'Target');
theTag = get(tgt,'Tag');
if strcmp(theTag,lambdaMinName)
    output_txt{1} = sprintf('%s: %s', lambdaMinName, num2str(S.(lambdaMinName)));
    xix = S.(indexMinName);
elseif strcmp(theTag,'Lambda1SE')
    output_txt{1} = sprintf('Lambda1SE: %s', num2str(S.Lambda1SE));
    xix = S.Index1SE;
else
    
    switch plotType
        case 'L1'
            xix = find(sum(abs(B),1) == pos(1),1);
        case 'L2'
            xix = find(sqrt(sum(B.^2,1)) == pos(1),1);
        case 'Lambda'
            xix = find(S.Lambda == pos(1),1);
        case 'MSE'
            xix = find(S.MSE == pos(1),1);
        case 'Custom'
            xix = find(S==pos(1),1,'first');
    end
    
    yix = find(B(:,xix) == pos(2),1);
    if isempty(predictorNames)
        if isempty(S) || ~isstruct(S) || isempty(S.PredictorNames)
            predname = sprintf('B%s', num2str(yix));
        else
            predname = S.PredictorNames{yix};
        end
    else
        predname = predictorNames{yix};
    end
    output_txt{1} = sprintf('%s: %s', predname, num2str(pos(2)));
end
output_txt{2} = sprintf('%s: %s', plotType, num2str(pos(1)));
output_txt{3} = getString(message('stats:lassoPlot:DataTip_Index',num2str(xix)));
%
end %-traceCursor()

% ----------- processCommandLine() ----------

function clArgs = processCommandLine(B, plotData, varargin)
%
clArgs.criterionName = [];
clArgs.lambdaMinName = [];
clArgs.indexMinName = [];

if ~ischar(plotData) && ~isstruct(plotData)

    % ARG #2 is USER-SUPPLIED VALUES.
    % If we are here, plotData gives values for the x-axis.
    % Check that plotData is (1) numeric, (2) commensurate with
    % the columns of B, and (3) monotonic.
    %
    errCondition = false;
    if ~isnumeric(plotData) || length(plotData(:)) ~= size(B,2)
        errCondition = true;
    end
    plotData = plotData(:)';
    if ~errCondition
        if ~isequal(plotData, sort(plotData)) && ...
            ~isequal(plotData, sort(plotData,1,'descend'))
            errCondition = true;
        end
    end
    if errCondition
        error(message('stats:lassoPlot:BadCustomX'))
    end;
    
    plotType   = 'Custom';
    customPlot = true;
    xvals      = plotData;
    xlabel     = '';
    xdir       = 'normal';
    
else
    
    customPlot = false;
    
    if ischar(plotData)
        % ARG #2 is a STRING
        % If the second argument is a character string, then it should
        % initiate optional name-value pairs. By implication,
        % plotData is empty. Processing of the name-value pairs occurs
        % in two locations further below.
        varargin = [{plotData} varargin];
        plotData = [];
    else
        % ARG #2 should be a STRUCT
        % Make sure it IS a struct.
        if ~isstruct(plotData)
            error(message('stats:lassoPlot:PLOTDATAnotStruct',plotType))
        end
    
        % The struct varies slightly depending on whether it was created
        % by lasso(), lassoGlm(), or (in the future), other functions.
        % lasso    produces 'MSE', and optionally 'LambdaMinMSE' and 'IndexMinMSE',
        %          if cross-validation was performed. 
        % lassoGlm produces 'Deviance', and optionally 'LambdaMinDeviance' and 
        %          'IndexMinDeviance'. if cross-validation was performed. 
        % Identify variant field names for convenience of the plotting code.
        % Note that either the field 'MSE' or the field 'Deviance' should exist.
        % However, the fields 'LambdaMin*' and 'IndexMin*' will not exist if
        % cross-validation was not performed.  Here we just give the names to
        % use to look for them.

        if isfield(plotData,'MSE')
            criterionName = 'MSE';
            lambdaMinName = 'LambdaMinMSE';
            indexMinName  = 'IndexMinMSE';
        elseif isfield(plotData,'Deviance')
            criterionName = 'Deviance';
            lambdaMinName = 'LambdaMinDeviance';
            indexMinName  = 'IndexMinDeviance';
        else
            % This struct does not conform to any lasso paradigm output.
            error(message('stats:lassoPlot:PLOTDATAnotStruct','Any'))
        end

        clArgs.criterionName  = criterionName;
        clArgs.lambdaMinName  = lambdaMinName;
        clArgs.indexMinName   = indexMinName;
    end
    
end


pnames =   { 'plottype' };
dflts  =   {  []      };
[clPlotType, ~, varargin] = ...
    internal.stats.parseArgs(pnames, dflts, varargin{:});

if customPlot
    if ~isempty(clPlotType)
        error(message('stats:lassoPlot:CustomOnly'));
    end
else
    
    % Process the 'PlotType' parameter.
    %
    if isempty(clPlotType)
        clPlotType = 'L1';
    end
    
    % There are 4 legal 'PlotType' values.
    % Two of them ('Lambda', and 'CV') are valid only if the second input 
    % argument is a struct, because they use values contained in fields 
    % of that struct. 
    %
    plotType = internal.stats.getParamVal(clPlotType, ...
        {'L1', 'L2', 'Lambda', 'CV'}, 'PlotType');

    % PlotTypes 'L1' and 'L2' use only the matrix of coefficients, B.

    if isequal(plotType,'L1')
        xvals = nansum(abs(B),1);
        xvals(all(isnan(B),1)) = NaN;
        xlabel = 'L1';
        xdir = 'normal';
        
    elseif isequal(plotType,'L2')
        xvals = sqrt(nansum((B.^2),1));
        xvals(all(isnan(B),1)) = NaN;
        xlabel = 'L2';
        xdir = 'normal';
        
    else

        P = size(B,2);

        % PlotTypes 'Lambda' and 'CV' require PLOTDATA to be a struct
        % with certain required fields (the required fields differ
        % between the plot types).

        if ~isstruct(plotData)
            error(message('stats:lassoPlot:PLOTDATAnotStruct',plotType))
        end
        
        % Both 'Lambda' and 'CV' plots display Lambda on the x-axis,
        % in reverse numerical order.  
        checkConformantField('Lambda',plotType,plotData,P);
        xvals  = plotData.Lambda;
        xlabel = 'Lambda';
        xdir   = 'reverse';

        if isequal(plotType,'CV')
            checkConformantField('SE',plotType,plotData,P);

            % The struct varies slightly depending on whether it was created
            % by lasso(), lassoGlm(), or (in the future), other functions.
            % lasso    produces 'MSE','LambdaMinMSE' and 'IndexMinMSE'. 
            % lassoGlm produces 'Deviance', 'LambdaMinDeviance' and 'IndexMinDeviance'. 

            if isfield(plotData,'MSE')
                criterionName = 'MSE';
                lambdaMinName = 'LambdaMinMSE';
                indexMinName  = 'IndexMinMSE';
            elseif isfield(plotData,'Deviance')
                criterionName = 'Deviance';
                lambdaMinName = 'LambdaMinDeviance';
                indexMinName  = 'IndexMinDeviance';
            end

            cvRequiredScalarFields =  ... 
                {lambdaMinName, indexMinName, 'Lambda1SE', 'Index1SE'};
            missingFields = cvRequiredScalarFields(~isfield(plotData, cvRequiredScalarFields));

            if ~isempty(missingFields)
                % Attach a trailing command to all but the last missing field.
                for i=1:(length(missingFields)-1)
                    missingFields{i} = [missingFields{i} ','];
                end
                % Concatenate all the missing field names into a single string.
                missingFields = [missingFields{:}];
                eid = 'stats:lassoPlot:MissingField';
                error(message(eid,plotType,missingFields));
            end

        end
    end
end

pnames =   { 'predictornames' 'xscale' 'parent'};
dflts  =   {  []               []        []       []     };
[predictorNames,  xscale,  ax1, ~] = ...
    internal.stats.parseArgs(pnames,dflts,varargin{:});

% === 'PredictorNames' parameter ===
% Defer to the command line argument 'PredictorNames' if supplied
% but otherwise use the PredictorNames field in the plotData struct.
% If neither is supplied, leave as empty.
if isempty(predictorNames) && ~isempty(plotData) && ...
        isstruct(plotData) && isfield(plotData,'PredictorNames')
    predictorNames = plotData.PredictorNames;
end

% It has to be empty or a cell array of strings.
if ~isempty(predictorNames) && ~iscellstr(predictorNames)
        error(message('stats:lassoPlot:BadPredictorNames'));
end

% === 'XScale' parameter ===
%
% If supplied, it must be 'linear' or 'log'.
% If empty, do nothing here because the default differs by 'PlotType'.
% The 'CV' default is 'log', all others default to 'linear'.
%
if isempty(xscale)
    if isequal(plotType,'CV')
        xscale='log';
    else
        xscale='linear';
    end
else
    xscale = internal.stats.getParamVal(xscale,{'linear','log'},'XScale');
end

clArgs.plotData = plotData;
clArgs.plotType = plotType;
clArgs.xvals    = xvals;
clArgs.xscale   = xscale;
clArgs.xdir     = xdir;
clArgs.xlabel   = xlabel;
clArgs.ax1      = ax1;
clArgs.predictorNames = predictorNames;

%
end %-processCommandLine()


% ----------- checkConformantField() ----------

function checkConformantField(theField,plotType,plotData,P)
%
if ~isfield(plotData,theField)
    eid = 'stats:lassoPlot:MissingField';
    error(message(eid,plotType,theField));
end
xvals = plotData.(theField);
if ~isreal(xvals) || ~isequal(length(xvals),P) ...
        || ~all(isfinite(xvals)) || any(xvals<0)
    error(message('stats:lassoPlot:NonconformantData',theField));
end
%
end %-checkConformantField()


% ----------- updateDFforXLim() ----------

function updateDFforXLim(src,dfAx,B,xvals,xlimListener)
%
% Restrict DF labeling to values within the current XLim range.
%

xlim = get(dfAx,'XLim');
xscale = get(dfAx,'XScale');

inView = find(xvals >= xlim(1) & xvals <= xlim(2));

% If the user resets x limits so that they contain no data,
% generate a blank plot. Continuing into the code below 
% would not be meaningful and could generate uncontrolled failures.
if isempty(inView)
    xlabel(dfAx,'');
    return; 
end

B = B(:,inView);
xvals = xvals(inView);

df = sum(B~=0,1);
udf = unique(df);
for i=1:length(udf), tickIx(i) = find(df==udf(i),1,'last'); end

% Drop tick for df=0
%
if udf(1) == 0
    udf = udf(2:end);
    tickIx = tickIx(2:end);
elseif udf(end) == 0
    udf = udf(1:end-1);
    tickIx = tickIx(1:end-1);
end

tickVal = xvals(tickIx);
if isequal(xscale,'log')
    % If a log scale we will try to space ticks based on log(value).
    tickVal = log(tickVal);
end

maxTick = 11;
if length(udf) > maxTick
    % Simple pruning algorithm for tick labels in case of many df-values.
    % (Currently: assumes linear scale.)
    % Try to maximize the minimum gap between any two ticks.
    while length(udf) > maxTick
        tickDiff = abs(diff(tickVal));
        tickGap = tickDiff(1:end-1) + tickDiff(2:end);
        tickGap = [Inf tickGap' Inf];
        [~,ix] = min(tickGap);
        tickVal(ix) = [];
        tickIx(ix) = [];
        udf(ix) = [];
    end
end

if isequal(xscale,'log')
    tickVal = exp(tickVal);
end

set(dfAx,'XTick',sort(tickVal));

if isequal(get(dfAx,'XDir'),'reverse')
    set(dfAx,'XTickLabel',sort(udf,2,'descend'));
else
    set(dfAx,'XTickLabel',udf);
end

if isequal(src.Name,'XScale')

    % The event that we are responding to is a setting of x-axis
    % scale. In calculating tick locations above, we used the extant 
    % x-axis limits. These may be limits set expressly by the user, and
    % we want to restrict tick labeling to the data contained within
    % these limits. However, when switching between 'log' and 'linear', 
    % the plot data can get squashed to the left or the right limit. 
    % Therefore, after calculating the ticks, we adjust the x-axis limits
    % to leave some horizontal white space around the data range.
    % The adjustment is for visual balance only, and we don't want the
    % ticks to be recalculated again. Therefore, we inhibit 
    % the XLim listener during this adjustment.
    %
    
    priorEnabledSetting = get(xlimListener,'Enabled');
    xlimListener.Enabled = 'off';
    if isequal(xscale,'linear')
        whitespace = 0.05 * range(xvals);
        xlim(1) = min(xvals)-whitespace;
        xlim(2) = max(xvals)+whitespace;
        set(dfAx,'XLim',xlim);
    else
        xvalsPos = xvals(xvals>0);
        whitespace = 0.05 * range(log(xvalsPos));
        xlim(1) = exp(log(min(xvalsPos)) - whitespace);
        xlim(2) = exp(log(max(xvalsPos)) + whitespace);
        set(dfAx,'XLim',xlim);
    end
    xlimListener.Enabled = priorEnabledSetting;
end
end %-updateDFforXLim()

function monitorTraceDeletes(ax2,theTraces)
alive = ishandle(theTraces);
if sum(alive)==1 && isequal(get(theTraces(alive),'BeingDeleted'),'on')
    delete(ax2);
end
end %-monitorTraceDeletes
