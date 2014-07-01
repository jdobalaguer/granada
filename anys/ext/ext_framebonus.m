
function data = ext_framebonus(data)
    %% numbers
    nb_total   = length(data.exp_subject);
    
    u_subject  = unique(data.exp_subject);
    u_session  = unique(data.exp_session);
    u_frame    = unique(data.vb_frame);
    
    nb_subject = length(u_subject);
    nb_session = length(u_session);
    nb_frame   = length(u_frame);
        
    %% frame length
    for i_subject = 1:nb_subject
        for i_session = 1:nb_session
            for i_frame = 1:nb_frame
                ii_subject = (data.exp_subject == u_subject(i_subject));
                ii_session = (data.exp_session == u_session(i_session));
                ii_frame   = (data.vb_frame    == u_frame(  i_frame));
                ii = (ii_subject & ii_session & ii_frame);
                data.vb_framebonus(ii) = sum(data.resp_value(ii));
            end
        end
    end
end
