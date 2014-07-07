
function data = ext_subjective(data, threshold)
    %% warnings
    %#ok<*AGROW>
    
    %% defaults
    if ~exist('threshold','var'), threshold = 1; end
    
    %% numbers
    u_sub = unique(data.exp_subject);
    n_sub = length(u_sub);

    %% general linear model
    for i_sub = 1:n_sub
        ii_sub      = (data.exp_subject == u_sub(i_sub));
        ii          = (ii_sub);
        X           = genreg(data,ii);
        B(i_sub,:)  = glmfit(X,data.resp_gamble(ii)','binomial','link','probit');
    end

    %% ttest
    if threshold < 1,   hs = ttest(B,0,'alpha',threshold);
    else                hs = ones(1,size(B,2));
    end

    %% reconstruct subjective value
    for i_sub = 1:n_sub
        ii_sub      = (data.exp_subject == u_sub(i_sub));
        ii          = (ii_sub);
        X           = genreg(data,ii);
        X           = [ones(size(X,1),1) , X];
        b           = hs .* B(i_sub,:);
%         Y(i_sub,:) = glmval(b',X,'probit');
        Y(i_sub,:) = b * X';
    end
    
    %% subjective value
    data.vb_sxv = mat2vec(Y')';
    
    %% subjective difficulty
    data.vb_sxh = abs(mat2vec(Y'))';
end

%% GENERATE REGRESSORS
function X = genreg(data,ii_sub)

        % useful stuff
        z_wins     = ztransf(data.vb_wins(ii_sub));
        z_loss     = ztransf(data.vb_loss(ii_sub));
        z_prob     = ztransf(data.vb_prob(ii_sub));
        
        % regressors
        X = [   ... main effects
                z_wins; ...
                z_loss; ...
                z_prob; ...
                ... interactions 2
                z_wins.*z_prob; ...
                z_loss.*z_prob; ...
            ]';
end
