
%% Get secs
gs = GetSecs();

%% read
[down,secs,code] = KbCheck();

%% process
if down && sum(code)==1 && find(code) 
    code = find(code);
    switch code
        % escape
        case KbName('Escape')
            end_of_task    = 1;
            end_of_session = 1;
            fprintf('Exit forced by user.\n');
        % left
        case KbName('A');
            % trialstruct
            trialstruct.resp_getsecs    = gs;
            trialstruct.resp_rt         = gs - ptb.screen_time_this;
            trialstruct.resp_angle      = -1 * parameters.gabor_angle;
            trialstruct.resp_correct    = (trialstruct.vb_angle == trialstruct.resp_angle);
            % break
        % right
        case KbName('C');
            % trialstruct
            trialstruct.resp_getsecs    = gs;
            trialstruct.resp_rt         = gs - ptb.screen_time_this;
            trialstruct.resp_angle      = +1 * parameters.gabor_angle;
            trialstruct.resp_correct     = (trialstruct.vb_angle == trialstruct.resp_angle);
            % break
    end
end

%% clean
clear down secs code gs;
