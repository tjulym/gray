load data_funcs_process_onlyBE
data=data_funcs_process_onlyBE;
BE_num=zeros(1920,1);
count=0;
for i=1:length(BE_num)
    for j=1:length(data)
        if data(j,1)<i && data(j,2)>i 
            count=count+1
        end
    end
    BE_num(i)=count;
    count=0;
end
