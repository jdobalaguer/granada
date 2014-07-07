
function data = ext_start(data)
    %% numbers
    nb_total   = length(data.exp_subject);
    nb_subject = length(unique(data.exp_subject));
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(data.exp_trial));
    
    %% block
    data.exp_start = double(data.exp_trial   == 1);
    data.exp_end   = double(data.exp_trial   == nb_trial);
    
    %% frame
    data.exp_last  = double(data.vb_distance == 1);
    data.exp_first = double([1, data.exp_last(1:end-1)]);
    
end