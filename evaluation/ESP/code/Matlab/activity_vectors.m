function [ MEM,IPC,L3R ] = activity_vectors()
xxraw     = load([tmp_path(),'X.raw']);
MEM       = sum(xxraw(:,443:444),2)'; 
IPC       = xxraw(:,434)';
L3HITRATE = xxraw(:,439)';            
L3MISS    = xxraw(:,437)';
L3R       = L3MISS./(1 - L3HITRATE);

end

