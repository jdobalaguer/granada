if end_of_task; return; end

if ~exist('data','var') || isempty(data.exp_block)
    i_block = 0;
else
    i_block = max(data.exp_block);
end