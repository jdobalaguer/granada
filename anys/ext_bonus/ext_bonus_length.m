
function bonus = ext_length(bonus,data)
    %% numbers
    nb_total   = length(data.exp_subject);
    
    u_subject  = unique(data.exp_subject);
    u_session  = unique(data.exp_session);
    u_frame    = unique(data.vb_frame);
    
    nb_subject = length(u_subject);
    nb_session = length(u_session);
    nb_frame   = length(u_frame);
        
    %% frame length
    bonus.length = nan(1,nb_subject*nb_session*nb_frame);
    for i_subject = 1:nb_subject
        for i_session = 1:nb_session
            for i_frame = 1:nb_frame
                ii_data_subject = (data.exp_subject == u_subject(i_subject));
                ii_data_session = (data.exp_session == u_session(i_session));
                ii_data_frame   = (data.vb_frame    == u_frame(  i_frame));
                ii_data = (ii_data_subject & ii_data_session & ii_data_frame);
                
                ii_bonus_subject = (bonus.subject == u_subject(i_subject));
                ii_bonus_session = (bonus.session == u_session(i_session));
                ii_bonus_frame   = (bonus.frame   == u_frame(  i_frame));
                ii_bonus = (ii_bonus_subject & ii_bonus_session & ii_bonus_frame);
                assert(sum(ii_bonus)==1, 'ext_bonus_length: error 1.');
                
                bonus.length(ii_bonus_frame) = sum(ii_data);
            end
        end
    end
end
