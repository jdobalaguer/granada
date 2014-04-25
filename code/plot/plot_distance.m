if ~index.session, return; end


Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.frame_colours(data.vb_frame(index.trial),:));
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

%% Plot
DrawFormattedText(  ...
        ptb.screen_w,                                           ... window
        sprintf('%d',data.vb_distance(index.trial)),            ... text
        'center',                                               ... sx
        'center',                                               ... sy
        parameters.frame_colours(data.vb_frame(index.trial),:)  ... color
    );
