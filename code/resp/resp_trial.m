
%% Get secs
gs = GetSecs();

%% read
[down,secs,code] = KbCheck();

%% process
if down && sum(code)==1 && find(code) 
    code = find(code);
    switch code
        % escape
        case KbName(parameters.key_escape)
            index.escape     = 1;
            fprintf('Exit forced by user.\n');
        % left
        case KbName(parameters.key_left);
            trialstruct.resp_getsecs    = gs;
            trialstruct.resp_rt         = gs - ptb.screen_time_this;
            trialstruct.resp_category   = -1;
            trialstruct.resp_correct    = (data.vb_category(index.trial)*data.vb_coherent(index.trial) == trialstruct.resp_category);
            plot_beep;
            plot_verbose_resp;
        % right
        case KbName(parameters.key_right);
            trialstruct.resp_getsecs    = gs;
            trialstruct.resp_rt         = gs - ptb.screen_time_this;
            trialstruct.resp_category   = +1;
            trialstruct.resp_correct    = (data.vb_category(index.trial)*data.vb_coherent(index.trial) == trialstruct.resp_category);
            plot_beep;
            plot_verbose_resp;
    end
end

%% clean
clear down secs code;
