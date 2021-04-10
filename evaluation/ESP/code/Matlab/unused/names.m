function [ Y_name ] = names( index,varargin)
% names of apps not done
opt = propertylist2struct(varargin{:});
opt = set_defaults(opt,  'combb',0);
namee=Create_BM();

if(opt.combb==0)
	
	Y_name = namee(nchoosek(1:length(namee),index));
else
	
    Y_name = namee(combbb(1:length(namee),index));
end
end

