
function data = ext_sex(data,sub)
    %% numbers
    nb_total   = length(data.exp_subject);
    nb_subject = length(unique(data.exp_subject));
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(data.exp_trial));
    
    %% sex
    data.exp_sex = double(mat2vec(repmat(sub.sex=='m',nb_index,1)))';
end
