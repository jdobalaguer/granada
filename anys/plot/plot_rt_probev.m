
function plot_rt_probev()
    %% load data
    data = load_data_ext('scanner');
    data.vb_wev = data.vb_exv + data.vb_std;
    data.vb_lev = data.vb_exv - data.vb_std;

    %% discretize
    %data.vb_exv = jb_precision(data.vb_exv,1);
    data.vb_exv = jb_discretize(jb_precision(data.vb_exv,1),5);
    %data.vb_exv = jb_discretize(jb_precision(data.vb_wev,1),3);

    data.vb_dsd = jb_discretize(data.vb_std,3);
    %data.vb_dsd = jb_discretize(data.vb_distance,7);

    %% numbers
    u_sub = unique(data.exp_subject);
    n_sub = length(u_sub);

    u_exv = unique(data.vb_exv);
    n_exv = length(u_exv);

    u_dsd = unique(data.vb_dsd);
    n_dsd = length(u_dsd);

    %% values
    %prob = jb_getvector(data.resp_gamble , data.exp_subject , data.vb_exv, data.vb_dsd);
    prob = nan(n_sub,n_exv,n_dsd);
    for i_sub = 1:n_sub
        for i_exv = 1:n_exv
            for i_dsd = 1:n_dsd
                ii_sub = (data.exp_subject == u_sub(i_sub));
                ii_exv = (data.vb_exv      == u_exv(i_exv));
                ii_dsd = (data.vb_dsd      == u_dsd(i_dsd));
                prob(i_sub,i_exv,i_dsd) = nanmean(data.resp_gamble(ii_sub & ii_exv & ii_dsd));
            end
        end
    end

    %% plot
    fig_figure();
    hold on;

    for i_dsd = 1:n_dsd

        m_exv = nanmean(prob(:,:,i_dsd));
        e_exv = nanste( prob(:,:,i_dsd));

        subplot(1,n_dsd,i_dsd);
        fig_barweb(m_exv,e_exv,[],[],[],[],[],[],[],num2leg(u_exv),[],'axis');
        %fig_plot(u_exv,m_exv,e_exv);

        sa.ylim = [0,1];
        fig_axis(sa);
    end
end
    