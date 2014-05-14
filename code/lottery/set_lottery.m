if parameters.flag_debug, return; end
if index.escape, return; end

%% set bonus
bonus = index.bonus(end-parameters.frame_number+1:end);
bonus(bonus < parameters.lottery_min) = [];
bonus(bonus > parameters.lottery_max) = [];
if isempty(bonus), index.bonus(end-parameters.frame_number+1:end); end
index.lottery(end+1) = RandSample(bonus);

%% clean
clear bonus;
