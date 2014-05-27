
function alldata = load_index(path)
    if ~exist('path','var'); path = 'scanner'; end
    path_dir = ['data',filesep(),path,filesep()];
    d = dir([path_dir,'data_*_5.mat']);
    d = strcat(path_dir,cell2mat({d(:).name}'));
    
    % paths
    path_subject = unique(d(:,1:end-5),'rows');
    
    % numbers
    nb_subject = size(path_subject,1);
    
    % concatenate
    alldata = [];
    for i_subject = 1:nb_subject
        subdata = [];
        path_file = sprintf('%s%d.mat',path_subject(i_subject,:),5);
        assert(exist(path_file,'file')>0,'load_data: cant find "%s"',path_file);
        sesdata = load(path_file,'index');
        subdata = struct_concat(2,subdata,sesdata.index);
        alldata = struct_concat(2,alldata,subdata);
    end
end

function ret = struct_concat(dim,s1,s2)
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