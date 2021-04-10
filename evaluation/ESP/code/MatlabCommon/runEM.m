function [ return_em, iterator ] = runEM(Old, W, y_em, i, epsilon, iteration_limit, y)
    % Multiple entries missing across the matrix
    %% Initilization
    [n,m] = size(y_em);    
    error = Inf;
    likelihood = -Inf;
    
    mu = Old.mu;size(mu)
    C = Old.C;size(C)
    sigma = Old.sigma;size(sigma) 
    iterator = 1; 
    if(isfield(Old,'pi'))
        pi = Old.pi;% parameter to control how much offline data is helpful
    else
        pi = 1;
    end
    pi
	tau = 1;
	numSamples = sum(sum(W));
    wl = zeros(n,m);
    Cl = zeros(n,n,m);
    
    for l = 1:m            
        t = ones(n,1); t(isnan(y_em(:,l))) =0;  
       
        I{l} = diag(W(:,l).*t);  
        y_em(isnan(y_em(:,l)),l) = 0;
    end
    
    while(likelihood < epsilon && iterator < iteration_limit)
    %while(likelihood < epsilon && iterator <= iteration_limit)
        %% E-step for each application  
        Cinv = inv(C);
        %temp = inv(eye(n)/sigma + Cinv);  
        
        for l = 1:m            
            %if(l~=i)                                                     
            %    Cl(:,:,l) = temp;
            %else              
             
            Cl(:,:,l) = ( I{l}/sigma + Cinv)^(-1); 
            %end  
            wl(:,l)  = Cl(:,:,l) *((y_em(:,l))/sigma + Cinv*mu);                    
        end
        
        %% M-step
        ClSum = (eye(n));
        wlSum = (zeros(n,1));
        wlSumCov = (eye(n));
        normSum = 0;
        for l = 1:m            
            ClSum = ClSum +  Cl(:,:,l);
            wlSum = wlSum + wl(:,l);
            wlSumCov = wlSumCov + (wl(:,l)-mu)*(wl(:,l)-mu)';    
%             if(l~=i)                        
%             	normSum = normSum + norm(y_em(:,l) - wl(:,l))^2 + trace( Cl(:,:,l)); 
%             else
            	normSum = normSum + norm(I{l}*(y_em(:,l) - wl(:,l)))^2 + trace(I{l}* Cl(:,:,l)); 
%             end
        end
        mu = ((1/(pi + m))*wlSum);
        C = ((1/(tau + m))*(pi*(mu*mu') + tau*eye(n)+ ClSum + wlSumCov));     
        
        sigma = normSum/((m-1)*n + numSamples);

        Old.mu = mu;        Old.C = C;        Old.sigma = sigma;
        iterator = iterator +1;   
        
        
        %%
        Cinv = inv(C);
%         likSum = 0;    
%         for l = 1:m            
%             if(l~=i)                        
%             	likSum = likSum + wl(:,l)'*(eye(n)/sigma + Cinv)*wl(:,l)...
%                          -2*(y_em(:,l)'/sigma + mu'*Cinv)*wl(:,l) + y_em(:,l)' *y_em(:,l)/sigma ; 
%             
%             else
%             	likSum = likSum +  wl(:,l)'*(I{l}/sigma + Cinv)*wl(:,l)...
%                          -2*(y_em(:,l)'/sigma + mu'*Cinv)*wl(:,l) + y_em(:,l)' *y_em(:,l)/sigma ; 
%             end
%         end                 
        accuracy = accuracy_rss(wl(:,i) , y(:,i));
       
        fprintf('it = %d, lik = %f, trueAcc = %f\n',iterator,likelihood,accuracy );
%         %fprintf('-------------------------\n');
    	
%        imagesc(Cinv);colorbar;colormap(gray);
%        pause;
    end
    %% Prediction for ith data 
    return_em.w = wl(:,i); 
    return_em.em_t = Old;
    return_em.Cl = Cl;
    return_em.wl = wl; 
end
