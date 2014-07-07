
function data = ext_optimal(data)
    %% numbers
    nb_total   = length(data.exp_subject);
    nb_subject = length(unique(data.exp_subject));
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(data.exp_trial));
    
    %% mean / variance / standard deviation
    data.vb_exv    = nan(1,nb_total);
    data.vb_var    = nan(1,nb_total);
    for i = 1:nb_total
        [mu,va] = samprob(  data.vb_wins(i),     ...x
                            data.vb_loss(i),     ...n
                            data.vb_prob(i),     ...p
                            data.vb_distance(i)  ...u
                        );
        data.vb_exv(i) = mu;
        data.vb_var(i) = va;
    end
    data.vb_std = sqrt(data.vb_var);
    
    %% difficulty
    data.vb_exh = abs(data.vb_exv - 0.10);
    
end
