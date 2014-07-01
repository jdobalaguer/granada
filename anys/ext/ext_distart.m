
function data = ext_distart(data)
    %% distance from start
    data.vb_distart = 1 + data.vb_framelngth - data.vb_distance;
end
