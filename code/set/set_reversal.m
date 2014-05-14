
n_reversal = parameters.frame_number;
u_reversal = zeros(1,n_reversal+1);

%% set frame
while   any(diff(u_reversal) < parameters.frame_proprange(1)*parameters.task_nbtrials/parameters.frame_number)  || ...
        any(diff(u_reversal) > parameters.frame_proprange(2)*parameters.task_nbtrials/parameters.frame_number)
        
    u_reversal(1)       = 1;
    u_reversal(2:end-1) = sort(randi(parameters.task_nbtrials,1,n_reversal-1));
    u_reversal(end)     = parameters.task_nbtrials+1;
    
end
    
%% set data
data.vb_reversal  = zeros(1,parameters.task_nbtrials);
for i_reversal = 1:n_reversal
    data.vb_reversal(    u_reversal(i_reversal) : u_reversal(i_reversal+1)-1) = i_reversal;
end
data.vb_category = sign(mod(data.vb_reversal + randi(2),2) - 0.5);
data.vb_coherent = ones(1,parameters.task_nbtrials);
data.vb_coherent(1:round((1-parameters.task_coherence)*parameters.task_nbtrials)) = -1;
data.vb_coherent = tools_shuffle(data.vb_coherent);

%% clean
clear n_reversal u_reversal i_reversal;
