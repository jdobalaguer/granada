
if parameters.flag_checkers
    if ptb.checker_i
        Screen('DrawTexture', ptb.screen_w, ptb.checker_tex1, [], ptb.screen_rect, [], 0);
    else
        Screen('DrawTexture', ptb.screen_w, ptb.checker_tex2, [], ptb.screen_rect, [], 0);
    end
    ptb.checker_i = mod(ptb.checker_i+1,2);
end
