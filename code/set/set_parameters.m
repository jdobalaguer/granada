
parameters = struct();

%% flag
parameters.flag_debug           = 0;
parameters.flag_scanner         = 1;

%% task
parameters.task_nbsessions      =   4;
parameters.task_nbtrials        = 150;
parameters.task_bonus           =  5;
parameters.task_usessions       =  [];

%% staircase
parameters.stair_nb             =   9;
parameters.stair_samples        =  50;
parameters.stair_range          = [3,30];
parameters.stair_contrasts      = exp(linspace(log(parameters.stair_range(1)),log(parameters.stair_range(2)), parameters.stair_nb));
parameters.stair_performance    = 0.6 : 0.05 : 0.9;

%% time
parameters.time_presession      = 10.0;
parameters.time_trial           =  1.5;
parameters.time_stimulus        =  0.5;
parameters.time_isimin          =  2.0;
parameters.time_isimax          =  5.0;
parameters.time_possession      =  5.0;

%% screen
% general
%parameters.screen_rect          = [0,0,1200,800];
parameters.screen_bg_color      = [128,128,128];
parameters.screen_fontcolor     = [224,224,224];
parameters.screen_fontbgcolor   = [0,0,0,0];
parameters.screen_fontsize      = 36;
parameters.screen_fontname      = 'Arial';

%% messages
parameters.screen_txtintro      = 'hola, gracias por participar!';
parameters.screen_txttask       = 'preparado?';
parameters.screen_txtsession    = 'esperando trigger..';
parameters.screen_txtbonus      = 'Bonus: %.2f EUR';
parameters.screen_txtend        = 'fin del experimento! gracias por tu colaboracion.';

%% stimulus
% fixation
parameters.fixation_radi        = 4;
parameters.fixation_color       = [255,255,255];
% gabor
parameters.gabor_size           = 300;
parameters.gabor_envelopedev    = 7 * parameters.gabor_size;
parameters.gabor_angle          = 45;
parameters.gabor_frequency      = 0.03;
parameters.gabor_phase          = 0;
parameters.gabor_contrast       = [];
parameters.gabor_noisekerneldev = 10;
parameters.gabor_noisedev       = 30;
% frame
parameters.frame_sizeout        = 600;
parameters.frame_sizein         = 570;
parameters.frame_sizesmall      =  50;
parameters.frame_number         =   5;
parameters.frame_colours        = 255 .* hsv2rgb([mod(linspace(0.10,0.90,parameters.frame_number)+rand(),1);ones(1,parameters.frame_number);ones(1,parameters.frame_number)]');
