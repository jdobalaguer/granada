
%% Create patch
patch  = gabor_patch(   parameters,                                         ... parameters
                        parameters.gabor_contrast(trialstruct.vb_contrast), ... contrast
                        trialstruct.vb_angle                                ... angle
                    );

%% Draw patch
Screen('PutImage',ptb.screen_w,patch);