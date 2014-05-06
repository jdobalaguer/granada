
%% index
index.session       = index.session + 1;
index.trial         = 0;
index.endsession    = 0;
index.gs_trigger    = nan;

%% data
data_create;

%% frame
set_frame;

%% data
data_set;

%% filenames
set_filenames;
