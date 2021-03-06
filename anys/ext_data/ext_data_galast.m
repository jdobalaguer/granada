
function data = ext_galast(data)
    %% numbers
    nb_total   = length(data.exp_subject);
    nb_subject = length(unique(data.exp_subject));
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(data.exp_trial));
    
    %% last actions
    data.resp_galast1 = [zeros(1,1), data.resp_gamble(1:end-1)];
    data.resp_galast2 = [zeros(1,2), data.resp_gamble(1:end-2)];
    data.resp_galast3 = [zeros(1,3), data.resp_gamble(1:end-3)];
    data.resp_galast4 = [zeros(1,4), data.resp_gamble(1:end-4)];
    data.resp_galast5 = [zeros(1,5), data.resp_gamble(1:end-5)];
end
