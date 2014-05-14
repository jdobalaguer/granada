
% folder
if ~exist('data','dir'); mkdir('data'); end

% struct
data = struct();

% experiment
data.exp_subject    = zeros(1,0);
data.exp_session    = zeros(1,0);
data.exp_trial      = zeros(1,0);
data.exp_trigger    = zeros(1,0);

% variables
    % time
data.vb_getsecs     = zeros(1,0);
data.vb_isi         = zeros(1,0);
    % frame
data.vb_frame       = zeros(1,0);
data.vb_distance    = zeros(1,0);
data.vb_distoend    = zeros(1,0);
    % task
data.vb_reversal    = zeros(1,0);
data.vb_category    = zeros(1,0);
data.vb_coherent    = zeros(1,0);

% response
data.resp_getsecs   = zeros(1,0);
data.resp_rt        = zeros(1,0);
data.resp_category  = zeros(1,0);
data.resp_correct   = zeros(1,0);
