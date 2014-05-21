
function alldata = ext_valcum(alldata)
    %% numbers
    nb_total   = length(alldata.exp_subject);
    nb_subject = length(unique(alldata.exp_subject));
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(alldata.exp_trial));
    
    %% accumulated reward
    valcum = 0;
    alldata.resp_valcum = nan(1,nb_total);
    for i = 1:nb_total
        if alldata.exp_first(i), valcum = 0; end
        alldata.resp_valcum(i) = valcum;
        valcum = alldata.resp_value(i) + valcum;
    end
end
