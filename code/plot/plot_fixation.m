
Screen( ptb.screen_w,               ... window
        'FillOval',                 ... fill oval
        parameters.fixation_color,  ... colour
        [                           ... rectangle
            ptb.screen_center-parameters.fixation_radi, ...
            ptb.screen_center+parameters.fixation_radi  ...
        ]                           ...
    );
