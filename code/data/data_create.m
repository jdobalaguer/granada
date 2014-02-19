if exist('data','var');   return; end

% folder
if ~exist('data','dir')
    mkdir 'data';
end

% struct
data = struct();

% experiment
data.exp_sub   = zeros(1,0);
data.exp_the   = zeros(1,0);
data.exp_block = zeros(1,0);
data.exp_trial = zeros(1,0);
data.exp_SR    = zeros(1,0);

% variables
data.vb_x       = zeros(parameters.vb_setsize,0);
data.vb_b       = zeros(parameters.vb_setsize,0);
data.vb_y       = zeros(1,0);
data.vb_ycat    = zeros(1,0);
data.vb_c       = zeros(1,0);
data.vb_e1      = zeros(1,0);
data.vb_e2      = zeros(1,0);

% response
data.resp_gs    = zeros(1,0);
data.resp_rt    = zeros(1,0);
data.resp_ycat  = zeros(1,0);
data.resp_cor   = zeros(1,0);
