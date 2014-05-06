
parameters = struct();

%% flag
parameters.flag_debug           = 0;
parameters.flag_scanner         = 1;
parameters.flag_audio           = 0;

%% task
parameters.task_nbsessions      =   8;
parameters.task_nbtrials        =  75;
parameters.task_bonus           =   5;
parameters.task_usessions       =  [];

%% keyboard
parameters.key_escape           = 'Escape';
parameters.key_left             = 'F';
parameters.key_right            = 'J';
parameters.key_trigger          = 'S';

%% time
parameters.time_presession      = 10.0;
parameters.time_possession      =  5.0;
parameters.time_isimin          =  2.0;
parameters.time_isimax          =  5.0;
parameters.time_trial           =  1.5;
parameters.time_stimulus        =  0.5;

%% screen
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
% frame
parameters.frame_radius         = 300;
parameters.frame_thick_black    =   4;
parameters.frame_thick_color    =  16;
parameters.frame_fixation       =  50;
parameters.frame_small          =  50;
parameters.frame_number         =   5;
parameters.frame_colours        = 255 .* hsv2rgb([mod(linspace(0.10,0.90,parameters.frame_number)+rand(),1);ones(1,parameters.frame_number);ones(1,parameters.frame_number)]');
% stimulus
parameters.dots_numbers         = [6,9,15,24,38];
parameters.dots_radius          = 5;
parameters.dots_marge           = 3;