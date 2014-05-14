
if isnan(trialstruct.resp_category)
    trialstruct.resp_correct = 0;
    plot_beep;
    plot_verbose_resp;
end
