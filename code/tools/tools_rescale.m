
function z = tools_rescale(x)
    maxx = max(x(:));
    minx = min(x(:));
    z = (x - minx) ./ (maxx - minx);
end
    