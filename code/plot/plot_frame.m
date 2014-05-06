if ~index.session, return; end

%% Disc
% black
Screen( ptb.screen_w,                                           ... window
        'FillOval',                                             ... fill oval
        [0,0,0],                                                ... colour
        [   ptb.screen_center - parameters.frame_radius - parameters.frame_thick_color - 2*parameters.frame_thick_black,  ... rectangle
            ptb.screen_center + parameters.frame_radius + parameters.frame_thick_color + 2*parameters.frame_thick_black   ...
        ]                                                       ...
    );

% color
Screen( ptb.screen_w,                                           ... window
        'FillOval',                                             ... fill oval
        parameters.frame_colours(data.vb_frame(index.trial),:), ... colour
        [   ptb.screen_center - parameters.frame_radius - parameters.frame_thick_color - parameters.frame_thick_black,  ... rectangle
            ptb.screen_center + parameters.frame_radius + parameters.frame_thick_color + parameters.frame_thick_black   ...
        ]                                                       ...
    );

% black
Screen( ptb.screen_w,                                           ... window
        'FillOval',                                             ... fill oval
        [0,0,0],                                                ... colour
        [   ptb.screen_center - parameters.frame_radius - parameters.frame_thick_black, ... rectangle
            ptb.screen_center + parameters.frame_radius + parameters.frame_thick_black  ...
        ]                                                       ...
    );

% background
Screen( ptb.screen_w,                                           ... window
        'FillOval',                                             ... fill oval
        parameters.screen_bg_color,                             ... colour
        [   ptb.screen_center - parameters.frame_radius,        ... rectangle
            ptb.screen_center + parameters.frame_radius         ...
        ]                                                       ...
    );

%% Line
% black
Screen( ptb.screen_w,                                       ... window
    'FillRect',                                             ... fill oval
    [0,0,0],                                                ... colour
    [   ptb.screen_center - [.5*parameters.frame_thick_color + parameters.frame_thick_black, parameters.frame_radius + parameters.frame_thick_black],  ... rectangle
        ptb.screen_center + [.5*parameters.frame_thick_color + parameters.frame_thick_black, parameters.frame_radius + parameters.frame_thick_black]   ...
    ]                                                       ...
);

% color
Screen( ptb.screen_w,                                       ... window
    'FillRect',                                             ... fill oval
    parameters.frame_colours(data.vb_frame(index.trial),:), ... colour
    [   ptb.screen_center - [.5*parameters.frame_thick_color, parameters.frame_radius + parameters.frame_thick_black],  ... rectangle
        ptb.screen_center + [.5*parameters.frame_thick_color, parameters.frame_radius + parameters.frame_thick_black]   ...
    ]                                                       ...
);

%% Fixation
% black
Screen( ptb.screen_w,                                       ... window
    'FillOval',                                             ... fill oval
    [0,0,0],                                                ... colour
    [   ptb.screen_center - parameters.frame_fixation - .5*parameters.frame_thick_black,  ... rectangle
        ptb.screen_center + parameters.frame_fixation + .5*parameters.frame_thick_black   ...
    ]                                                       ...
);
    
% background
Screen( ptb.screen_w,                                       ... window
    'FillOval',                                             ... fill oval
        parameters.screen_bg_color,                         ... colour
    [   ptb.screen_center - parameters.frame_fixation + .5*parameters.frame_thick_black,  ... rectangle
        ptb.screen_center + parameters.frame_fixation - .5*parameters.frame_thick_black   ...
    ]                                                       ...
);
    
