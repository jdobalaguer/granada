
function scan_unzip(varargin)
    %% WARNINGS
    %#ok<*DEFNU>

    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_dcm                   = [pwd(),filesep,'data',filesep,'dcm',filesep];
    dir_nii                   = [pwd(),filesep,'data',filesep,'nii',filesep];
    dir_subs                    = dir([dir_nii,'sub_*']); dir_subs = strcat(dir_nii,strvcat(dir_subs.name),'/');
    dir_strs                    = strcat(dir_subs,'str',filesep);
    dir_epis3                   = strcat(dir_subs,'epi3',filesep);
    dir_epis4                   = strcat(dir_subs,'epi4',filesep);
    
    %% JOBS
    for i_argin = 1:nargin
        switch varargin{i_argin}
            case 'dcm'
                unzip_dcm();
            case 'nii4'
                unzip_ep4();
            case 'nii3str'
                unzip_epi3_str();
            case 'nii3img'
                unzip_epi3_img();
            case 'nii3rea'
                unzip_epi3_rea();
            case 'nii3nor'
                unzip_epi3_nor();
            case 'nii3smt'
                unzip_epi3_smt();
        end
    end

    %% ZIP dcm
    function unzip_dcm()
        nb_subjects = size(dir_dcmsubs, 1); 
        u_subject   = 1:nb_subjects;
        for i_sub = u_subject
            dir_sub = dir_dcmsubs(i_sub,:);
            zip_sub = [dir_sub(1:end-1),'.zip'];
            unzip(zip_sub,dir_sub);
            delete(zip_sub);
        end
    end
    
    %% ZIP epi4
    function unzip_epi4()
        nb_subjects = size(dir_niisubs, 1); 
        u_subject   = 1:nb_subjects;
        for i_sub = u_subject
            dir_epi4 = strtrim(dir_niiepis4(i_sub,:));
            zip_epi4 = [dir_epi4(1:end-1),'.zip'];
            unzip(zip_epi4,dir_epi4);
            delete(zip_epi4);
        end
    end

    %% ZIP epi3image
    function unzip_epi3_img()
        nb_subjects = size(dir_niisubs, 1); 
        u_subject   = 1:nb_subjects;
        for i_sub = u_subject
            dir_epi3 = strtrim(dir_niiepis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_niiepis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
            nb_runs     = size(dir_runs, 1);
            u_run       = 1:nb_runs;
            for i_run = u_run
                dir_run = strcat(dir_epi3,strtrim(dir_runs(i_run,:)));
                dir_img = strcat(dir_run,'images',filesep);
                zip_img = strcat(dir_run,'images.zip');
                unzip(zip_img,dir_img);
                delete(zip_img);
            end
        end
    end
end
