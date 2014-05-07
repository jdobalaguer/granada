
% index
index.trial = index.trial + 1;

% trial struct
trialstruct = struct();
trialstruct.vb_getsecs      = nan;
trialstruct.vb_isi          = parameters.time_isimin + (parameters.time_isimax - parameters.time_isimin) * rand();
trialstruct.vb_condition    = parameters.task_usessions(index.session);
trialstruct.vb_position     = {[],[]};
trialstruct.vb_radius       = {[],[]};
trialstruct.resp_getsecs    = nan;
trialstruct.resp_rt         = nan;
trialstruct.resp_category   = nan;
trialstruct.resp_dots       = nan;
trialstruct.resp_correct    = nan;

% dots
set_dots;