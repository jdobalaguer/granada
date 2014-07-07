
function data = ext_distexp(data)
    %% numbers
    nb_total   = length(data.exp_subject);
    nb_subject = length(unique(data.exp_subject));
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(data.exp_trial));
    
    %% distance to lottery
    data.vb_distexp = (6 - data.exp_session);
end
