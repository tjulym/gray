function [ BM ] = Create_BM()
%simply loads all benchmark names
    filename = [tmp_path(),'BM.mat'];
    if(exist(filename, 'file'))
        tmp = load(filename);
        BM = tmp.BM;
        return;
    end
    fileID = fopen([tmp_path(),'All_app.tsv']); 
    farray = textscan(fileID, '%s','delimiter','\t');  
    fclose(fileID);
    farray = farray{1};
    BM = {};
    for i = 1: length(farray)
        BM{end+1} = farray{i}; 
    end
end

