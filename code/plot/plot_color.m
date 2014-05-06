if ~index.session, return; end
if ~parameters.task_usessions(index.session), return; end

%% Plot colours
nb_frames = parameters.frame_number;

for i_frame = 1:nb_frames
    
    position =  [   ptb.screen_rect(1) + ptb.screen_drect(1) * (i_frame) / (nb_frames+1),   ...
                    ptb.screen_rect(2) + ptb.screen_drect(2) - (2 * parameters.frame_small) ...
                ];
    Screen( ptb.screen_w,                                           ... window
            'FillOval',                                             ... fill oval
            parameters.frame_colours(i_frame,:),                    ... colour
            [   position - .5 * parameters.frame_small,... rectangle
                position + .5 * parameters.frame_small...
            ]                                                       ...
        );

    
end

%% Clean
clear nb_frames i_frame position;