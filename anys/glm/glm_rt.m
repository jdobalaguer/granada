%{
    based on chris' analysis
%}

%% clean
%clc;
clear all;

%% load data
data = load_ext3('scanner');
data.vb_wev = data.vb_exv + data.vb_std;
data.vb_lev = data.vb_exv - data.vb_std;

%% numbers
u_sub = unique(data.exp_subject);
n_sub = length(u_sub);

%% GLM
for i_sub = 1:n_sub
    %% index
    ii_sub     = (data.exp_subject == u_sub(i_sub));
    
    %% useful stuff
    z_exv      = ztransf(data.vb_exv(ii_sub));
    z_wins     = ztransf(data.vb_wins(ii_sub));
    z_loss     = ztransf(-data.vb_loss(ii_sub));
    z_prob     = ztransf(data.vb_prob(ii_sub));
    z_std      = ztransf(data.vb_std(ii_sub));
    z_session  = ztransf(1./data.exp_session(ii_sub));
    z_frame    = ztransf(1./data.vb_frame(ii_sub));
    z_distance = ztransf(1./data.vb_distance(ii_sub));
    z_distoend = ztransf(1./data.vb_distoend(ii_sub));
    z_valast1  = ztransf(data.resp_valast1(ii_sub));
    z_galast1  = ztransf(data.resp_galast1(ii_sub));
    z_valcum   = ztransf(data.resp_valcum(ii_sub));

    [B(i_sub,:), DEV(i_sub), STATS(i_sub)] = glmfit([   ...
                            ... main effects
                            z_wins; ...
                            z_loss; ...
                            ... modifiers
                            z_prob; ...
                            z_valcum; ...
                            z_valast1; ...
                            z_galast1; ...
                            z_std; ...
                            z_distance; ...
                            ... interactions (prob)
                            z_wins.*z_prob; ...
                            z_loss.*z_prob; ...
                            ... interactions (valcum)
                            z_wins.*z_valcum; ...
                            z_loss.*z_valcum; ...
                            ... interactions (std)
                            z_wins.*z_std; ...
                            z_loss.*z_std; ...
                            z_exv .*z_std; ...
                            ... interactions (distance)
                            z_wins.*z_distance; ...
                            z_loss.*z_distance; ...
                            z_exv .*z_distance; ...
                            ... other
                            z_std.*z_valcum; ...
                        ]', ...
                        data.resp_gamble(ii_sub)');
end

%% plot

% figure
fig_figure();

y = mean(B);
e = ste( B);
l = {   'K',                        ... constant
        'X','N',                    ... main effects
        'P','W',                    ... modifiers
        'O1',                       ...
        'G1',                       ...
        'S','U',                    ...
        'X*P','N*P',                ... interactions (prob)
        'X*W','N*W',                ... interactions (valcum)
        'X*S','N*S','E*S',          ... interactions (std)
        'X*U','N*U','E*U',          ... interactions (distance)
        'S*W',                      ... others
    };
c = fig_color('jet',length(l))./255;

web = fig_barweb(   y,e,...             height and error
                    0.8,...             width
                    {''},...            group names
                    [],...              title
                    'regressors',...    xlabel
                    'beta value',...    ylabel
                    c,...               colour
                    'y',...             grid
                    l,...               legend
                    1,...              error sides (1, 2)
                    'axis'...           legend ('plot','axis')
                    );
% fig_axis
sa = struct();
sa.title   = 'GLM( RT )';
sa.ytick   =  -0.2:+0.2:+0.8;
sa.ylim    = [-0.2,+0.8];
fig_axis(sa);

% font and size
%fig_fontname(gcf(),'Arial');
fig_fontsize(gcf(),20);

%% ttest
for i_reg = 1:size(B,2)
    text = sprintf('ttest(%s) : ',l{i_reg});
    text(end+1:20) = ' ';
    if ttest(B(:,i_reg)) cprintf([1,0,0],text);
    else                 fprintf(text);
    end
    jb_ttest(B(:,i_reg));
end

%% assert
if size(B,2) ~= length(l)
    fprintf('\n');
    cprintf([1,0.5,0],'wrong legend\n');
    fprintf('\n');
end
