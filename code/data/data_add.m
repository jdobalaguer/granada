if end_of_task; return; end






% experiment
data.exp_subject(end+1) = participant.id;
data.exp_session(end+1) = i_session;
data.exp_trial(end+1)   = i_trial;

% variables
data.vb_getsecs(end+1)   = trialstruct.vb_getsecs;
data.vb_contrast(end+1)  = trialstruct.vb_contrast;
data.vb_phase(end+1)     = trialstruct.vb_phase;
data.vb_angle(end+1)     = trialstruct.vb_angle;

% response

data.resp_getsecs(end+1) = trialstruct.resp_getsecs;
data.resp_rt(end+1)      = trialstruct.resp_rt;
data.resp_angle(end+1)   = trialstruct.resp_angle;
data.resp_correct(end+1) = trialstruct.resp_correct;
