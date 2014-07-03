function scan3_glm()
    % General Linear Model
    fprintf('\nmake sure you have same participants in data and nii folders!\n\n')
    
    %% WARNINGS
    %#ok<*SETNU>
    %#ok<*AGROW>
    %#ok<*NBRAK>

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_spm                        = [fileparts(which('spm.m')),filesep];
    % nii
    dir_niistudy                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_niisubs                    = dir([dir_niistudy,'sub_*']); dir_niisubs = strcat(dir_niistudy,strvcat(dir_niisubs.name),'/');
    dir_niiepis3                   = strcat(dir_niisubs,'epi3',filesep);
    % data
    dir_datsubs                    = [pwd(),filesep,'data',filesep,'data',filesep,'scanner',filesep];
    dir_glm                        = [pwd(),filesep,'data',filesep,'glm3',filesep,'glm_TAHRVB',filesep];
    dir_datcons                    = [dir_glm,'conditions',filesep];
    dir_datglm1s                   = [dir_glm,'firstlevel',filesep];
    dir_datglm2s                   = [dir_glm,'secondlevel',filesep];
    file_datsubs                   = dir([dir_datsubs,'data_*.mat']); file_datsubs = strcat(dir_datsubs,strvcat(file_datsubs.name));
    file_datcons                   = dir([dir_datcons,'condition_*.mat']); file_datcons = strcat(dir_datcons,strvcat(file_datcons.name));
    file_datreas                   = dir([dir_datcons,'realign_*.mat']); file_datreas = strcat(dir_datcons,strvcat(file_datreas.name));
    
    % VARIABLES
    nb_subjects = size(dir_niisubs, 1);
    n_subject   = [1,2,3];
    u_subject   = set_subjects();
    
    u_contrast  = { ...
                    struct('name','t', 'convec',[ 1, 0, 0, 0, 0, 0]) ...
                    struct('name','a', 'convec',[ 0, 1, 0, 0, 0, 0]) ...
                    struct('name','h', 'convec',[ 0, 0, 1, 0, 0, 0]) ...
                    struct('name','r', 'convec',[ 0, 0, 0, 1, 0, 0]) ...
                    struct('name','v', 'convec',[ 0, 0, 0, 0, 1, 0]) ...
                    struct('name','b', 'convec',[ 0, 0, 0, 0, 0, 1]) ...
                  };
              
    % PARAMETERS
    pars_tr      = 2;
    pars_voxs    = 4;
    
    % FLAGS
    do_all  = true;
    do_regs = do_all || ~exist(dir_datcons ,'file');
    do_frst = do_all || ~exist(dir_datglm1s,'file');
    do_scnd = do_all || true;
    
    %% DELETE
    if do_regs && exist(dir_datcons ,'dir'); rmdir(dir_datcons ,'s'); end
    if do_frst && exist(dir_datglm1s,'dir'); rmdir(dir_datglm1s,'s'); end
    if do_scnd && exist(dir_datglm2s,'dir'); rmdir(dir_datglm2s,'s'); end
    
    %% JOBS
    tic();
    spm_jobman('initcfg');
    build_regressors();         % build regressors
    glm_first_level();          % first  : level
    glm_first_estimate();       % first  : estimate
    glm_second_contrasts();     % second : contrasts
    glm_second_copy();          % second : copy
    glm_second_level();         % second : level
    toc();
    
    %% SET PARTICIPANTS
    function u_subject = set_subjects()
        u_subject = 1:nb_subjects;
        u_subject(n_subject) = [];
        nb_subjects = length(u_subject);
    end
    
    %% BUILD REGRESSORS
    function build_regressors()
        if ~do_regs; return; end
        % make directory
        if ~exist(dir_datcons,'dir'); mkdirp(dir_datcons); end
        % load data
        data  = load_data_ext( 'scanner');
        index = load_index_ext('scanner');
        
        for sub = u_subject
            dir_niiepi3 = strtrim(dir_niiepis3(sub,:));
            fprintf('Building regressors for: %s\n',dir_niiepi3);
            dir_niiruns = dir([strtrim(dir_niiepis3(sub,:)),'run*']); dir_niiruns = strcat(strvcat(dir_niiruns.name),'/');
            nb_runs     = size(dir_niiruns, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                file_datcon = sprintf('%scondition_sub_%02i_run_%02i.mat',dir_datcons,sub,i_run);
                file_datrea = sprintf('%srealign_sub_%02i_run_%02i.mat',  dir_datcons,sub,i_run);
                
                % dirs & files
                dir_niirun     = strcat(dir_niiepi3,strtrim(dir_niiruns(i_run,:)));
                dir_niiimg     = strcat(dir_niirun,'images',filesep);
                dir_niirea     = strcat(dir_niirun,'realignment',filesep);
                dir_niismt     = strcat(dir_niirun,'smooth',filesep);
                file_niirea    = dir([dir_niirea,'rp_image*.txt']);                       file_niirea = strcat(dir_niirea,strvcat(file_niirea.name));
                file_niiimg    = dir([dir_niismt,sprintf('sw%duimages*.nii',pars_voxs)]); file_niiimg = strcat(dir_niismt,strvcat(file_niiimg.name));
                
                cond = {};
                
                % CREATE TRIAL CONDITIONS
                ii_sub = (data.exp_subject == sub);
                ii_run = (data.exp_session == u_run(i_run));
                ii     = (ii_sub & ii_run);
                % task
                z_wins      = + data.vb_wins(ii);           ... wins
                z_loss      = - data.vb_loss(ii);           ... loss
                z_prob      = + data.vb_prob(ii);           ... prob
                % actions
                z_gamble    = + data.resp_signed_gamble(ii);... gamble
                z_right     = + data.resp_signed_right(ii); ... right
                z_value     = + data.resp_value(ii);        ... outcome
                z_valcum    = + data.resp_valcum(ii);       ... cumulative outcome
                % optimal
                z_exv       = + data.vb_exv(ii);            ... expected  values
                z_std       = + data.vb_std(ii);            ... standard deviation
                z_exh       = + data.vb_exh(ii);            ... optimal difficulty
                % heuristic
                z_sxv       = + data.vb_sxv(ii);            ... subjetive values
                z_sxh       = + data.vb_sxh(ii);            ... subjective difficulty
                % distances
                z_distance  = 1 ./ data.vb_distance(ii);    ... inv(bonus distance)
                z_distery   = 1 ./ data.vb_distery(ii);     ... inv(lottery distance)
                
                %{
                    TRIAL REGRESSORS
                    T -- onset trial            ... onset
                
                    X -- wins                   ... task
                    N -- loss
                    P -- prob
                
                    G -- gamble action          ... actions
                    R -- right action
                    V -- outcome
                    W -- cumulative reward
                
                    E -- expected value         ... optimal
                    S -- standard deviation
                    # -- optimal difficulty
                
                    A -- subjective value       ... subjective
                    H -- subjective difficulty
                
                    U -- distance bonus         ... distance
                    Z -- distance lottery

                    BONUS REGRESSORS
                    B -- onset bonus
                    P -- outcome bonus

                    LOTTERY REGRESSORS
                    L -- onset lottery
                %}
                
                name     = 'TRIAL';
                onset    = data.vb_onset(ii);
                subnames = {'A','H','R','V'};
                levels   = {z_sxv,z_sxh,z_right,z_value};
                cond{end+1} = struct('name',name,'onset',{onset},'subname',{subnames},'level',{levels},'duration',{0});
                
                % CREATE BONUS CONDITIONS
                ii_sub    = (index.sub_bonus == sub);
                ii_run    = (index.ses_bonus == u_run(i_run));
                ii        = (ii_sub & ii_run);
                name     = 'BONUS';
                onset    = index.ons_bonus(ii);
                subnames = {};
                levels   = {};
                cond{end+1} = struct('name',name,'onset',{onset},'subname',{subnames},'level',{levels},'duration',{0});
                
%                 % CREATE LOTTERY CONDITIONS
%                 ii_sub    = (index.sub_lottery == sub);
%                 ii_run    = (index.ses_lottery == u_run(i_run));
%                 ii        = (ii_sub & ii_run);
%                 name     = 'LOTTERY';
%                 onset    = index.ons_lottery(ii);
%                 subnames = {};
%                 levels   = {};
%                 cond{end+1} = struct('name',name,'onset',{onset},'subname',{subnames},'level',{levels},'duration',{0});
                
                % load realignment
                R = load(file_niirea);
                
                % save regressors
                save(file_datcon,'cond');
                save(file_datrea,'R');
                
            end
        end
        % update file_datregs
        file_datcons = dir([dir_datcons,'condition_*.mat']); file_datcons = strcat(dir_datcons,strvcat(file_datcons.name));
        file_datreas = dir([dir_datcons,'realign_*.mat']);   file_datreas = strcat(dir_datcons,strvcat(file_datreas.name));
    end
    
    %% FIRST LEVEL
    function glm_first_level()
        if ~do_frst; return; end
        if ~exist(dir_datglm1s,'dir'); mkdirp(dir_datglm1s); end
        
        jobs = {};
        j_run = 0;
        for i_sub = u_subject
            dir_niiepi3 = strtrim(dir_niiepis3(i_sub,:));
            dir_datglm1 = sprintf('%ssub_%02i/',dir_datglm1s,i_sub);
            fprintf('GLM first level for: %s\n',dir_datglm1);
            dir_niiruns = dir([strtrim(dir_niiepis3(i_sub,:)),'run*']); dir_niiruns = strcat(strvcat(dir_niiruns.name),'/');
            nb_runs     = size(dir_niiruns, 1);
            u_run       = 1:nb_runs;
            if ~exist(dir_datglm1,'dir'); mkdirp(dir_datglm1); end
            job = struct();
            job.spm.stats.fmri_spec.dir = {dir_datglm1};
            job.spm.stats.fmri_spec.timing.units  = 'secs';
            job.spm.stats.fmri_spec.timing.RT      = pars_tr;
            job.spm.stats.fmri_spec.timing.fmri_t  = 16;
            job.spm.stats.fmri_spec.timing.fmri_t0 = 1;
            % remove run
            remove_run = [];
            % session
            for i_run = u_run
                % index
                j_run = j_run + 1;
                % dirs & files
                dir_niirun = strcat(dir_niiepi3,strtrim(dir_niiruns(i_run,:)));
                dir_niiimg = strcat(dir_niirun,'images',filesep);
                dir_niismt = strcat(dir_niirun,'smooth',filesep);
                file_niiimg = cellstr(spm_select('FPlist', dir_niismt,['^',sprintf('sw%duimages',pars_voxs),'.*\.nii']));
                file_datcon = strtrim(file_datcons(j_run,:));
                file_datrea = strtrim(file_datreas(j_run,:));
                loadcond = load(file_datcon,'cond');
                % truncate
                nb_ons = 0;
                for i_cond = 1:length(loadcond.cond)
                    if (nb_ons < max(loadcond.cond{i_cond}.onset)/pars_tr)
                        nb_ons = max(loadcond.cond{i_cond}.onset)/pars_tr;
                    end
                end
                nb_ons = ceil(nb_ons);
                nb_nii = size(file_niiimg,1);
                nb_min = min(nb_ons,nb_nii);
                % job
                job.spm.stats.fmri_spec.sess(i_run).scans = file_niiimg;
                job.spm.stats.fmri_spec.sess(i_run).hpf = 128;
                job.spm.stats.fmri_spec.sess(i_run).cond = struct('name',{},'onset',{},'duration',{},'tmod',{},'pmod',{});
                % conditions (regressors, modulators & factors)
                for i_cond1 = 1:length(loadcond.cond)
                    % remove onsets out of boundary
                    nb_rmons = sum(loadcond.cond{i_cond1}.onset/pars_tr > nb_min);
                    if nb_rmons
                        fprintf('    warning: (%02i,%02i,%02i) delete %02i onsets %s \n',i_sub,i_run,i_cond1,nb_rmons,loadcond.cond{i_cond1}.name);
                        fprintf('    warning: delete run %02i \n',i_run);
                        remove_run(end+1) = i_run;
                    end
                    loadcond.cond{i_cond1}.onset(loadcond.cond{i_cond1}.onset/pars_tr > nb_min) = [];
                    % save condition
                    cond = struct();
                    cond.name     = loadcond.cond{i_cond1}.name;
                    cond.onset    = loadcond.cond{i_cond1}.onset;
                    cond.duration = loadcond.cond{i_cond1}.duration;
                    cond.tmod     = 0;
                    cond.pmod     = struct('name', {}, 'param', {}, 'poly', {});
                    for i_cond2 = 1:length(loadcond.cond{i_cond1}.subname)
                        cond.pmod(i_cond2).name  = loadcond.cond{i_cond1}.subname{i_cond2};
                        cond.pmod(i_cond2).param = loadcond.cond{i_cond1}.level{i_cond2};
                        cond.pmod(i_cond2).poly = 1;
                    end
                    job.spm.stats.fmri_spec.sess(i_run).cond(end+1) = cond;
                end
                % realignment
                job.spm.stats.fmri_spec.sess(i_run).multi_reg = {file_datrea};
            end
            % others
            job.spm.stats.fmri_spec.fact = struct('name',{},'levels',{});
            job.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
            job.spm.stats.fmri_spec.volt = 1;
            job.spm.stats.fmri_spec.global = 'None';
            job.spm.stats.fmri_spec.mask = {''};
            job.spm.stats.fmri_spec.cvi = 'AR(1)';
            % remove run
            if ~isempty(remove_run)
                remove_run = unique(remove_run);
                job.spm.stats.fmri_spec.sess(remove_run) = [];
            end
            % add job
            jobs{end+1} = job;
        end
        spm_jobman('run',jobs);
    end
    
    %% FIRST LEVEL: Estimate
    function glm_first_estimate()
        if ~do_frst; return; end
        jobs = {};
        for i_sub = u_subject
            dir_datglm1 = sprintf('%ssub_%02i/',dir_datglm1s,i_sub);
            fprintf('GLM first level estimate for: %s\n',dir_datglm1);
            job = struct();
            job.spm.stats.fmri_est.spmmat = {[dir_datglm1,'SPM.mat']};
            job.spm.stats.fmri_est.method.Classical = 1;
            jobs{end+1} = job;
        end
        spm_jobman('run',jobs);
    end
    
    %% SECOND LEVEL: Contrasts
    function glm_second_contrasts()
        if ~do_scnd; return; end
        jobs = {};
        for i_sub = u_subject
            fprintf('GLM first level contrasts for: subject %02i\n',i_sub);
            dir_datglm1 = sprintf('%ssub_%02i/',dir_datglm1s,i_sub);
            job = struct();
            job.spm.stats.con.spmmat = {[dir_datglm1,'SPM.mat']};
            for i_con = 1:length(u_contrast)
                job.spm.stats.con.consess{i_con}.tcon.name      = u_contrast{i_con}.name;
                job.spm.stats.con.consess{i_con}.tcon.convec    = u_contrast{i_con}.convec;
                job.spm.stats.con.consess{i_con}.tcon.sessrep   = 'replsc';
            end
            job.spm.stats.con.delete = 1;
            jobs{end+1} = job;
        end
        spm_jobman('run',jobs);
    end
    
    %% SECOND LEVEL: Copy files
    function glm_second_copy()
        if ~do_scnd; return; end
        for i_sub = u_subject
            fprintf('GLM second level copy for: subject %02i\n',i_sub);
            for i_con = 1:length(u_contrast)
                dir_datglm1 = sprintf('%ssub_%02i/',dir_datglm1s,i_sub);
                dir_datglm2 = sprintf('%scon_%s/',dir_datglm2s,u_contrast{i_con}.name);
                if ~exist(dir_datglm2,'dir'); mkdirp(dir_datglm2); end
                copyfile(sprintf('%sspmT_%04i.hdr',dir_datglm1,i_con),sprintf('%sspmT_sub%02i_con%02i.hdr',dir_datglm2,i_sub,i_con));
                copyfile(sprintf('%sspmT_%04i.img',dir_datglm1,i_con),sprintf('%sspmT_sub%02i_con%02i.img',dir_datglm2,i_sub,i_con));
                copyfile(sprintf('%scon_%04i.hdr' ,dir_datglm1,i_con),sprintf('%scon_sub%02i_con%02i.hdr' ,dir_datglm2,i_sub,i_con));
                copyfile(sprintf('%scon_%04i.img' ,dir_datglm1,i_con),sprintf('%scon_sub%02i_con%02i.img' ,dir_datglm2,i_sub,i_con));
            end
        end
    end
    
    %% SECOND LEVEL
    function glm_second_level()
        if ~do_scnd; return; end
        jobs = {};
        for i_con = 1:length(u_contrast)
            fprintf('GLM second level for: contrast "%s"\n',u_contrast{i_con}.name);
            dir_datglm2 = sprintf('%scon_%s/',dir_datglm2s,u_contrast{i_con}.name);
            % design
            job = struct();
            job.spm.stats.factorial_design.dir                      = {dir_datglm2};
            job.spm.stats.factorial_design.des.t1.scans             = cellstr(spm_select('FPlist', dir_datglm2, '^spmT_.*\.img$'));
            job.spm.stats.factorial_design.cov                      = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
            job.spm.stats.factorial_design.masking.tm.tm_none       = 1;    % threshold masking
            job.spm.stats.factorial_design.masking.im               = 1;    % implicit mask
            job.spm.stats.factorial_design.masking.em               = {''}; % explicit mask
            job.spm.stats.factorial_design.globalc.g_omit           = 1;    % dont know what it is
            job.spm.stats.factorial_design.globalm.gmsca.gmsca_no   = 1;    % grand mean scaling
            job.spm.stats.factorial_design.globalm.glonorm          = 1;    % global normalization
            jobs{end+1} = job;
            % estimate
            job = struct();
            job.spm.stats.fmri_est.spmmat           = {[dir_datglm2,'SPM.mat']};
            job.spm.stats.fmri_est.method.Classical = 1;
            jobs{end+1} = job;
            % contrast
            job = struct();
            job.spm.stats.con.spmmat                    = {[dir_datglm2,'SPM.mat']};
            job.spm.stats.con.consess{1}.tcon.name      = u_contrast{i_con}.name;
            job.spm.stats.con.consess{1}.tcon.convec    = 1; % contrast vector, here just 1, (simple T)
            job.spm.stats.con.consess{1}.tcon.sessrep   = 'none';
            job.spm.stats.con.delete = 1;
            jobs{end+1} = job;
        end
        spm_jobman('run',jobs);
    end
    
end
