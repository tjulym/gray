% schedule_verifier - Verifies that the schedule is correct
% LLF and the top and bottom are run together.
%
% Syntax
%  function [Schedule] = baseline_general2(LLF, Y_rnd, W, <opt>)
%
%  input:
%    Schedule_input - Structure of input structure
%    varargin: 
%        * W        - work that is supposed to be done
%        * verbose  - display argument 0 or 1
%  outputs:
%    W   - work done by individual apps
%    work
% See also: schedule_cover, main_general
function [ W,work ] = schedule_verifier( Schedule_input,varargin )
    opt     = propertylist2struct(varargin{:});
    opt     = set_defaults(opt, 'display',0,'combb',0,'W',[]);

    if(~isfield(Schedule_input,'schedule'))
        fprintf('Empty schedule ');
        W=[]; work = [];
        return;
    end
    Y         = Schedule_input.rate;
    Schedule  = Schedule_input.schedule;
    TOL  = 10^-3;
    m    = length(Schedule_input.work_done);
    W    = zeros(m,1);
    for i = 1:(length(Y)+1)
        if(opt.combb==0)
            Structure = nchoosek(1:m,i);
        else
            Structure = combbb(1:m,i);
        end
        if(i==1)
            y = ones(m,1);
        else
            y = Y{i-1};
        end
        sched = Schedule(1:size(y,1));
        Schedule(1:size(y,1)) = [];
        work{i} = y.*repmat(sched,1,size(y,2));
        for j = 1:m
            Struc_tmp = Structure;
            Struc_tmp(Structure==j) = 1;
            Struc_tmp(Structure~=j) = 0;
            
            W(j) = W(j) +  sum(sum(work{i}.*Struc_tmp));
        end
        
    end  
    if(~isempty(opt.W));
        work_original = opt.W;
        if(max(work_original-W)<TOL)
            fprintf('verified! Extra work = %f\n', sum(W-work_original));
        else
            fprintf('Work is not finished.\n');
            W
        end
    end
end

