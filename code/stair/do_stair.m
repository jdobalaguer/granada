
%% TIME
parameters.time_isimin          =  1.0;
parameters.time_isimax          =  1.0;

%% CONTRASTS
vb_contrast = repmat(parameters.stair_contrasts,[1,parameters.stair_samples]);
vb_contrast = tools_shuffle(vb_contrast);
parameters.task_nbtrials = numel(vb_contrast);

%% SESSION
while ~index.endsession
    
    %% TRIAL
    % contrast
    parameters.gabor_contrast = vb_contrast(index.trial+1);
    % set trial
    set_trial;
    % do trial
    do_trial;
    
    %% END OF SESSION
    set_endofsession;
end

%% CLEAN
clear vb_contrast;
