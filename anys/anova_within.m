
function anova_within()
    alldata = load_data();
    values  = jb_getvector(alldata.resp_rt , alldata.exp_subject , alldata.vb_condition , alldata.resp_correct , alldata.resp_angle);
    jb_anova(values , {'"RT"' , '"cond"' , '"cor"' , '"cho"'});
end
    