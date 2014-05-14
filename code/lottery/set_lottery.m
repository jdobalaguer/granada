if parameters.flag_debug, return; end
if index.escape, return; end

%% set bonus
added = 0;
total = 0;
for i_session = 1:parameters.task_nbsessions
    % load
    loaded = load(sprintf('data%sdata%sdata_%03i_%d.mat', filesep,filesep,index.subject,i_session),'data');
    ddata   = loaded.data;
    f_diff = RandSel(find(ddata.vb_left~=ddata.vb_right & ~isnan(ddata.resp_category) ), parameters.lott_samples);
    % add up
    added = added + sum(ddata.resp_dots(f_diff));
    total = total + sum(ddata.vb_max(f_diff));
end
bonus = parameters.task_bonus .* added ./ total;
data = ddata;

%% clean
clear added total;
clear loaded ddata;
clear i_session;
clear f_diff;
