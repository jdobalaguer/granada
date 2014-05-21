
function alldata = ext_index(alldata)
    %% numbers
    nb_total   = length(alldata.exp_subject);
    nb_subject = length(unique(alldata.exp_subject));
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(alldata.exp_trial));
    
    %% index
    alldata.exp_index = mat2vec(repmat(1:nb_index,1,nb_subject));
    
end
