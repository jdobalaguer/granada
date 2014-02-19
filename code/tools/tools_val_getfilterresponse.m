function [fresp] = tools_val_getfilterresponse(patch,envelopedev,angle,frequency,phase,aperture)

if nargin < 5
    error('Not enough input arguments.');
end

siz = size(patch,1);
lumibg = patch(1,1);

templ = tools_val_creategabor(siz,envelopedev,angle,frequency,phase,1).*tools_val_createcircularaperture(siz,aperture);
fresp = sum((patch(:)-lumibg).*templ(:))/sum(templ(:).^2)/min(2*lumibg,2*(1-lumibg));

end