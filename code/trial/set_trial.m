
% index
index.trial = index.trial + 1;

% trial struct
trialstruct = struct();
trialstruct.vb_getsecs      = nan;
trialstruct.vb_isi          = parameters.time_isimin + (parameters.time_isimax - parameters.time_isimin) * rand();
trialstruct.vb_contrast     = randi(length(parameters.gabor_contrast));
trialstruct.vb_phase        = rand();
trialstruct.vb_angle        = randsample([-1,+1],1) * parameters.gabor_angle;
trialstruct.resp_getsecs    = nan;
trialstruct.resp_rt         = nan;
trialstruct.resp_angle      = nan;
trialstruct.resp_correct    = nan;