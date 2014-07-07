
function data = ext_vanext(data)
    %% numbers
    nb_total   = length(data.exp_subject);
    nb_subject = length(unique(data.exp_subject));
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(data.exp_trial));
    
    %% last value
    data.resp_vanext1 = [data.resp_value(2:end), zeros(1,1)];
    data.resp_vanext2 = [data.resp_value(3:end), zeros(1,2)];
    data.resp_vanext3 = [data.resp_value(4:end), zeros(1,3)];
    data.resp_vanext4 = [data.resp_value(5:end), zeros(1,4)];
    data.resp_vanext5 = [data.resp_value(6:end), zeros(1,5)];
end
