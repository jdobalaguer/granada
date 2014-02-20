
% folder
if ~exist('data','dir'); mkdir('data'); end

% struct
data = struct();

% experiment
data.exp_subject  = zeros(1,0);
data.exp_session  = zeros(1,0);
data.exp_trial    = zeros(1,0);

% variables
data.vb_getsecs   = zeros(1,0);
data.vb_contrast  = zeros(1,0);
data.vb_phase     = zeros(1,0);
data.vb_angle     = zeros(1,0);

% response
data.resp_getsecs = zeros(1,0);
data.resp_rt      = zeros(1,0);
data.resp_angle   = zeros(1,0);
data.resp_correct = zeros(1,0);
