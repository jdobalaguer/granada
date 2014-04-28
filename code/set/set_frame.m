
%% Set condition
if parameters.task_usessions(index.session)
    nb_frames = parameters.frame_number;
else
    nb_frames = 1;
end

%% Set frames
u_frame   = zeros(1,nb_frames+1);

while   any(diff(u_frame) < 0.20*parameters.task_nbtrials/parameters.frame_number)  || ...
        any(diff(u_frame) > 1.50*parameters.task_nbtrials/parameters.frame_number)
        
    u_frame(1)       = 1;
    u_frame(2:end-1) = sort(randi(parameters.task_nbtrials,1,nb_frames-1));
    u_frame(end)     = parameters.task_nbtrials+1;
    
    if nb_frames==1, break; end
end
    
%% Set data
data.vb_frame     = zeros(1,parameters.task_nbtrials);
data.vb_distance  = zeros(1,parameters.task_nbtrials);
for i_frame = 1:nb_frames
    data.vb_frame(    u_frame(i_frame) : u_frame(i_frame+1)-1) = i_frame;
    data.vb_distance( u_frame(i_frame) : u_frame(i_frame+1)-1) = (u_frame(i_frame+1)-u_frame(i_frame)):-1:1;
end

%% Clean
clear nb_frames u_frame i_frame;