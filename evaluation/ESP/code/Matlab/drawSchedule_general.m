function [] = drawSchedule_general( Schedule_input,varargin )
%% Program to draw schedule

    opt     = propertylist2struct(varargin{:});
    opt     = set_defaults(opt, 'combb',0,'xlim',[]); %'xlim'
    filename  = Create_BM();
    Y         = Schedule_input.rate;
    Schedule  = Schedule_input.schedule;
    k         = length(Y)+1;
    m         = length(filename);
%     if(k~=1)
%         m     = (1+sqrt(1+8*length(Y{1})))/2;
%     else
%         m     = length(Schedule);
%     end
    ColorSet  = varycolor(m);
    speed     = [];
    TOL       = 1;
    TOL2      = 1;
    right     = 0;
    timetotal = 0;
    
    %figure;
    hold on;
    for i = 1:m
        plot(1,1,'Color',ColorSet(i,:));
        filename{i}=[filename{i},'-',num2str(i)];
    end
    legend(filename);
    
    for l = 1:k
        if(opt.combb==0)
            Structure = nchoosek(1:m,l);
        else
            Structure = combbb(1:m,l);
        end
        if(l==1)
            yhat = ones(m,1);
        else
            yhat = roundn(Y{l-1},-2);
        end
        n = length(yhat);
        if(size(Structure,1)~=n)
            error('Lengths are not right');
        end
        
        runtime_s    = Schedule(1:n);
        Schedule(1:n) = [];
        timetotal    = timetotal + sum(runtime_s);
        for i = 1:(length(yhat))
            left   = right;  right = left + runtime_s(i);
            bottom = 1.0;                       top   = bottom + 1;
            x  = [left left right right];
            for j = 1:l
                y = [bottom top top bottom];
                bottom = top;                top = top+1;
                color = ColorSet(Structure(i,j),:);
                if((right-left)>TOL2)
                    fill(x, y, color,'edgecolor',color);
                    text((left+right)/2, 0.5+j,         num2str(Structure(i,j)));
                end
                if((right-left)>TOL) % not visible otherwise
                    speed(end+1) = sum(yhat(i,:));
                    %text((left+right)/2, 0.5,          num2str(speed(end)));
                    
                    text((left+right)/2, 0.15+j,        num2str(yhat(i,j)));
                    
                end
            end
        end
    end
    set(gca,'YTickLabel',{});
    
    %title([Schedule_input.name,' Average speed = ',sprintf('%5.2f ', mean(speed)),', Total time = ',num2str(timetotal)]);
    title([Schedule_input.name,' algorithm', ', Total time = ',sprintf('%.0f ', timetotal)],'fontsize',12);
    xlabel('Scheduling Time (in seconds)');
    hold off;
    if(~isempty(opt.xlim))
        xlim([0 opt.xlim]);
    end
    %xlim([0 1250]);
    %set(gca,'XTick',0:150:(1250));
end