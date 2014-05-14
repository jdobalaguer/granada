    
%% SESSION
screen_presession;
while ~index.endsession && ~index.escape
    %% TRIAL
    % set trial
    set_trial;
    % do trial
    do_trial;
    
    %% BONUS
    % set bonus
    set_bonus;
    % do bonus
    do_bonus;
    
    %% END OF SESSION
    set_endofsession;
end
screen_possession;

%% SAVE
% save data
data_save;
