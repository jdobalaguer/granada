
function bonus = ext_frame(bonus)
    %% numbers
    nb_frame   = 5;
    nb_session = length(unique(bonus.session));
    nb_subject = length(unique(bonus.subject));
    
    %% frame
    bonus.frame = repmat(1:nb_frame,[1,nb_session*nb_subject]);
end
