
%% set task variables
numbers_L = repmat(parameters.dots_numbers,length(parameters.dots_numbers),1);
numbers_R = numbers_L';
numbers_L = repmat(numbers_L(:),ceil(parameters.task_nbtrials/length(numbers_L(:))),1)';
numbers_R = repmat(numbers_R(:),ceil(parameters.task_nbtrials/length(numbers_R(:))),1)';
i_numbers = randperm(length(numbers_L));
numbers_L = numbers_L(i_numbers);
numbers_R = numbers_R(i_numbers);
numbers_L(parameters.task_nbtrials+1:end) = [];
numbers_R(parameters.task_nbtrials+1:end) = [];

data.vb_left        = numbers_L;
data.vb_right       = numbers_R;
data.vb_max         = max(numbers_L,numbers_R);
data.vb_category    = sign(numbers_R - numbers_L);

%% clean
clear numbers_L numbers_R i_numbers;
