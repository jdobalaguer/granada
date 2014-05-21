function [tval pval]= ttest(x,m,alpha,tail)
%function [tval pval]= ttest(x,m,alpha,tail)


if nargin < 1, 
    error('Requires at least one input argument.'); 
end

if nargin < 3, 
    m=0;
end

samplesize  = size(x,1);
xmean = mean(x);
ser = std(x) ./ sqrt(samplesize);
tval = (xmean - m) ./ ser;

if (nargout > 1)
if isnan(tval)
   pval = NaN;
else
   pval = tcdf(tval,samplesize - 1);
end
end

return;
