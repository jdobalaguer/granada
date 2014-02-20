

Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

%% Plot
plot_gabor;

%% Time
ptb.screen_time_this = GetSecs;
ptb.screen_time_next = ptb.screen_time_this + parameters.time_trial;
trialstruct.vb_getsecs = ptb.screen_time_this;

%% Flip
Screen(ptb.screen_w,'Flip');

%% Wait
gs = GetSecs();
while   gs < ptb.screen_time_next       && ... time
        isnan(trialstruct.resp_angle)   && ... response
        ~index.endtask                     ... exit
        
    % get response
    resp_trial;
end
resp_none;

%% Clean
clear gs;
