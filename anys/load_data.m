
function alldata = load_data()
    path_dir = ['data',filesep()];
    d = dir([path_dir,'data_*.mat']);
    d = strcat(path_dir,cell2mat({d(:).name}'));
    
    % paths
    path_subject = unique(d(:,1:end-5),'rows');
    path_session = str2num(unique(d(:,end-4)));
    path_session(~path_session) = [];
    
    % numbers
    nb_subject = size(path_subject,1);
    nb_session = max(path_session);
    
    % concatenate
    alldata = [];
    for i_subject = 1:nb_subject
        subdata = [];
        for i_session = 1:nb_session
            path_file = sprintf('%s%d.mat',path_subject(i_subject,:),path_session(i_session));
            assert(exist(path_file,'file')>0,'load_data: cant find "%s"',path_file);
            sesdata = load(path_file,'data');
            subdata = concat_struct(2,subdata,sesdata.data);
        end
        alldata = concat_struct(2,alldata,subdata);
    end
end

function ret = concat_struct(dim,s1,s2)
    if isempty(s1), ret = s2; return; end
    
    u_field = fieldnames(s1);
    nb_fields = length(u_field);
    
    ret = struct();
    for i_field = 1:nb_fields
        this_field = u_field{i_field};
        
        % get values
        v1 = s1.(this_field);
        v2 = s2.(this_field);
        
        % concat values
        v = cat(dim,v1,v2);
        
        % save value
        ret.(this_field) = v;
    end
end