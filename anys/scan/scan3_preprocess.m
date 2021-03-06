
function scan3_preprocess()
    fprintf('\ndont forget to check results of each processing step!\n\n')
    
    %% WARNINGS
    %#ok<*AGROW>
    %#ok<*DEFNU>
    %#ok<*FPARK>
    %#ok<*NBRAK>

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_spm                     = [fileparts(which('spm.m')),filesep];
    dir_study                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_subs                    = dir([dir_study,'sub_*']); dir_subs = strcat(dir_study,strvcat(dir_subs.name),'/');
    dir_strs                    = strcat(dir_subs,'str',filesep);
    dir_epis3                   = strcat(dir_subs,'epi3',filesep);
    file_T1                     = [dir_spm,'templates/T1.nii,1'];
    
    % PARAMETERS
    pars_nslices = 32;
    pars_tr      = 2;
    pars_refsl   = ceil(.5*pars_nslices);
    pars_ordsl   = [pars_nslices:-1:+1];
    pars_reft0   = (find(pars_ordsl==pars_refsl)-1) * (pars_tr/pars_nslices);
    pars_voxs    = 4;
    
    % VARIABLES
    nb_subjects = size(dir_subs, 1); 
    u_subject   = set_subjects();
    
    %% JOBS
    tic();
    spm_jobman('initcfg');
    despike();                      % despike
    despike_move();                 % despike           (move)
%     image_compression();            % image             (compression)
    slicetiming();                  % slice timing
    slicetiming_move();             % slice timing      (move)
%     despike_compression();          % despike           (compression)
    realignment_unwarp();           % realignment
    realignment_move();             % realignment       (move)
%     slice_timing_compression();     % slice timing      (compression)
    coregistration_str_meanepi()    % coregistration    (anatomical T1 to mean EPI)
    normalisation_str_mni();        % normalisation     (anatomical T1 to MNI template)
    normalisation_epi_mni();        % normalisation     (EPI to MNI template)
    normalisation_move();           % normalisation     (move files)
%     realignment_compression();      % realignment       (compression)
    smoothing();                    % smoothing
    smoothing_move();               % smoothing         (move files)
