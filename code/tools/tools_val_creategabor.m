function [patch] = tools_val_creategabor(siz,envelopedev,angle,frequency,phase,contrast)
    %  [patch] = CreateGabor(siz,envelopedev,angle,frequency,phase,[contrast])

    if nargin < 6, contrast = 1; end
    if nargin < 5, error('Not enough input arguments.'); end

    siz = floor(siz/2)*2;
    [x,y] = meshgrid((1:siz)-(siz+1)/2);

    patch = 0.5*contrast*cos(2*pi*(frequency*(sin(pi/180*angle)*x+cos(pi/180*angle)*y)+phase));
    patch = patch.*tools_val_normalpdf(sqrt(x.^2+y.^2),0,envelopedev,false);

end