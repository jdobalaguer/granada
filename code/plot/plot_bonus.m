if ~index.session, return; end



Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

%% Plot
DrawFormattedText(  ...
        ptb.screen_w,                                   ... window
        sprintf(parameters.screen_txtbonus,index.bonus),... text
        'center',                                       ... sx
        30,                                             ... sy
        parameters.screen_fontcolor                     ... color
    );
