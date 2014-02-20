if index.trial==1; return; end


Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.frame_colours(data.vb_frame(index.trial-1),:));
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);

%% Plot
DrawFormattedText(  ...
        ptb.screen_w,                                           ... window
        sprintf('%d',data.vb_distance(index.trial-1)-1),        ... text
        'center',                                               ... sx
        ptb.screen_center(2) - 50,                              ... sy
        parameters.frame_colours(data.vb_frame(index.trial-1),:)... color
    );
