function Z = InverseBoxCox(Y,lambda)
    Z = exp(log(Y*lambda+1)/lambda);
    Z(imag(Z)~=0)=0;
end