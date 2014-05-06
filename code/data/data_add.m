if index.endtask; return; end






% experiment
data.exp_subject(end+1)     = index.subject;
data.exp_session(end+1)     = index.session;
data.exp_trial(end+1)       = index.trial;
data.exp_trigger(end+1)     = index.gs_trigger;
data.exp_bonus(end+1)       = index.bonus;

% variables
data.vb_getsecs(end+1)      = trialstruct.vb_getsecs;
data.vb_isi(end+1)          = trialstruct.vb_isi;
data.vb_condition(end+1)    = trialstruct.vb_condition;

% response
data.resp_getsecs(end+1)    = trialstruct.resp_getsecs;
data.resp_rt(end+1)         = trialstruct.resp_rt;
data.resp_category(end+1)   = trialstruct.resp_category;
data.resp_correct(end+1)    = trialstruct.resp_correct;
