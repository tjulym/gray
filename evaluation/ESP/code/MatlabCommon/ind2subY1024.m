function [ i,j,k ] = ind2subY1024( id)
%converts for the following settings
NUMCLOCKCYCLE = 16;
NUMK = 2;

temp = NUMCLOCKCYCLE * NUMK;
i    = floor(( id - 1) / temp);
j    = floor(( id - i * temp - 1) / NUMK);
k    =   id - i * temp - j * NUMK - 1 ;
end

