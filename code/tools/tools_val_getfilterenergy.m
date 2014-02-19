function [fener,fphas] = tools_val_getfilterenergy(patch,envelopedev,angle,frequency,aperture)

if nargin < 4
    error('Not enough input arguments.');
end

phase = 0.1:0.2:0.9;
fresp = nan(size(phase));
for i = 1:length(phase)
    fresp(i) = tools_val_getfilterresponse(patch,envelopedev,angle,frequency,phase(i),aperture);
end

[fener0,i0] = max(fresp);
phase0 = phase(i0);

f = ezfit(phase,fresp,'a*cos(2*pi*(x-b))',[fener0,phase0]);
fener = abs(f.m(1));
fphas = mod(f.m(2),1);

end