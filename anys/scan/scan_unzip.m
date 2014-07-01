
function scan_unzip()
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
    
    % VARIABLES
    nb_subjects = size(dir_subs, 1); 
    u_subject   = 1:nb_subjects;
    
    %% JOBS
    zip_epi3_img();

    %% CLEAN FILES
    
    % image (epi3)
    function zip_epi3_img()
        for i_sub = u_subject
            dir_epi3 = strtrim(dir_epis3(i_sub,:));
            dir_runs    = dir([strtrim(dir_epis3(i_sub,:)),'run*']); dir_runs = strcat(strvcat(dir_runs.name),'/');
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
