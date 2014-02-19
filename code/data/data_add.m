if end_of_task; return; end

nb_trials = parameters.task_nbtrials;
% experiment
data.exp_sub(   end+1:end+nb_trials) = participant.id;
data.exp_the(   end+1:end+nb_trials) = participant.theta;
data.exp_block( end+1:end+nb_trials) = i_block;
data.exp_trial( end+1:end+nb_trials) = 1:nb_trials;
data.exp_SR(    end+1:end+nb_trials) = participant.SR;

% variables
data.vb_x(:,    end+1:end+nb_trials) = blockstruct.vb_x;
data.vb_b(:,    end+1:end+nb_trials) = blockstruct.vb_b;
data.vb_y(      end+1:end+nb_trials) = blockstruct.vb_y;
data.vb_ycat(   end+1:end+nb_trials) = blockstruct.vb_ycat;
data.vb_c(      end+1:end+nb_trials) = blockstruct.vb_c;
data.vb_e1(     end+1:end+nb_trials) = blockstruct.vb_e1;
data.vb_e2(     end+1:end+nb_trials) = blockstruct.vb_e2;

% response
data.resp_gs(   end+1:end+nb_trials) = blockstruct.resp_gs;
data.resp_rt(   end+1:end+nb_trials) = blockstruct.resp_rt;
data.resp_ycat( end+1:end+nb_trials) = blockstruct.resp_ycat;
data.resp_cor(  end+1:end+nb_trials) = blockstruct.resp_cor;
