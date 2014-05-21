
function [mu,va] = samprob(x,n,p,u)
    %% mean and variance
    bi = nan(1,u);
    qi = nan(1,u);
    vi = nan(1,u);
    for i = 0:u
        bi(i+1) = factorial(u) ./ factorial(i) ./ factorial(u-i);
        qi(i+1) = bi(i+1) .* power(p,i) .* power(1-p,u-i);
        vi(i+1) = (i./u*x + (u-i)./u*n);
    end
    
    %% fix qi/vi
    f_qi = unique(qi);
    f_vi = nan(size(f_qi));
    for i = 1:numel(f_qi)
        f_vi(i) = sum(vi(qi==f_qi(i)));
    end
    qi = f_qi;
    vi = f_vi;
    
    %% return
    mu = sum(qi .* vi);
    va = sum(qi .* power(vi-mu,2));
    
end
