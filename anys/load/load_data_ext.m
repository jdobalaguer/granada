

function data = load_data_ext(varargin)
    %% warnings
    %#ok<*BDSCI>
    
    %% load
    sub   = load_sub( varargin{:});
    data  = load_data(varargin{:});
    %index = load_index(path);
    
    %% extend
    
    % subject
    data = ext_sex(data,sub);   ... sex

    % timing
    data = ext_onset(data);     ... scanner onset

    % index
    data = ext_index(data);     ... index
    data = ext_start(data);     ... start
    
    % distance
    data = ext_samprob(data);   ... EV std/var
    data = ext_distery(data);   ... distance to lottery
    
    % value
    data = ext_valcum(data);    ... accumulated value
    data = ext_valast(data);    ... last values
    data = ext_vanext(data);    ... next values
    data = ext_values(data);    ... unexpected value (& others)
    
    % block
    %data = ext_bonus(data,index); ... bonus
    % ... blocked length
    % ... blocked mean(resp_gamble)
    % ... blocked mean(resp_value)
    
    % response
    data = ext_galast(data);
    
    %% sort
    data = struct_sort(data);
end