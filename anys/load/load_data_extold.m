
function alldata = load_fixed2(path)
    if ~exist('path','var'); path = 'data'; end
    alldata = load_data(path);
    
    % numbers
    nb_subject = length(unique(alldata.exp_subject));
    nb_trial   = length(unique(alldata.exp_trial));
    
    % set random responses
    for i = find(isnan(alldata.resp_category))
        if rand()>0.5
            alldata.resp_category(i) = -1;
        else
            alldata.resp_category(i) = +1;
        end
    end
    
    % set total duration
    alldata.vb_tdisance = max(alldata.exp_trial) + 1 - alldata.exp_trial;
    
    % set start stop
    alldata.exp_first = (alldata.exp_trial   == 1);
    alldata.exp_last  = (alldata.vb_tdisance == 1);
    
    % sort
    alldata = struct_sort(alldata);
end