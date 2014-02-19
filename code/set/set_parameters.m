if exist('parameters','var'); return; end;

parameters = struct();

%% flag
% debugging
parameters.flag_debug         = 1;%0;
parameters.flag_virtual       = 0;%1;
% response
parameters.flag_respmouse     = 0;
parameters.flag_respkb        = 1;

%% parameters
parameters.pars_yangle  = .25*pi;
parameters.pars_range  = [-1,+1];

%% variables
parameters.vb_mean      = 0;
parameters.vb_var       = 1;
parameters.vb_setsize   = 4;
parameters.vb_radi      = 120;
parameters.vb_contrast  = nan;

%% staircase
parameters.stair_do        = 1;
parameters.stair_blocks    = 20;
parameters.stair_accuracy  = 0.65;
parameters.stair_intensity = [.025,.50,.75,.10,.15,.20,.30,.40];

%% task
parameters.task_nbtrials  = 25;

%% time
parameters.time_fixation = 0.4;
parameters.time_response = 1.5;
parameters.time_minresponse = 0.4;
parameters.time_feedback = 0.2;
parameters.time_isi      = 0.2;

%% screen
% general
parameters.screen_rect      = [0,0,600,400];
%parameters.screen_rect      = [0,0,1080,810];
%parameters.screen_rect      = [0 0 1280 1024]; %lab screen
%parameters.screen_rect      = [0 0 1024 768];  %c125 screen
parameters.screen_bg_color  = [128,128,128];
parameters.screen_fontcolor = [224,224,224];
parameters.screen_fontbgcolor = [0,0,0,0];
parameters.screen_fontsize  = 36;
parameters.screen_fontname  = 'Arial';

%% messages
parameters.screen_txtintro = 'hola, gracias por participar!';
parameters.screen_txtstair = 'staircase';
parameters.screen_txttask  = 'preparado?';
parameters.screen_txtslow  = 'demasiado lento';
parameters.screen_txtend   = 'fin del experimento! gracias por tu colaboracion.';

%% stimulus
% fixation
parameters.stim_fix_radi  = 4;                                            % fixation size
% gabor
parameters.screen_gabor_ppd             = 30;
parameters.screen_gabor_size            = 4*parameters.screen_gabor_ppd;
parameters.screen_gabor_envelopedev     = parameters.screen_gabor_size/4;
parameters.screen_gabor_frequency       = 2/parameters.screen_gabor_ppd;
parameters.screen_gabor_noisekerneldev  = (1/6)/parameters.screen_gabor_frequency;
parameters.screen_gabor_noisedev        = 0.1;
parameters.screen_gabor_lumibg          = 0.3;
parameters.screen_aperture              = 8;


%% coherence
if parameters.flag_virtual && parameters.task_by_min
    error('set_parameters: error. flag_virtual and task_by_min incompatibles. use task_by_block instead!');
end
