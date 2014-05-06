
disp('Conditions');

%% warning
%#ok<*ST2NM>

%% sessions
nb_sessions = parameters.task_nbsessions;
parameters.task_usessions = zeros(1,nb_sessions);
parameters.task_usessions(1:ceil(0.5*nb_sessions)) = 1;
parameters.task_usessions = tools_shuffle(parameters.task_usessions);

%% space
disp('')

%% clean
clear nb_sessions;
