
function data = ext_valcum(data)
    %% numbers
    nb_total   = length(data.exp_subject);
    nb_subject = length(unique(data.exp_subject));
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(data.exp_trial));
    
    %% accumulated value
    valcum = 0;
    data.resp_valcum = nan(1,nb_total);
    for i = 1:nb_total
        if data.exp_first(i), valcum = 0; end
        data.resp_valcum(i) = valcum;
        valcum = data.resp_value(i) + valcum;
    end
end
