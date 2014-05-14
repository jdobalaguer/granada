
parameters = struct();

%% flag
parameters.flag_debug           = 1;%0;
parameters.flag_scanner         = 0;%1;
parameters.flag_audio           = 1;
parameters.flag_verbose         = 1;

%% task
parameters.task_nbsessions      =   8;
parameters.task_nbtrials        =  75;
parameters.task_bonus           = [-2,3];

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
parameters.screen_rect          = []; %[0,0,1200,800];
parameters.screen_bg_color      = [  0,  0,  0];
parameters.screen_bk_color      = [224,224,224];
parameters.screen_fontcolor     = [224,224,224];
parameters.screen_fontbgcolor   = [  0,  0,  0,  0];
parameters.screen_fontsize      = 36;
parameters.screen_fontname      = 'Arial';

%% messages
parameters.screen_txtintro      = 'hola, gracias por participar!';
parameters.screen_txttask       = 'preparado?';
parameters.screen_txtbreak      = 'pausa';
parameters.screen_txtsession    = 'esperando trigger..';
parameters.screen_txtframe      = 'has acumulado %.2f EUR para la loteria';
parameters.screen_txtlottery    = 'has ganado %.2f EUR !';
parameters.screen_txtend        = 'fin del experimento! gracias por tu colaboracion.';

%% gamble
parameters.gamble_mean          = 0.5;
parameters.gamble_std           = 2.5;
parameters.gamble_

%% stimulus
% frame
parameters.frame_thick          =   4;
parameters.frame_number         =   5;
parameters.frame_proprange      = [0.20 , 1.50];
parameters.frame_fixation       =  50;
parameters.frame_small          =  50;
parameters.frame_colors         =  [];
% stim
parameters.stim_radius          = 500;
parameters.stim_thick           = 150;

