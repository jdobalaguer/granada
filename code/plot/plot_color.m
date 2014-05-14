

%% Plot colors
n_frame = parameters.frame_number;

for i_frame = 1:n_frame
    
    position =  [   ptb.screen_rect(1) + ptb.screen_drect(1) * (i_frame) / (n_frame+1),   ...
                    ptb.screen_rect(2) + (2 * parameters.frame_small) ...
                ];
    Screen( ptb.screen_w,                                           ... window
            'FillOval',                                             ... fill oval
            parameters.frame_colors(i_frame,:),                     ... color
            [   position - .5 * parameters.frame_small,... rectangle
                position + .5 * parameters.frame_small...
            ]                                                       ...
        );

    
end

%% Clean
clear n_frame i_frame position;