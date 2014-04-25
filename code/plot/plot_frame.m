if ~index.session, return; end

%% Outside
Screen( ptb.screen_w,                                           ... window
        'FillOval',                                             ... fill oval
        parameters.frame_colours(data.vb_frame(index.trial),:), ... colour
        [   ptb.screen_center - .5 * parameters.frame_sizeout,  ... rectangle
            ptb.screen_center + .5 * parameters.frame_sizeout   ...
        ]                                                       ...
    );

%% Inside
Screen( ptb.screen_w,                                           ... window
        'FillOval',                                             ... fill oval
        parameters.screen_bg_color,                             ... colour
        [   ptb.screen_center - .5 * parameters.frame_sizein,   ... rectangle
            ptb.screen_center + .5 * parameters.frame_sizein    ...
        ]                                                       ...
    );
