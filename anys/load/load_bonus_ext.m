

function bonus = load_bonus_ext(varargin)
    %% warnings
    %#ok<*BDSCI>
    
    %% defaults
    path   = 'scanner';
    forced = 0;
    if length(varargin) >= 1, path   = varargin{1}; end
    if length(varargin) >= 2, forced = varargin{2}; end
    
    %% preload
    path_dir = ['data',filesep(),path,filesep()];
    path_fil = [path_dir,'000_ext.mat'];
    if ~forced && exist(path_fil,'file') && ~isempty(who('-file',path_fil,'bonus'))
        loadfile = load(path_fil);
        bonus = loadfile.bonus;
        return;
    end
    
    %% load
    data  = load_data(varargin{1});
    bonus = load_bonus(varargin{1});
    
    %% extend
    bonus = ext_bonus_frame(bonus);
    bonus = ext_bonus_length(bonus,data);
    
    %% sort
    bonus = struct_sort(bonus);
    
    %% save
    if exist(path_fil,'file')
        save(path_fil,'-append','bonus');
    else
        save(path_fil,'bonus');
    end
    
end