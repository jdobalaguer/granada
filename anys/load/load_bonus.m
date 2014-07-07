
function bonus = load_bonus(path)
    if ~exist('path','var'); path = 'scanner'; end

    % load
    index = load_index_ext(path);
    
    % rename fields
    bonus = struct();
    
    bonus.getsecs = index.gs_bonus;
    bonus.onset   = index.ons_bonus;
    bonus.scanner = index.sca_bonus;
    
    bonus.subject = index.sub_bonus;
    bonus.session = index.ses_bonus;
    
    bonus.bonus   = index.bonus;

end
