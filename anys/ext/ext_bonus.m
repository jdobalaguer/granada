
function data = ext_bonus(data)
    %% numbers
    nb_total   = length(data.exp_subject);
    nb_subject = length(unique(data.exp_subject));
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(data.exp_trial));
    
    %% bonus
    data.resp_bonus_mean = nan(1,nb_total);
    data.resp_bonus_std  = nan(1,nb_total);
    data.resp_bonus_min  = nan(1,nb_total);
    data.resp_bonus_max  = nan(1,nb_total);
    data.resp_bonus_last = nan(1,nb_total);
    for i = 1:nb_total
        data.resp_bonus_mean(i) = mean(bonus);
        data.resp_bonus_std( i) = mean(bonus);
        if data.exp_start(i)
            bonus = [];
        elseif data.exp_last(i)
            ii_sub     = (data.exp_subject == data.exp_subject(i));
            ii_session = (data.exp_session == data.exp_session(i));
            ii_frame   = (data.vb_frame    == data.vb_frame(i));
            bonus(end+1) = sum(data.resp_value(ii_sub & ii_session & ii_frame));
        end
    end
end
