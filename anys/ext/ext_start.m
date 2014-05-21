
function alldata = ext_start(alldata)
    %% numbers
    nb_total   = length(alldata.exp_subject);
    nb_subject = length(unique(alldata.exp_subject));
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(alldata.exp_trial));
    
    %% set first/last trials
    alldata.exp_first = double(alldata.exp_trial   == 1);
    alldata.exp_last  = double(alldata.vb_distoend == 1);
    
end