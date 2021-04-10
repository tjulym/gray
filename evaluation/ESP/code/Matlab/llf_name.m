function [ name ] = llf_name( index )
%llf
name=[];
%fprintf('This funciton gives right output only when the columns from the original data haven not been removed.');
if(index~=floor(index) || index<=0)
    name = '-';
    return;
    %error('Please enter a natural number.');
end

index = mod(index,410);

if(index <= 352)
    LLFid = mod(index,11);
    core  = ceil(index/11);
    switch LLFid
        case num2cell(1:10)
            name = llfid(LLFid);
        case 0
            name = 'TEMP';
    end
    name = [name,'-',num2str(core)];
elseif(index <= 390)
    index2 = index - 352;
    LLFid = mod(index2,13);
    core  = ceil(index2/13);
    switch LLFid
        case num2cell(1:10)
            name = llfid(LLFid);
        case 11
            name = 'READ';
        case 12
            name = 'WRITE';
        case 0
            name = 'TEMP';
    end
    switch core
        case 1
            name = [name,'-SKT-0'];
        case 2
            name = [name,'-SKT-1'];
        case 3
            name = [name,'-TOTAL'];
    end
elseif(index<=409)
    index2 = index - 390;
     switch index2
        case 1
            name = 'INS-RTD';
        case 2
            name = 'ACTV-CYC';
        case num2cell(3:6)
            name = ['CORE-RES',num2str(index2)];
        case num2cell(7:9)
            name = ['CORE-PKG',num2str(index2)];
        case 10
            name = 'CORE-IPC';
        case 11
            name = 'UTIL-CORE';
        case 12
            name = 'NOM-IPC';
        case 13
            name = 'UTIL-CORE';
        case 14
            name = 'ENRG-0-PKG';
        case 15
            name = 'ENRG-1-PKG';
        case 16
            name = 'ENRG-PKG';
        case 17
            name = 'ENRG-0-DIMM';
        case 18
            name = 'ENRG-1-DIMM';
        case 19
            name = 'ENRG-DIMM';
    end
else
    error('Index is not correct');
end

end

function [name] = llfid(LLFid)
    switch LLFid
        case 1
            name = 'EXEC';
        case 2
            name = 'IPC';
        case 3
            name = 'FREQ';
        case 4
            name = 'AFREQ';
        case 5
            name = 'L3MISS';
        case 6
            name = 'L2MISS';
        case 7
            name = 'L3HIT';
        case 8
            name = 'L2HIT';
        case 9
            name = 'L3CLK';
        case 10
            name = 'L2CLK';
    end
end