
function data = ext_onset(data)
    %% parameters
    pars_tr = 2;
    
    %% onset (sec)
    data.vb_onset   = (data.vb_getsecs   - data.exp_trigger);
    data.resp_onset = (data.resp_getsecs - data.exp_trigger);
    
    %% scans
    data.vb_scans   = (data.vb_getsecs   - data.exp_trigger) ./ pars_tr;
    data.resp_scans = (data.resp_getsecs - data.exp_trigger) ./ pars_tr;
    
end
