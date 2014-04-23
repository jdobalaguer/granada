if ~index.session, return; end

%% Outside
if index.trial>1,   tmp_colour = parameters.frame_colours(data.vb_frame(index.trial-1),:);
else                tmp_colour = parameters.frame_colours(data.vb_frame(1),:);
end
Screen( ptb.screen_w,                                           ... window
        'FillOval',                                             ... fill oval
        tmp_colour,                                             ... colour
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

%% Clean
clear tmp_colour;
