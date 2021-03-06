

function data = load_data_ext(varargin)
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
    if ~forced && exist(path_fil,'file') && ~isempty(who('-file',path_fil,'data'))
        loadfile = load(path_fil);
        data = loadfile.data;
        return;
    end
    
    %% load
    sub   = load_sub( varargin{1});
    data  = load_data(varargin{1});
    %index = load_index(path);
    
    %% extend
    
    % subject
    data = ext_data_sex(data,sub);   ... sex

    % timing
    data = ext_data_onset(data);     ... scanner onset

    % block
    data = ext_data_framelngth(data);... frame length
    data = ext_data_framebonus(data);... frame bonus
    
    % index
    data = ext_data_index(data);     ... index
    data = ext_data_start(data);     ... start

    % distance
    data = ext_data_distart(data);   ... distance from start
    data = ext_data_distery(data);   ... distance to lottery
    data = ext_data_distexp(data);   ... distance to end of experiment
    
    % value
    data = ext_data_valcum(data);    ... accumulated value
    data = ext_data_valast(data);    ... last values
    data = ext_data_vanext(data);    ... next values
    
    
    % block
    %data = ext_bonus(data,index); ... bonus
    % ... blocked length
    % ... blocked mean(resp_gamble)
    % ... blocked mean(resp_value)
    
    % response
    data = ext_data_response(data);
    data = ext_data_galast(data);
    
    % optimal (based on expected value)
    data = ext_data_optimal(data);

    % subjective (based on general linear model)
    data = ext_data_subjective(data); ... subjective value
    
    %% sort
    data = struct_sort(data);
    
    %% save
    if exist(path_fil,'file')
        save(path_fil,'-append','data');
    else
        save(path_fil,'data');
    end
    
end