
function index = load_index_ext(varargin)
    %% load
    data  = load_data( varargin{:});
    index = load_index(varargin{:});
    
    %% parameters
    pars_tr = 2;
    
    %% numbers
    u_subject = unique(data.exp_subject);
    u_session = unique(data.exp_session);
     
    nb_subject = length(u_subject);
    nb_session  = length(u_session);
    
    nb_total   = length(data.exp_subject);
    nb_index   = nb_total ./ nb_subject;
    nb_trial   = length(unique(data.exp_trial));
    nb_frame   = length(unique(data.vb_frame));
   
    %% extend
    
    % subject
    index.sub_bonus   = mat2vec(repmat(index.subject,nb_session .* nb_frame,1))';
    index.sub_lottery = mat2vec(repmat(index.subject,nb_session,1))';
    
    % session
    index.ses_bonus   = mat2vec(repmat(1:nb_session,nb_frame,nb_subject))';
    index.ses_lottery = mat2vec(repmat(1:nb_session,1,       nb_subject))';
    
    % onset & scan
    j_session = 0;
    j_frame = 0;
    
    index.ons_bonus     = [];
    index.sca_bonus   = [];
    index.ons_lottery   = [];
    index.sca_lottery = [];
    
    for i_subject = 1:nb_subject
        for i_session = 1:nb_session
            j_session = j_session + 1;
            for i_frame = 1:nb_frame
                j_frame = j_frame + 1;
                
                ii_subject = (data.exp_subject == u_subject(i_subject));
                ii_session = (data.exp_session == u_session(i_session));
                ii         = (ii_subject & ii_session);

                trigger                 = unique(data.exp_trigger(ii));
                index.ons_bonus(end+1)  = index.gs_bonus(j_frame) - trigger;
                index.sca_bonus(end+1)  = index.ons_bonus(end) ./ pars_tr;
            end
            index.ons_lottery(end+1)    = index.gs_lottery(j_session) - trigger;
            index.sca_lottery(end+1)    = index.ons_lottery(end) ./ pars_tr;
        end
    end
    

    %% sort
    index = struct_sort(index);
    
end
