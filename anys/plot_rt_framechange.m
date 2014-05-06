
%% warnings
%#ok<*ASGLU>

%% frame change
function plot_rt_framechange()
    
    n = 4;
    x = (1-n:n);
    
    % load
    alldata = load_fixed();
    
    % get frame change
    ii_change = (alldata.vb_distance  == 1) & ...
                (alldata.vb_condition == 1) & ...
                (~alldata.exp_first) & (~alldata.exp_last);
    f_change  = find(ii_change)';
    f_prepos  = repmat(f_change,1,2*n) + repmat(x,length(f_change),1);
    
    % get RT
    y = 1000 * alldata.resp_rt(f_prepos) - 550;
    m = meeze(y);
    e = steeze(y);
    
    % plot
    fig_figure();
    fig_barweb( m,e,[],{''},[],'trial to change','reaction time (ms)',...                                ylabel
                fig_color(200,2*n)./255,[],num2leg(x),[],'axis');
    
    % figure
    sa = struct();
    sa.ylim       = [550,850] - 550;
    sa.ytick      = (500:100:900) - 550;
    sa.yticklabel = num2leg(sa.ytick + 550);
    fig_axis(sa);
    fig_fontname(gcf(),'Arial');
    fig_fontsize(gcf(),20);
    fig_figure(gcf());
    
    % stats
    t1 = y(:,n+1);
    t0 = y(:,n);
    %t1 = meeze(reshape(t1,[4,8]));
    %t0 = meeze(reshape(t0,[4,8]));
    jb_ttest(t1-t0);
end

%% meeze
function varargout = meeze(varargin)
    varargout{:} = squeeze(nanmean(varargin{:}));
end

%% steeze
function varargout = steeze(varargin)
    varargout{:} = squeeze(nanste(varargin{:}));
end

%% jb_ttest
function jb_ttest(x)
    [h,p,ci,stats] = ttest(x);
    fprintf('t(%d) = %.2f, p = %.3f \n',stats.df,stats.tstat,p);
end