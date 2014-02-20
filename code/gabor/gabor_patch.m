
function patch = gabor_patch(parameters,contrast,angle)
    % [patch] = gabor_patch(parameters,sign)
    
    %% create gabor
    gabor = tools_rescale(gabor_gabor(  ...
        parameters.gabor_size,          ... size
        parameters.gabor_envelopedev,   ... envelope dev 
        angle,                          ... angle
        parameters.gabor_frequency,     ... frequency
        parameters.gabor_phase,         ... phase
        contrast                        ... contrast
        ));
    
    %% create noise
    noise  = tools_rescale(gabor_noise( ...
        parameters.gabor_size,          ... size
        parameters.gabor_envelopedev,   ... envelope dev 
        parameters.gabor_noisekerneldev,... noise kernel dev
        parameters.gabor_noisedev       ... noise dev
        ));
    
    %% create patch
    patch = 200 * tools_rescale(gabor + noise);
    patch = patch - patch(1,1) + mean(parameters.screen_bg_color);
    
end