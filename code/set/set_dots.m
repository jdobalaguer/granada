
%% initialize
radius_min   = parameters.frame_fixation + .5*parameters.frame_thick_black + max(parameters.dots_radius) + parameters.dots_marge;
radius_max   = parameters.frame_radius                                     - max(parameters.dots_radius) - parameters.dots_marge;

%% left coordinates
nb_left      = data.vb_left(index.trial);
coord_left   = zeros(nb_left, 2);
overlapping  = 1;
while   any(coord_left(:,1) + max(parameters.dots_radius) > - .5*parameters.frame_thick_color - parameters.frame_thick_black - parameters.dots_marge) || ...
        overlapping

    % coordinates
    radius       = radius_min + (radius_max - radius_min) * rand(nb_left, 1);
    angle        = pi*rand(nb_left, 1) + .5*pi;
    size_left    = RandSel(parameters.dots_radius,nb_left);
    coord_left   = [radius  , radius]  .* [cos(angle) , sin(angle )];
    % overlapping
    [x1,x2] = meshgrid(coord_left(:,1),coord_left(:,1));
    dist_x = (x1(:)-x2(:)).*(x1(:)-x2(:));
    [y1,y2] = meshgrid(coord_left(:,2),coord_left(:,2));
    dist_y = (y1(:)-y2(:)).*(y1(:)-y2(:));
    dist   = dist_x + dist_y;
    dist(~dist) = Inf;
    overlapping = any(dist < power(2*max(size_left)+parameters.dots_marge,2));
end

%% right coordinates
nb_right     = data.vb_right(index.trial);
coord_right  = zeros(nb_right,2);
overlapping  = 1;
while   any(coord_right(:,1) - max(parameters.dots_radius) < + .5*parameters.frame_thick_color + parameters.frame_thick_black + parameters.dots_marge) || ...
        overlapping
    
    % coordinates
    radius       = radius_min + (radius_max - radius_min) * rand(nb_right,1);
    angle        = pi*rand(nb_right,1) - .5*pi;
    size_right   = RandSel(parameters.dots_radius,nb_right);
    coord_right  = [radius , radius] .* [cos(angle), sin(angle)];
    % overlapping right
    [x1,x2] = meshgrid(coord_right(:,1),coord_right(:,1));
    dist_x = (x1(:)-x2(:)).*(x1(:)-x2(:));
    [y1,y2] = meshgrid(coord_right(:,2),coord_right(:,2));
    dist_y = (y1(:)-y2(:)).*(y1(:)-y2(:));
    dist   = dist_x + dist_y;
    dist(~dist) = Inf;
    overlapping = any(dist < power(2*max(size_right)+parameters.dots_marge,2));
end

%% save
trialstruct.vb_position = {coord_left,coord_right};
trialstruct.vb_radius   = {size_left, size_right};

%% clean
clear nb_left nb_right;
clear coord_left coord_right;
clear radius_min radius_max;
clear radius angle;
clear x1 x2 y1 y2;
clear dist dist_x dist_y;
clear overlapping;
