
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
            index.endtask    = 1;
            index.endsession = 1;
            fprintf('Exit forced by user.\n');
        % left
        case KbName(parameters.key_left);
            trialstruct.resp_getsecs    = gs;
            trialstruct.resp_rt         = gs - ptb.screen_time_this;
            trialstruct.resp_category   = -1;
            trialstruct.resp_correct    = (data.vb_category(index.trial) == trialstruct.resp_category);
            if ~data.vb_category(index.trial), trialstruct.resp_correct = rand()>0.5; end
            plot_beep;
        % right
        case KbName(parameters.key_right);
            trialstruct.resp_getsecs    = gs;
            trialstruct.resp_rt         = gs - ptb.screen_time_this;
            trialstruct.resp_category   = +1;
            trialstruct.resp_correct    = (data.vb_category(index.trial) == trialstruct.resp_category);
            if ~data.vb_category(index.trial), trialstruct.resp_correct = rand()>0.5; end
            plot_beep;
    end
end

%% clean
clear down secs code;
