    
%% INITIALIZE
% create data
data_create;

while ~end_of_session
    %% TRIAL
    % set trial
    set_trial;
    % do trial
    do_trial;
    
    %% END OF SESSION
    set_endofsession;
end
