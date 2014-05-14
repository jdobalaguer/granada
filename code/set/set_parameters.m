
parameters = struct();

%% flag
parameters.flag_debug           = 0;
parameters.flag_scanner         = 1;
parameters.flag_audio           = 1;
parameters.flag_verbose         = 1;

%% task
parameters.task_nbsessions      =  5;
parameters.task_nbtrials        = 15;%75;

%% keyboard
parameters.key_escape           = 'Escape';
parameters.key_gamble           = 'F';
parameters.key_reject           = 'J';
parameters.key_trigger          = 'S';

%% time
parameters.time_presession      = 10.0;
parameters.time_possession      =  5.0;
parameters.time_isimin          =  3.0;
parameters.time_isimax          =  7.0;
parameters.time_trial           =  3.0;
parameters.time_feedback        =  1.0;
parameters.time_bonus           =  2.0;

%% screen
parameters.screen_rect          = []; %[0,0,1200,800];
parameters.screen_bg_color      = [  0,  0,  0];
parameters.screen_bk_color      = [255,255,255];
parameters.screen_fontcolor     = [128,128,128];
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
% wins
% parameters.gamble_wins          = [+1.00 , +1.50 , +2.00 , +2.50 , +3.00 , +1.00 , +1.50 , +2.00 , +2.50 , +3.00 , +1.50 , +2.00 , +2.50 , +3.00 , +2.00 , +2.50 , +3.00];
parameters.gamble_wins = repmat(reshape(+1.00:+1.00:+3.00,[3,1,1]),[1,3,3]);
parameters.gamble_wins = parameters.gamble_wins(:);
% loss
% parameters.gamble_loss          = [-0.40 , -0.90 , -1.40 , -1.90 , -2.40 , -0.17 , -0.50 , -0.83 , -1.17 , -1.50 , -0.21 , -0.43 , -0.64 , -0.86 , -0.12 , -0.25 , -0.37];
parameters.gamble_loss = repmat(reshape(-1.00:-1.00:-3.00,[1,3,1]),[3,1,3]);
parameters.gamble_loss = parameters.gamble_loss(:);
% prob
% parameters.gamble_prob          = [ 0.50 ,  0.50 ,  0.50 ,  0.50 ,  0.50 ,  0.40 ,  0.40 ,  0.40 ,  0.40 ,  0.40 ,  0.30 ,  0.30 ,  0.30 ,  0.30 ,  0.20 ,  0.20 ,  0.20];
parameters.gamble_prob = repmat(reshape([0.33,0.50,0.66],[1,1,3]),[3,3,1]);
parameters.gamble_prob = parameters.gamble_prob(:);
% baseline
parameters.gamble_not           = -0.10;
parameters.gamble_miss          = -1.00;

%% lottery
parameters.lottery_min            = -1;
parameters.lottery_max            = +3;
%% stimulus
% frame
parameters.frame_thick          =   4;
parameters.frame_number         =   5;
parameters.frame_proprange      = [ 0.20 , 1.50];
parameters.frame_fixation       =  50;
parameters.frame_small          =  50;
parameters.frame_colors         =  [];
% stim
parameters.stim_radius          = 100;