%     normalisation_compression();    % normalisation     (compression)
    toc();
    
    %% SET SUBJECTS
    function u_subject = set_subjects()
        u_subject = nan(1,nb_subjects);
        for i_sub = 1:nb_subjects
            dir_sub = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Checking for:                    %s\n',dir_sub);
            this_done = 1;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_smt = strcat(dir_run,'smooth',filesep);
                if ~exist(dir_smt,'dir') || isempty(dir(sprintf('%ssw%duagimages*.nii',dir_smt,pars_voxs)))
                    this_done = 0;
                end
            end
            u_subject(i_sub) = ~this_done;
        end
        u_subject = find(u_subject);
    end

    %% SPIKE CORRECTION
    function despike()
        prefix = '';
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),filesep);
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Spike correction for:            %s\n',dir_sub);
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                dir_spc = strcat(dir_run,'spikes',filesep);
                if ~exist(dir_spc,'dir') || isempty(dir([dir_spc,'g',prefix,'images*.nii']))
                    spm_select('clearvfiles');
                    run_images = spm_select('List', dir_img, '^images.*\.nii$');
                    filenames   = strcat(dir_img,run_images);
                    art_slice(filenames);
                end
            end
       end
    end

    %% SPIKE CORRECTION: Move files
    function despike_move()
        prefix = '';
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),filesep);
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Spike move files for:            %s\n',dir_sub);
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                dir_spc = strcat(dir_run,'spikes',filesep);
                mkdirp(dir_spc);
                if ~isempty(dir([dir_img,'g',prefix,'image*'])),    movefile([dir_img,'g',prefix,'image*'],dir_spc);    end
                if ~isempty(dir([dir_img,'ArtifactMask.nii'] )),    movefile([dir_img,'ArtifactMask.nii' ],dir_spc);    end
                if ~isempty(dir([dir_img,'BadSliceLog*.txt'] )),    movefile([dir_img,'BadSliceLog*.txt' ],dir_spc);    end
            end
       end
    end
    
    %% IMAGE: Compression
    function image_compression()
        scan_zip(1,'nii3img');
    end

    %% SLICE TIMING
    function slicetiming()
        prefix = 'g';
        jobs = {};
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),filesep);
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Slice-Timing for:                %s\n',dir_sub);
            job = struct();
            job.spm.temporal.st.nslices = pars_nslices;
            job.spm.temporal.st.tr = pars_tr;
            job.spm.temporal.st.ta = pars_tr - (pars_tr/pars_nslices);
            job.spm.temporal.st.so = pars_ordsl;
            job.spm.temporal.st.refslice = pars_refsl;
            job.spm.temporal.st.prefix = 'a';
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                dir_spc = strcat(dir_run,'spikes',filesep);
                dir_stc = strcat(dir_run,'slicetime',filesep);
                if ~exist(dir_stc,'dir') || isempty(dir([dir_stc,'a',prefix,'images*.nii']))
                    spm_select('clearvfiles');
                    raw_func_filenames{i_run} = spm_select('List', dir_img, '^images.*\.nii$');
                    filenames_for_st{i_run}   = strcat(dir_spc,prefix,raw_func_filenames{i_run});
                    job.spm.temporal.st.scans{i_run} = cellstr(filenames_for_st{i_run});
                end
            end
            if isfield(job.spm.temporal.st,'scans'); jobs{end+1} = job; end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs;
    end

    %% SLICE TIMING: Move files
    function slicetiming_move()
        prefix = 'g';
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),filesep);
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Slice timing move files for:     %s\n',dir_sub);
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_spc = strcat(dir_run,'spikes',filesep);
                dir_stc = strcat(dir_run,'slicetime',filesep);
                mkdirp(dir_spc);
                if ~isempty(dir([dir_spc,'a',prefix,'image*'])),    movefile([dir_spc,'a',prefix,'image*'],dir_stc);    end
            end
       end
    end
    
    %% SPIKE CORRECTION: Compression
    function despike_compression()
        scan_zip(1,'nii3spc');
    end

    %% REALIGN : UNWARP
    function realignment_unwarp()
        prefix = 'ag';
        jobs = {};
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Realign and Unwarp for:          %s\n',dir_sub);
            job = struct();
            job.spm.spatial.realignunwarp.eoptions.quality = 0.9;  % Quality (Default: 0.9)
            job.spm.spatial.realignunwarp.eoptions.sep = 4;        % Separation (Default: 4) 
            job.spm.spatial.realignunwarp.eoptions.fwhm = 5;       % Smoothing (FWHM) (Default: 5)
            job.spm.spatial.realignunwarp.eoptions.rtm = 0;        % Num Passes (Default: Register to mean) 
            job.spm.spatial.realignunwarp.eoptions.einterp = 2;     % Interpolation (Default: 2nd Degree B-Spline)
            job.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0]; % Wrapping (Default: No wrap) 
            job.spm.spatial.realignunwarp.eoptions.weight = '' ;   % Weighting (Default: None) (vorher {} )
            job.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];  % Resliced Images ([0 1] > Only Mean Image; Default: [2 1] > All Images + Mean Image) 
            job.spm.spatial.realignunwarp.uwroptions.rinterp = 4;     % Interpolation (Default: 4th Degree B-Spline) 
            job.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0]; % Wrapping (Default: No wrap) 
            job.spm.spatial.realignunwarp.uwroptions.mask = 1;       % Masking (Default: Mask images)
            job.spm.spatial.realignunwarp.uwroptions.prefix = 'u';   % Realigned files prefix
            job.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
            job.spm.spatial.realignunwarp.uweoptions.regorder = 1;
            job.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
            job.spm.spatial.realignunwarp.uweoptions.jm = 0;
            job.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
            job.spm.spatial.realignunwarp.uweoptions.sot = [];
            job.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
            job.spm.spatial.realignunwarp.uweoptions.rem = 1;
            job.spm.spatial.realignunwarp.uweoptions.noi = 5;
            job.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                dir_stc = strcat(dir_run,'slicetime',filesep);
                dir_rea = strcat(dir_run,'realignment',filesep);
                if ~exist(dir_rea,'dir') || isempty(dir([dir_rea,'u',prefix,'images*.nii']))
                    spm_select('clearvfiles');
                    raw_func_filenames{i_run}    = spm_select('List', dir_img, '^images.*\.nii$');
                    filenames_for_realign{i_run} = strcat(dir_stc,prefix,raw_func_filenames{i_run}); 
                    job.spm.spatial.realignunwarp.data(i_run).scans = cellstr(filenames_for_realign{i_run});
                    job.spm.spatial.realignunwarp.data(i_run).pmscan = [];
                end
            end
            if isfield(job.spm.spatial.realignunwarp,'data'); jobs{end+1} = job; end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs;
    end
    
    %% REALIGNMENT: Move files
    function realignment_move()
        prefix = 'ag';
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Realign move files for:          %s\n',dir_sub);
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_stc = strcat(dir_run,'slicetime',filesep);
                dir_rea = strcat(dir_run,'realignment',filesep);
                mkdirp(dir_rea);
                if ~isempty(dir([dir_stc,'u',prefix,'image*'])),    movefile([dir_stc,'u',prefix,'image*'],dir_rea);   end
                if ~isempty(dir([dir_stc,'*.txt'])),                movefile([dir_stc,'*.txt'],dir_rea); end
                if ~isempty(dir([dir_stc,'*.mat'])),                movefile([dir_stc,'*.mat'],dir_rea); end
                if ~isempty(dir([dir_stc,'mean*'])),                movefile([dir_stc,'mean*'],dir_rea); end
            end
        end
    end
    
    %% SLICE TIMING: Compression
    function slice_timing_compression()
        scan_zip(1,'nii3stc');
    end

    %% COREGISTRATION: Anatomical T1 to mean EPI
    function coregistration_str_meanepi()
        prefix = 'uag';
        jobs = {};
        for i_sub = u_subject
            dir_sub   = strtrim(dir_subs(i_sub,:));
            dir_epi3  = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            dir_run   = strcat(dir_epi3,strtrim(dir_runs(1,:)));
            dir_rea   = strcat(dir_run,'realignment',filesep);
            file_mean = dir(strcat(dir_rea,'mean',prefix,'images*'));
            dir_str   = strtrim(dir_strs(i_sub,:));
            file_str  = dir(strcat(dir_str,'images*'));
            fprintf('Coregistration for:              %s\n',dir_sub);
            if isempty(dir([dir_str,'cimages*']))
                job = struct();
                copyfile([dir_str,file_str.name],[dir_str,'c',file_str.name]);
                job.spm.spatial.coreg.estimate.ref    = {[dir_rea,file_mean.name,',1']};
                job.spm.spatial.coreg.estimate.source = {[dir_str,'c',file_str.name,',1']};
                job.spm.spatial.coreg.estimate.other  =  {''};
                job.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
                job.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
                job.spm.spatial.coreg.estimate.eoptions.tol = [0.0200 0.0200 0.0200 0.0010 0.0010 0.0010 0.0100 0.0100 0.0100 0.0010 0.0010 0.0010];
                job.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
                jobs{end+1} = job;
            end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs;
    end

    %% NORMALISATION (Estimate and Write for Anatomical T1)
    function normalisation_str_mni()
        prefix = 'c';
        jobs = {};
        for i_sub = u_subject
            dir_sub = strtrim(dir_subs(i_sub,:));
            dir_str   = strtrim(dir_strs(i_sub,:));
            file_str  = dir(strcat(dir_str,prefix,'images*.nii'));
            fprintf('Normalise Anatomy for:           %s\n',dir_sub);
            if isempty(dir([dir_str,sprintf('w%d%simages*',pars_voxs,prefix)]))
                job = struct();
                job.spm.spatial.normalise.estwrite.subj.source = {[dir_str,file_str.name]};% Image to estimate warping parameters: HIGHRES
                job.spm.spatial.normalise.estwrite.subj.wtsrc = {};        % Source Weighting Image: None
                job.spm.spatial.normalise.estwrite.subj.resample = {[dir_str,file_str.name]};% Images to write according to warping parameters: HIGHRES 
                job.spm.spatial.normalise.estwrite.eoptions.template = {file_T1};% Template Image
                job.spm.spatial.normalise.estwrite.eoptions.weight = {};   % Template Weighting Imaging, Default: None
                job.spm.spatial.normalise.estwrite.eoptions.smosrc = 8;    % Source Image Smoothing, Default: 8
                job.spm.spatial.normalise.estwrite.eoptions.smoref = 0;    % Template Image Smoothing, Default: 0
                job.spm.spatial.normalise.estwrite.eoptions.regtype = 'mni'; % Affine Regularisation, Default: ICBM/MNI Space Template
                job.spm.spatial.normalise.estwrite.eoptions.cutoff = 25;   % Nonlinear Frequency Cutoff, Default: 25
                job.spm.spatial.normalise.estwrite.eoptions.nits = 16;     % Nonlinear Iterations, Default: 16
                job.spm.spatial.normalise.estwrite.eoptions.reg = 1;       % Nonlinear Regularisation, Default: 1
                job.spm.spatial.normalise.estwrite.roptions.preserve = 0;  % Default: 0 = Preserve Concentrations
                job.spm.spatial.normalise.estwrite.roptions.bb = [-78 -112 -70;78 76 85]; % Bounding Box
                job.spm.spatial.normalise.estwrite.roptions.vox = [pars_voxs pars_voxs pars_voxs]; % Voxel Sizes [2 2 2] is default
                job.spm.spatial.normalise.estwrite.roptions.interp = 1;    % Interpolation (Default: 1)
                job.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];% Wrapping, 0: No
                job.spm.spatial.normalise.estwrite.roptions.prefix = sprintf('w%d',pars_voxs); % Prefix
                jobs{end+1} = job;
            end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs;
    end

    %% NORMALISATION (Write EPIs)
    function normalisation_epi_mni()
        prefix_epi = 'uag';
        prefix_str = 'c';
        jobs = {};
        for i_sub = u_subject
            dir_sub = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_str   = strtrim(dir_strs(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Writing normalized epis for:     %s\n',dir_sub);
            param_for_normalise_file = dir([dir_str,prefix_str,'*_sn.mat']);
            job = struct();
            job.spm.spatial.normalise.write.roptions.preserve = 0;
            job.spm.spatial.normalise.write.roptions.bb = [-78 -112 -50; 78 76 85];
            job.spm.spatial.normalise.write.roptions.vox = [pars_voxs pars_voxs pars_voxs];
            job.spm.spatial.normalise.write.roptions.interp = 1;
            job.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
            job.spm.spatial.normalise.write.roptions.prefix = sprintf('w%d',pars_voxs);
            filenames_for_normalise = {};
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                dir_rea = strcat(dir_run,'realignment',filesep);
                dir_nor = strcat(dir_run,'normalisation',filesep);
                if ~exist(dir_nor,'dir') || isempty(dir([dir_nor,sprintf('w%d',pars_voxs),prefix_epi,'images*.nii']))
                    spm_select('clearvfiles');
                    raw_func_filenames{i_run} = spm_select('List', dir_img, '^images.*\.nii$');
                    filenames_for_normalise{end+1} = strcat(dir_rea,prefix_epi,raw_func_filenames{i_run});
                end
            end
            if ~isempty(filenames_for_normalise)
                job.spm.spatial.normalise.write.subj.resample = cellstr(strvcat(filenames_for_normalise));
                job.spm.spatial.normalise.write.subj.matname = {[dir_str,param_for_normalise_file.name]};
                jobs{end+1} = job;
            end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs;
    end
        
    %% NORMALISATION (Move files)
    function normalisation_move()
        prefix = 'uag';
        for i_sub = u_subject
            dir_sub  = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Normalisation move files for:    %s\n',dir_sub);
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_rea = strcat(dir_run,'realignment',filesep);
                dir_nor = strcat(dir_run,'normalisation',filesep);
                mkdirp(dir_nor);
                if ~isempty(dir([dir_rea,sprintf('w%d',pars_voxs),prefix,'image*'])),    movefile([dir_rea,sprintf('w%d',pars_voxs),prefix,'image*'],dir_nor);   end
            end
        end
    end

    %% REALIGN: Compression
    function realignment_compression()
        scan_zip(0,'nii3rea'); % dont delete it!
        scan_clean('nii3rea'); % delete nii images
    end

    %% SMOOTH
    function smoothing()
        prefix = sprintf('w%duag',pars_voxs);
        jobs = {};
        for i_sub = u_subject
            dir_sub = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Smoothing for:                   %s\n',dir_sub);
            job = struct();
            job.spm.spatial.smooth.fwhm = [8 8 8];
            job.spm.spatial.smooth.dtype = 0;
            job.spm.spatial.smooth.im = 0;
            job.spm.spatial.smooth.prefix = 's';
            filenames_for_smooth = {};
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                dir_nor = strcat(dir_run,'normalisation',filesep);
                dir_smt = strcat(dir_run,'smooth',filesep);
                if ~exist(dir_smt,'dir') || isempty(dir([dir_smt,'s',prefix,'images*.nii']))
                    spm_select('clearvfiles');
                    raw_func_filenames{i_run}    = spm_select('List', dir_img, '^images.*\.nii$');
                    filenames_for_smooth{end+1} = strcat(dir_nor,prefix,raw_func_filenames{i_run});
                end
            end
            if ~isempty(filenames_for_smooth)
                job.spm.spatial.smooth.data = cellstr(strvcat(filenames_for_smooth));
                jobs{end+1} = job;
            end
        end
        if ~isempty(jobs); spm_jobman('run',jobs); end
        clear job jobs;
    end

    %% SMOOTH: Move files
    function smoothing_move()
        prefix = sprintf('w%duag',pars_voxs);
        for i_sub = u_subject
            dir_sub = strtrim(dir_subs(i_sub,:));
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            fprintf('Smoothing move files for:        %s\n',dir_sub);
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_nor = strcat(dir_run,'normalisation',filesep);
                dir_smt = strcat(dir_run,'smooth',filesep);
                mkdirp(dir_smt);
                movefile([dir_nor,'s',prefix,'image*'],dir_smt);
            end
        end
    end
    
%% NORMALISATION: Compression
    function normalisation_compression()
        scan_zip(1,'nii3nor');
    end
end
