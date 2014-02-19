function [patch] = tools_val_createdsmoothednoise(siz,kerneldev,dev)
    %  [patch] = CreateSmoothedNoise(size,kerneldev,[dev])

    if nargin < 3, dev = 1; end
    if nargin < 2, error('Not enough input arguments.'); end

    siz = floor(siz/2)*2;

    kernelsiz = 2*ceil(kerneldev*3)+1;
    kernellim = 0.5*kernelsiz/kerneldev;
    kernel = tools_val_normalpdf(linspace(-kernellim,+kernellim,kernelsiz),0,1,false);
    kernel = kernel'*kernel;

    patch = conv2(randn(siz+2*kernelsiz),kernel,'same');
    patch = patch(kernelsiz+1:end-kernelsiz,kernelsiz+1:end-kernelsiz);
    patch = patch/sqrt(sum(kernel(:).^2))*dev;
end