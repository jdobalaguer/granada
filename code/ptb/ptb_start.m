if ~exist('ptb','var')
    ptb = struct();
end

if parameters.flag_virtual; return; end

%% Preferences
% verbosity
Screen('Preference', 'Verbosity',0);
Screen('Preference', 'SuppressAllWarnings', 1);
% skip tests
if parameters.flag_debug        Screen('Preference', 'SkipSyncTests', 1);
else                            Screen('Preference', 'SkipSyncTests', 2);
end

%% Time
ptb.time_start = GetSecs;

%% Screen
AssertOpenGL;
% open window
if isfield(parameters,'screen_rect') && ~isempty(parameters.screen_rect)
    [tmp_w, tmp_r] = Screen('OpenWindow', 0, 0,parameters.screen_rect,32,2);
else
    [tmp_w, tmp_r] = Screen('OpenWindow', 0, 0,[],32,2);
end

% values
ptb.screen_w = tmp_w;
ptb.screen_rect = tmp_r;
ptb.screen_drect = [(ptb.screen_rect(3)-ptb.screen_rect(1)) , (ptb.screen_rect(4)-ptb.screen_rect(2))];
ptb.screen_center = [ptb.screen_rect(1) , ptb.screen_rect(2)] + .5*ptb.screen_drect;
ptb.screen_bg_color = parameters.screen_bg_color;
ptb.screen_time_this = 0;
ptb.screen_time_min  = 0;
ptb.screen_time_next = 0;
ptb.screen_fps = Screen('FrameRate',ptb.screen_w);

% textures
Screen('Preference', 'TextAlphaBlending', 1);
Screen(ptb.screen_w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% checker
if parameters.flag_checkers
    stim_r = sqrt(.3183 * parameters.stim_harea);
    [circle_x,circle_y] = meshgrid(ptb.screen_rect(1):ptb.screen_rect(3),ptb.screen_rect(2):ptb.screen_rect(4));
    % distance
    circle_dist = sqrt((circle_x-ptb.screen_center(1)).^2 + (circle_y-ptb.screen_center(2)).^2);
    % angle
    circle_angle = atan2(circle_y-ptb.screen_center(2) , circle_x-ptb.screen_center(1))*360/pi;
    % alpha
    circle_alpha = 255*(circle_dist>parameters.checker_rmin & circle_dist<parameters.checker_rmax);
    % images
    circle_img = parameters.checker_int * (mod( ...
        floor(circle_angle/parameters.checker_astep) + ... % angle
        floor((circle_dist - parameters.checker_rmin)/parameters.checker_rstep) ...
        ,2) - 0.5);
    circle_img1 = uint8(parameters.screen_bg_color(1) + circle_img);
    circle_img2 = uint8(parameters.screen_bg_color(1) - circle_img);
    % make texture
    circle_img1(:,:,2) = circle_alpha;
    circle_img2(:,:,2) = circle_alpha;
    ptb.checker_tex1 = Screen('MakeTexture', ptb.screen_w, circle_img1);
    ptb.checker_tex2 = Screen('MakeTexture', ptb.screen_w, circle_img2);
    ptb.checker_i   =0;
end

%% Mouse
HideCursor;

%% Keyboard
% unify names
KbName('UnifyKeyNames');

%% Audio
% set parameters
ptb.audio_freqlow  = 2500;
ptb.audio_freqhigh = 7500;
ptb.audio_duration  = 0.1;

% initialise port
PsychPortAudio('Verbosity',0);
InitializePsychSound;
try
    ptb.audio_port = PsychPortAudio('Open', [], [], 1, [], 1);
catch
    psychlasterror('reset');
    ptb.audio_port = PsychPortAudio('Open', [], [], 1, [], 1);
end
tmp_s = PsychPortAudio('GetStatus',ptb.audio_port);
ptb.audio_sampling = tmp_s.SampleRate;
