
function alldata = load_fixed()
    alldata = load_data();
    
    % numbers
    nb_subject = length(unique(alldata.exp_subject));
    nb_trial   = length(unique(alldata.exp_trial));
    
    % set random responses
    for i = find(isnan(alldata.resp_angle))
        if rand()>0.5
            alldata.resp_angle(i) = 45;
        else
            alldata.resp_angle(i) = -45;
        end
    end
    
    % set total duration
    alldata.vb_tdisance = max(alldata.exp_trial) + 1 - alldata.exp_trial;
    
    % set start stop
    alldata.exp_first = (alldata.exp_trial   == 1);
    alldata.exp_last  = (alldata.vb_tdisance == 1);
end