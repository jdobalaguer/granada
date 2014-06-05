function scan3_gsm()
    % General Super Model
    % (pooling all sessions in one)
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
    dir_gsm                        = [pwd(),filesep,'data',filesep,'gsm3',filesep,'TRUZF_BP_LO',filesep];
    dir_datcons                    = [dir_gsm,'conditions',filesep];
    dir_datgsm1s                   = [dir_gsm,'firstlevel',filesep];
    dir_datgsm2s                   = [dir_gsm,'secondlevel',filesep];
    file_datsubs                   = dir([dir_datsubs,'data_*.mat']); file_datsubs = strcat(dir_datsubs,strvcat(file_datsubs.name));
    file_datcons                   = dir([dir_datcons,'condition_*.mat']); file_datcons = strcat(dir_datcons,strvcat(file_datcons.name));
    file_datreas                   = dir([dir_datcons,'realign_*.mat']); file_datreas = strcat(dir_datcons,strvcat(file_datreas.name));
    file_datconms                  = dir([dir_datcons,'condition_*_merged.mat']); file_datconms = strcat(dir_datcons,strvcat(file_datconms.name));
    file_datreams                  = dir([dir_datcons,'realign_*_merged.mat']); file_datreams = strcat(dir_datcons,strvcat(file_datreams.name));
    
    % VARIABLES
    nb_subjects = size(dir_niisubs, 1);
    n_subject   = [1,2,3];
    u_subject   = set_subjects();
    
    u_contrast  = { ...
                    struct('name','t', 'convec',[ 1, 0, 0, 0, 0, 0, 0, 0, 0]) ...
                    struct('name','r', 'convec',[ 0, 1, 0, 0, 0, 0, 0, 0, 0]) ...
                    struct('name','u', 'convec',[ 0, 0, 1, 0, 0, 0, 0, 0, 0]) ...
                    struct('name','z', 'convec',[ 0, 0, 0, 1, 0, 0, 0, 0, 0]) ...
                    struct('name','f', 'convec',[ 0, 0, 0, 0, 1, 0, 0, 0, 0]) ...
                    struct('name','b', 'convec',[ 0, 0, 0, 0, 0, 1, 0, 0, 0]) ...
                    struct('name','p', 'convec',[ 0, 0, 0, 0, 0, 0, 1, 0, 0]) ...
                    struct('name','l', 'convec',[ 0, 0, 0, 0, 0, 0, 0, 1, 0]) ...
                    struct('name','o', 'convec',[ 0, 0, 0, 0, 0, 0, 0, 0, 1]) ...
                  };
              
    % PARAMETERS
    pars_tr      = 2;
    pars_voxs    = 4;
    
    % FLAGS
    do_all  = true;
    do_regs = do_all || ~exist(dir_datcons ,'file');
    do_frst = do_all || ~exist(dir_datgsm1s,'file');
    do_scnd = do_all || true;
    
    %% DELETE
    if do_regs && exist(dir_datcons ,'dir'); rmdir(dir_datcons ,'s'); end
    if do_frst && exist(dir_datgsm1s,'dir'); rmdir(dir_datgsm1s,'s'); end
    if do_scnd && exist(dir_datgsm2s,'dir'); rmdir(dir_datgsm2s,'s'); end
    
    %% JOBS
    tic();
    spm_jobman('initcfg');
    build_regressors();         % build regressors
    merge_regressors();         % merge regressors
    gsm_first_level();          % first  : level
    gsm_first_estimate();       % first  : estimate
    gsm_second_contrasts();     % second : contrasts
    gsm_second_copy();          % second : copy
    gsm_second_level();         % second : level
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
                z_distexp   = 1 ./ data.vb_distexp(ii);     ... inv(expend distance)
                
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
                    F -- distance expend

                    BONUS REGRESSORS
                    B -- onset bonus
                    P -- outcome bonus

                    LOTTERY REGRESSORS
                    L -- onset lottery
                    O -- outcome lottery
                %}
                
                name     = 'T';
                onset    = data.vb_onset(ii);
                subnames = {'R','U','Z','F'};
                levels   = {z_right,z_distance,z_distery,z_distexp};
                cond{end+1} = struct('name',name,'onset',{onset},'subname',{subnames},'level',{levels},'duration',{0});
                
                % CREATE BONUS CONDITIONS
                ii_sub    = (index.sub_bonus == sub);
                ii_run    = (index.ses_bonus == u_run(i_run));
                ii        = (ii_sub & ii_run);
                name     = 'B';
                onset    = index.ons_bonus(ii);
                subnames = {'P'};
                levels   = {index.bonus(ii)};
                cond{end+1} = struct('name',name,'onset',{onset},'subname',{subnames},'level',{levels},'duration',{0});
                
                % CREATE LOTTERY CONDITIONS
                ii_sub    = (index.sub_lottery == sub);
                ii_run    = (index.ses_lottery == u_run(i_run));
                ii        = (ii_sub & ii_run);
                name     = 'L';
                onset    = index.ons_lottery(ii);
                subnames = {'O'};
                levels   = {index.lottery(ii)};
                cond{end+1} = struct('name',name,'onset',{onset},'subname',{subnames},'level',{levels},'duration',{0});
                
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
    
    %% MERGE REGRESSORS
    function merge_regressors()
        if ~do_regs; return; end
        for sub = u_subject
            dir_niiepi3 = strtrim(dir_niiepis3(sub,:));
            fprintf('Building regressors for: %s\n',dir_niiepi3);
            dir_niiruns = dir([dir_niiepi3,'run*']); dir_niiruns = strcat(strvcat(dir_niiruns.name),'/');
            nb_runs     = size(dir_niiruns, 1);
            u_run       = 1:nb_runs;
            
            % concatenate realignment
            R = zeros(0,6);
            nb_volumes = nan(size(u_run));
            for i_run = 1:nb_runs
                run = u_run(i_run);
                file_datreaR = sprintf('%srealign_sub_%02i_run_%02i.mat',  dir_datcons,sub,i_run);
                tmp  = load(file_datreaR,'R');
                R = [R ; tmp.R];
                nb_volumes(i_run) = size(tmp.R,1);
            end
            file_datreaS = sprintf('%srealign_sub_%02i_merged.mat',  dir_datcons,sub);
            save(file_datreaS,'R');
            
            % concatenate conditions
            onset = 0;
            cond = {};
            load(sprintf('%scondition_sub_%02i_run_%02i.mat',dir_datcons,sub,u_run(1)));
            for i_run = 2:nb_runs
                onset = onset + pars_tr * nb_volumes(i_run-1);
                run = u_run(i_run);
                file_datconR = sprintf('%scondition_sub_%02i_run_%02i.mat',dir_datcons,sub,i_run);
                tmp = load(file_datconR,'cond');
                for i_cond = 1:length(cond)
                    cond{i_cond}.onset = [cond{i_cond}.onset, tmp.cond{i_cond}.onset + onset];
                    for i_level = 1:length(cond{i_cond}.level)
                        cond{i_cond}.level{i_level} = [cond{i_cond}.level{i_level}, tmp.cond{i_cond}.level{i_level}];
                    end
                end
                
            end
            file_datconS = sprintf('%scondition_sub_%02i_merged.mat',dir_datcons,sub);
            save(file_datconS,'cond');
        end
        % update file_datregs
        file_datconms = dir([dir_datcons,'condition_*_merged.mat']); file_datconms = strcat(dir_datcons,strvcat(file_datconms.name));
        file_datreams = dir([dir_datcons,'realign_*_merged.mat']);   file_datreams = strcat(dir_datcons,strvcat(file_datreams.name));
    end
    
    %% FIRST LEVEL
    function gsm_first_level()
        if ~do_frst; return; end
        if ~exist(dir_datgsm1s,'dir'); mkdirp(dir_datgsm1s); end
        
        jobs = {};
        for i_sub = 1:nb_subjects
            sub = u_subject(i_sub);
            dir_niiepi3 = strtrim(dir_niiepis3(sub,:));
            dir_datgsm1 = sprintf('%ssub_%02i/',dir_datgsm1s,sub);
            fprintf('GSM first level for: %s\n',dir_datgsm1);
            dir_niiruns = dir([dir_niiepi3,'run*']); dir_niiruns = strcat(strvcat(dir_niiruns.name),'/');
            nb_runs     = size(dir_niiruns, 1);
            u_run       = 1:nb_runs;
            if ~exist(dir_datgsm1,'dir'); mkdirp(dir_datgsm1); end
            job = struct();
            job.spm.stats.fmri_spec.dir = {dir_datgsm1};
            job.spm.stats.fmri_spec.timing.units  = 'secs';
            job.spm.stats.fmri_spec.timing.RT      = pars_tr;
            job.spm.stats.fmri_spec.timing.fmri_t  = 16;
            job.spm.stats.fmri_spec.timing.fmri_t0 = 1;
            % get files
            file_allimg = [];
            for i_run = u_run
                % dirs & files
                dir_niirun = strcat(dir_niiepi3,strtrim(dir_niiruns(i_run,:)));
                dir_niiimg = strcat(dir_niirun,'images',filesep);
                dir_niismt = strcat(dir_niirun,'smooth',filesep);
                file_niiimg = cellstr(spm_select('FPlist', dir_niismt,['^',sprintf('sw%duimages',pars_voxs),'.*\.nii']));
                file_allimg = [file_allimg ; file_niiimg];
            end
            % job
            job.spm.stats.fmri_spec.sess.scans = file_allimg;
            job.spm.stats.fmri_spec.sess.hpf = 128;
            job.spm.stats.fmri_spec.sess.cond = struct('name',{},'onset',{},'duration',{},'tmod',{},'pmod',{});
            % conditions (regressors, modulators & factors)
            file_datcon = strtrim(file_datconms(i_sub,:));
            loadcond = load(file_datcon,'cond');
            for i_cond1 = 1:length(loadcond.cond)
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
                job.spm.stats.fmri_spec.sess.cond(end+1) = cond;
            end
            % realignment
            file_datrea = strtrim(file_datreams(i_sub,:));
            job.spm.stats.fmri_spec.sess.multi_reg = {file_datrea};
            % others
            job.spm.stats.fmri_spec.fact = struct('name',{},'levels',{});
            job.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
            job.spm.stats.fmri_spec.volt = 1;
            job.spm.stats.fmri_spec.global = 'None';
            job.spm.stats.fmri_spec.mask = {''};
            job.spm.stats.fmri_spec.cvi = 'AR(1)';
            % add job
            jobs{end+1} = job;
        end
        save jobs jobs
        spm_jobman('run',jobs);
    end
    
    %% FIRST LEVEL: Estimate
    function gsm_first_estimate()
        if ~do_frst; return; end
        jobs = {};
        for i_sub = u_subject
            dir_datgsm1 = sprintf('%ssub_%02i/',dir_datgsm1s,i_sub);
            fprintf('gsm first level estimate for: %s\n',dir_datgsm1);
            job = struct();
            job.spm.stats.fmri_est.spmmat = {[dir_datgsm1,'SPM.mat']};
            job.spm.stats.fmri_est.method.Classical = 1;
            jobs{end+1} = job;
        end
        spm_jobman('run',jobs);
    end
    
    %% SECOND LEVEL: Contrasts
    function gsm_second_contrasts()
        if ~do_scnd; return; end
        jobs = {};
        for i_sub = u_subject
            fprintf('gsm first level contrasts for: subject %02i\n',i_sub);
            dir_datgsm1 = sprintf('%ssub_%02i/',dir_datgsm1s,i_sub);
            job = struct();
            job.spm.stats.con.spmmat = {[dir_datgsm1,'SPM.mat']};
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
    function gsm_second_copy()
        if ~do_scnd; return; end
        for i_sub = u_subject
            fprintf('gsm second level copy for: subject %02i\n',i_sub);
            for i_con = 1:length(u_contrast)
                dir_datgsm1 = sprintf('%ssub_%02i/',dir_datgsm1s,i_sub);
                dir_datgsm2 = sprintf('%scon_%s/',dir_datgsm2s,u_contrast{i_con}.name);
                if ~exist(dir_datgsm2,'dir'); mkdirp(dir_datgsm2); end
                copyfile(sprintf('%sspmT_%04i.hdr',dir_datgsm1,i_con),sprintf('%sspmT_sub%02i_con%02i.hdr',dir_datgsm2,i_sub,i_con));
                copyfile(sprintf('%sspmT_%04i.img',dir_datgsm1,i_con),sprintf('%sspmT_sub%02i_con%02i.img',dir_datgsm2,i_sub,i_con));
                copyfile(sprintf('%scon_%04i.hdr' ,dir_datgsm1,i_con),sprintf('%scon_sub%02i_con%02i.hdr' ,dir_datgsm2,i_sub,i_con));
                copyfile(sprintf('%scon_%04i.img' ,dir_datgsm1,i_con),sprintf('%scon_sub%02i_con%02i.img' ,dir_datgsm2,i_sub,i_con));
            end
        end
    end
    
    %% SECOND LEVEL
    function gsm_second_level()
        if ~do_scnd; return; end
        jobs = {};
        for i_con = 1:length(u_contrast)
            fprintf('gsm second level for: contrast "%s"\n',u_contrast{i_con}.name);
            dir_datgsm2 = sprintf('%scon_%s/',dir_datgsm2s,u_contrast{i_con}.name);
            % design
            job = struct();
            job.spm.stats.factorial_design.dir                      = {dir_datgsm2};
            job.spm.stats.factorial_design.des.t1.scans             = cellstr(spm_select('FPlist', dir_datgsm2, '^spmT_.*\.img$'));
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
            job.spm.stats.fmri_est.spmmat           = {[dir_datgsm2,'SPM.mat']};
            job.spm.stats.fmri_est.method.Classical = 1;
            jobs{end+1} = job;
            % contrast
            job = struct();
            job.spm.stats.con.spmmat                    = {[dir_datgsm2,'SPM.mat']};
            job.spm.stats.con.consess{1}.tcon.name      = u_contrast{i_con}.name;
            job.spm.stats.con.consess{1}.tcon.convec    = 1; % contrast vector, here just 1, (simple T)
            job.spm.stats.con.consess{1}.tcon.sessrep   = 'none';
            job.spm.stats.con.delete = 1;
            jobs{end+1} = job;
        end
        spm_jobman('run',jobs);
    end
    
end
