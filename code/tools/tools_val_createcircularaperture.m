function [patch] = tools_val_createcircularaperture(siz,aperture)

    sigmoidfun = @(x,lims)lims(1)+diff(lims)./(1+exp(-x));

    siz = floor(siz/2)*2;
    [x,y] = meshgrid((1:siz)-(siz+1)/2);
    
    r     = x.^2+y.^2;
    patch = sigmoidfun((sqrt(r)-.5*siz)/aperture,[1,-1]);
    patch(patch<0) = 0;
    patch = patch.*(1/max(patch(:)));

end