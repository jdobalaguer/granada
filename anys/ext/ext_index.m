
function data = ext_index(data)
    %% numbers
    nb_total   = length(data.exp_subject);
    nb_subject = length(unique(data.exp_subject));
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(data.exp_trial));
    
    %% index
    data.exp_index = mat2vec(repmat(1:nb_index,1,nb_subject))';
    
end
