
% model
do_model

if parameters.flag_virtual; return; end

%% Background
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

%% Release keys
if ~parameters.time_response
    key_down = 1;
    while key_down;     key_down = KbCheck();                 end
    mouse_b = 1;
    while any(mouse_b); [mouse_x,mouse_y,mouse_b] = GetMouse; end
end

%% Time
% wait until it's time
while (ptb.screen_time_next>GetSecs); end
% calculate next times
ptb.screen_time_this = GetSecs;
ptb.screen_time_min  = ptb.screen_time_this + parameters.time_minresponse;
ptb.screen_time_next = ptb.screen_time_this + parameters.time_response;

%% Get key
tmp_gs = GetSecs();
while ~parameters.time_response || (tmp_gs < ptb.screen_time_next)
    tmp_gs = GetSecs();
    
    % draw interface
    ptb_screen_plotchecker;
    ptb_screen_plotsquircles;
    ptb_screen_plotgabor;
    
    % flip
    Screen(ptb.screen_w,'Flip');
    
    % get keymouse
    [key_down,key_secs,key_code] = KbCheck();
    [mouse_x,mouse_y,mouse_b]   = GetMouse;
    
    % keyboard response
    if key_down && sum(key_code)==1 && find(key_code) 
        key_code = find(key_code);
        switch key_code
            % escape
            case KbName('Escape')
                end_of_task  = 1;
                end_of_block = 1;
                fprintf('Exit forced by user.\n');
                break;
            % left
            case KbName('LeftArrow');
                if parameters.flag_respkb && tmp_gs > ptb.screen_time_min
                    % blockstruct
                    blockstruct.resp_gs(i_trial)    = tmp_gs;
                    blockstruct.resp_rt(i_trial)    = tmp_gs - ptb.screen_time_this;
                    blockstruct.resp_ycat(i_trial)  = +participant.SR;
                    blockstruct.resp_cor(i_trial)   = (blockstruct.vb_ycat(i_trial) == blockstruct.resp_ycat(i_trial));
                    % break
                    break;
                end
            % right
            case KbName('RightArrow');
                if parameters.flag_respkb && tmp_gs > ptb.screen_time_min
                    % blockstruct
                    blockstruct.resp_gs(i_trial)    = tmp_gs;
                    blockstruct.resp_rt(i_trial)    = tmp_gs - ptb.screen_time_this;
                    blockstruct.resp_ycat(i_trial)  = -participant.SR;
                    blockstruct.resp_cor(i_trial)   = (blockstruct.vb_ycat(i_trial) == blockstruct.resp_ycat(i_trial));
                    % break
                    break;
                end
        end
    end
    
    % mouse response
    if parameters.flag_respmouse && tmp_gs > ptb.screen_time_min
        if IsWin && any(mouse_b([1,2]))
            % blockstruct
            blockstruct.resp_gs(i_trial)    = tmp_gs;
            blockstruct.resp_rt(i_trial)    = tmp_gs - ptb.screen_time_this;
            blockstruct.resp_ycat(i_trial)  = (mouse_b(1) - mouse_b(3)) * participant.SR;
            blockstruct.resp_cor(i_trial)   = (blockstruct.vb_ycat(i_trial) == blockstruct.resp_ycat(i_trial));
            % break
            break;
        end
        if ~IsWin && any(mouse_b([1,3]))
            % blockstruct
            blockstruct.resp_gs(i_trial)    = tmp_gs;
            blockstruct.resp_rt(i_trial)    = tmp_gs - ptb.screen_time_this;
            blockstruct.resp_ycat(i_trial)  = (mouse_b(1) - mouse_b(2)) * participant.SR;
            blockstruct.resp_cor(i_trial)   = (blockstruct.vb_ycat(i_trial) == blockstruct.resp_ycat(i_trial));
            % break
            break;
        end
    end
end

% quick trials
if parameters.flag_quicktrials
    ptb.screen_time_next = tmp_gs;
end
