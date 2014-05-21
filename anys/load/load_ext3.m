

function data = load_ext3(path)
    %% warnings
    %#ok<*BDSCI>
    
    %% load
    if ~exist('path','var'); path = 'scanner'; end
    sub   = load_sub(  path);
    data  = load_data( path);
    index = load_index(path);
    
    %% extend
    
    % subject
    data = ext_sex(data,sub);   ... sex
    
    % index
    data = ext_index(data);     ... index
    data = ext_start(data);     ... start
    
    % value
    data = ext_valcum(data);    ... accumulated value
    data = ext_valcum(data);    ... accumulated value
    
    % distance
    data = ext_samprob(data);   ... EV std/var
    
    % block
    %data = ext_bonus(data,index); ... bonus
    % ... blocked length
    % ... blocked mean(resp_gamble)
    % ... blocked mean(resp_value)
    
    %% sort
    data = struct_sort(data);
end