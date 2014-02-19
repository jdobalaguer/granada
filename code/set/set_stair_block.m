%% indexes
i_block = i_block + 1;
i_trial = 0;
end_of_block = 0;

%% block struct
blockstruct = struct();

% indexes
blockstruct.nb_trials = length(parameters.stair_intensity);

% variables
blockstruct.vb_ycat    = nan(1,                     blockstruct.nb_trials);
blockstruct.vb_c       = nan(1,                     blockstruct.nb_trials);
blockstruct.vb_g       = cell(1,                    blockstruct.nb_trials);
blockstruct.vb_e       = nan(1,                     blockstruct.nb_trials);

% resp
blockstruct.resp_gs    = nan(1,                     blockstruct.nb_trials);
blockstruct.resp_rt    = nan(1,                     blockstruct.nb_trials);
blockstruct.resp_ycat  = nan(1,                     blockstruct.nb_trials);
blockstruct.resp_cor   = nan(1,                     blockstruct.nb_trials);

%% set variables
ok = 0;
while ~ok
    % value
    blockstruct.vb_ycat     = sign(randn(blockstruct.nb_trials,1));
    % contrast
    blockstruct.vb_c        = parameters.stair_intensity(randperm(blockstruct.nb_trials));
    % gabor, energy
    [blockstruct.vb_g,blockstruct.vb_e1,blockstruct.vb_e2,gaborrct] = ptb_screen_setgabor(parameters,ptb,blockstruct);
    
    % criteria
    ok = 1;
end
