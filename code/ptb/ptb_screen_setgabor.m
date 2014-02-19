
function [gabortex,gaboreng,gaboreno,gaborrct] = ptb_screen_setgabor(parameters,ptb,blockstruct)
    %% init
    gabortex = nan(1,blockstruct.nb_trials);
    gaboreng = nan(1,blockstruct.nb_trials);
    gaboreno = nan(1,blockstruct.nb_trials);
    gaborrct = zeros(1,4);
    if parameters.flag_virtual; return; end
    
    %% shapes
    gaborrct = CenterRectOnPoint([0,0,parameters.screen_gabor_size,parameters.screen_gabor_size],ptb.screen_center(1),ptb.screen_center(2));
    alpha = tools_val_createcircularaperture(parameters.screen_gabor_size,parameters.screen_aperture);
    
    %% for
    for i_gabor = 1:blockstruct.nb_trials
        % variables
        phase = rand;

        % shapes
        noise = tools_val_createdsmoothednoise(parameters.screen_gabor_size,parameters.screen_gabor_noisekerneldev,parameters.screen_gabor_noisedev*2*parameters.screen_gabor_lumibg);
        gabor = tools_val_creategabor(parameters.screen_gabor_size,parameters.screen_gabor_envelopedev,90 + blockstruct.vb_ycat(i_gabor)*parameters.pars_yangle*180/pi,parameters.screen_gabor_frequency,phase,blockstruct.vb_c(i_gabor)*2*parameters.screen_gabor_lumibg);
        gabor = min(max(parameters.screen_gabor_lumibg+gabor+noise,0),1);
        patch = gabor .* alpha + parameters.screen_gabor_lumibg .* (1-alpha);

        % textures
        gabortex(i_gabor) = Screen('MakeTexture',ptb.screen_w,cat(3,gabor,alpha),[],[],2);

        % energy
        gaboreng(i_gabor) = tools_val_getfilterenergy(patch,parameters.screen_gabor_envelopedev,90 + blockstruct.vb_ycat(i_gabor)*parameters.pars_yangle*180/pi,parameters.screen_gabor_frequency,parameters.screen_aperture);
        gaboreno(i_gabor) = tools_val_getfilterenergy(patch,parameters.screen_gabor_envelopedev,90 - blockstruct.vb_ycat(i_gabor)*parameters.pars_yangle*180/pi,parameters.screen_gabor_frequency,parameters.screen_aperture);
    end
end
