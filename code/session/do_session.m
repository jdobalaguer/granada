    
%% SESSION
screen_presession;
while ~index.endsession
    %% TRIAL
    % set trial
    set_trial;
    % do trial
    do_trial;
    
    %% END OF SESSION
    set_endofsession;
end
screen_possession;

%% SAVE
% save data
data_save;
