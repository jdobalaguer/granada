
% % left
% pos = ptb.screen_center + [-0.5 * parameters.frame_radius, 0];
% DrawFormattedText(ptb.screen_w,num2str(data.vb_left(index.trial)) ,pos(1),pos(2),parameters.frame_colours(data.vb_frame(index.trial),:));
% 
% % right
% pos = ptb.screen_center + [+0.5 * parameters.frame_radius, 0];
% DrawFormattedText(ptb.screen_w,num2str(data.vb_right(index.trial)),pos(1),pos(2),parameters.frame_colours(data.vb_frame(index.trial),:));

%% initialise
nb_left      = data.vb_left(index.trial);
nb_right     = data.vb_right(index.trial);

%% shift coordinates
coord_left   = trialstruct.vb_position{1} + repmat(ptb.screen_center,nb_left, 1);
coord_right  = trialstruct.vb_position{2} + repmat(ptb.screen_center,nb_right,1);
size_left    = trialstruct.vb_radius{1};
size_right   = trialstruct.vb_radius{2};

%% plot
% left
for i_left = 1:nb_left
    Screen(ptb.screen_w,'FillOval',parameters.frame_colours(data.vb_frame(index.trial),:), ...
        [coord_left(i_left,:)-size_left(i_left), coord_left(i_left,:)+size_left(i_left)]);
    
end
% right
for i_right = 1:nb_right
    Screen(ptb.screen_w,'FillOval',parameters.frame_colours(data.vb_frame(index.trial),:), ...
        [coord_right(i_right,:)-size_right(i_right), coord_right(i_right,:)+size_right(i_right)]);
    
end

%% clean
clear i_left i_right
clear nb_left nb_right;
clear coord_left coord_right;
clear size_left size_right;
