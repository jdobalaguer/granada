%% indexes
i_block = i_block + 1;
i_trial = 0;
end_of_block = 0;

%% block struct
blockstruct = struct();

% indexes
blockstruct.nb_trials = parameters.task_nbtrials;

% variables
blockstruct.vb_x       = nan(parameters.vb_setsize, blockstruct.nb_trials);
blockstruct.vb_b       = nan(parameters.vb_setsize, blockstruct.nb_trials);
blockstruct.vb_y       = nan(1,                     blockstruct.nb_trials);
blockstruct.vb_ycat    = nan(1,                     blockstruct.nb_trials);
blockstruct.vb_c       = nan(1,                     blockstruct.nb_trials);
blockstruct.vb_g       = cell(1,                    blockstruct.nb_trials);
blockstruct.vb_e1      = nan(1,                     blockstruct.nb_trials);
blockstruct.vb_e2      = nan(1,                     blockstruct.nb_trials);

% resp
blockstruct.resp_gs    = nan(1,                     blockstruct.nb_trials);
blockstruct.resp_rt    = nan(1,                     blockstruct.nb_trials);
blockstruct.resp_ycat  = nan(1,                     blockstruct.nb_trials);
blockstruct.resp_cor   = nan(1,                     blockstruct.nb_trials);

%% set variables
ok = 0;
while ~ok
    % cues
    blockstruct.vb_x     = tools_mypseudorandrange(...
                                                    parameters.vb_mean,...
                                                    parameters.vb_var,...
                                                    parameters.vb_setsize,...
                                                    0,... % unconstrained on mean or variance
                                                    inf,...
                                                    inf,...
                                                    parameters.pars_range,... % constrained on range
                                                    parameters.task_nbtrials)';
    % coefficients
    blockstruct.vb_b     = participant.betas' * ones(1,parameters.task_nbtrials);
    % value
    blockstruct.vb_y     = sum(blockstruct.vb_b .* blockstruct.vb_x);
    blockstruct.vb_ycat  = sign(blockstruct.vb_y);
    % contrast
    blockstruct.vb_c(:)  = parameters.vb_contrast;
    % gabor, energy
    [blockstruct.vb_g,blockstruct.vb_e1,blockstruct.vb_e2,gaborrct] = ptb_screen_setgabor(parameters,ptb,blockstruct);
    
    % criteria
    ok = 1;
end
