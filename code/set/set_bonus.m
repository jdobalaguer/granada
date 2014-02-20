
if trialstruct.resp_correct
    index.bonus =   index.bonus + ...
                    parameters.task_bonus ./ (parameters.task_nbsessions * parameters.task_nbtrials);
end