
function data = ext_values(data)
    %% numbers
    nb_total   = length(data.exp_subject);
    nb_subject = length(unique(data.exp_subject));
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(data.exp_trial));
    
    %% unexpected value
    data.resp_uxv = data.resp_value - data.vb_exv;
end
