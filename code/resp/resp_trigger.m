
%% Read trigger
while isnan(index.gs_trigger)
    
    % get secs
    gs = GetSecs();

    % read
    [down,secs,code] = KbCheck();

    % save trigger
    if down && code(KbName('S'))
        index.gs_trigger = gs;
        break;
    end
    
end

%% Clean
clear down secs code gs;
