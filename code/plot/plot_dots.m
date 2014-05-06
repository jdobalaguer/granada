
% % left
% pos = ptb.screen_center + [-0.5 * parameters.frame_radius, 0];
% DrawFormattedText(ptb.screen_w,num2str(data.vb_left(index.trial)) ,pos(1),pos(2),parameters.frame_colours(data.vb_frame(index.trial),:));
% 
% % right
% pos = ptb.screen_center + [+0.5 * parameters.frame_radius, 0];
% DrawFormattedText(ptb.screen_w,num2str(data.vb_right(index.trial)),pos(1),pos(2),parameters.frame_colours(data.vb_frame(index.trial),:));

%% initialize
% numbers
nb_left      = data.vb_left(index.trial);
nb_right     = data.vb_right(index.trial);
% radius
radius_min   = parameters.frame_fixation + .5*parameters.frame_thick_black + parameters.dots_radius + parameters.dots_marge;
radius_max   = parameters.frame_radius                                     - parameters.dots_radius - parameters.dots_marge;
% coord
coord_left   = zeros(nb_left, 2);
coord_right  = zeros(nb_right,2);
% overlapping
overlapping  = 1;

%% set dots
while   any(coord_left(:,1)  > - .5*parameters.frame_thick_color - parameters.frame_thick_black - parameters.dots_marge) || ...
        any(coord_right(:,1) < + .5*parameters.frame_thick_color + parameters.frame_thick_black + parameters.dots_marge) || ...
        overlapping
    
    % radius
    radius_left  = radius_min + (radius_max - radius_min) * rand(nb_left, 1);
    radius_right = radius_min + (radius_max - radius_min) * rand(nb_right,1);
    % angle
    angle_left   = pi*rand(nb_left, 1) + .5*pi;
    angle_right  = pi*rand(nb_right,1) - .5*pi;
    % coordinates
    coord_left   = [radius_left  , radius_left]  .* [cos(angle_left) , sin(angle_left )];
    coord_right  = [radius_right , radius_right] .* [cos(angle_right), sin(angle_right)];
    % overlapping left
    [x1,x2] = meshgrid(coord_left(:,1),coord_left(:,1));
    dist_x = (x1(:)-x2(:)).*(x1(:)-x2(:));
    [y1,y2] = meshgrid(coord_left(:,2),coord_left(:,2));
    dist_y = (y1(:)-y2(:)).*(y1(:)-y2(:));
    dist   = dist_x + dist_y;
    dist(~dist) = Inf;
    overlapping_left = any(dist < power(parameters.dots_radius+parameters.dots_marge,2));
    % overlapping right
    [x1,x2] = meshgrid(coord_right(:,1),coord_right(:,1));
    dist_x = (x1(:)-x2(:)).*(x1(:)-x2(:));
    [y1,y2] = meshgrid(coord_right(:,2),coord_right(:,2));
    dist_y = (y1(:)-y2(:)).*(y1(:)-y2(:));
    dist   = dist_x + dist_y;
    dist(~dist) = Inf;
    overlapping_right = any(dist < power(parameters.dots_radius+parameters.dots_marge,2));
    % overlapping
    overlapping = overlapping_left || overlapping_right;
end

%% shift coordinates
coord_left   = coord_left  + repmat(ptb.screen_center,nb_left, 1);
coord_right  = coord_right + repmat(ptb.screen_center,nb_right,1);

%% plot
% left
for i_left = 1:nb_left
    Screen(ptb.screen_w,'FillOval',parameters.frame_colours(data.vb_frame(index.trial),:), ...
        [coord_left(i_left,:)-parameters.dots_radius, coord_left(i_left,:)+parameters.dots_radius]);
    
end
% right
for i_right = 1:nb_right
    Screen(ptb.screen_w,'FillOval',parameters.frame_colours(data.vb_frame(index.trial),:), ...
        [coord_right(i_right,:)-parameters.dots_radius, coord_right(i_right,:)+parameters.dots_radius]);
    
end


%% clean
clear nb_left nb_right;
clear radius_min radius_max radius_left radius_right;
clear angle_left angle_right;
clear coord_left coord_right;
clear x1 x2 y1 y2;
clear dist dist_x dist_y;
clear i_left i_right
clear overlapping overlapping_left overlapping_right;
