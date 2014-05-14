if ~index.session, return; end

n_frame = parameters.frame_number;

%% Plot colors
% left
position =  [   ptb.screen_rect(1) + ptb.screen_drect(1) * 1 / 3,   ...
                ptb.screen_center(2)                                ...
            ];
Screen( ptb.screen_w,                                               ... window
        'FillOval',                                                 ... fill oval
        parameters.frame_colors(data.vb_frame(index.trial),:),      ... color
        [   position - .5 * parameters.stim_thick ,                 ... rectangle
            position + .5 * parameters.stim_thick                   ...
        ]                                                           ...
    );

% right
position =  [   ptb.screen_rect(1) + ptb.screen_drect(1) * 2 / 3,   ...
                ptb.screen_center(2)                                ...
            ];
Screen( ptb.screen_w,                                               ... window
        'FillRect',                                                 ... fill oval
        parameters.frame_colors(data.vb_frame(index.trial),:),      ... color
        [   position - .5 * parameters.stim_thick ,                 ... rectangle
            position + .5 * parameters.stim_thick                   ...
        ]                                                           ...
    );


%% Clean
clear n_frame i_frame position;
