
%% Set frames
nb_frames = size(parameters.frame_colours,1);
u_frame   = zeros(1,nb_frames+1);

while any(diff(u_frame) <  4)  || ...
      any(diff(u_frame) > 36) 
        
    u_frame(1)       = 1;
    u_frame(2:end-1) = sort(randi(parameters.task_nbtrials,1,nb_frames-1));
    u_frame(end)     = parameters.task_nbtrials;
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