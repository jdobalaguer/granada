function con = tools_getcontrast(stair,acc)
    % values
    x_con = unique(stair.vb_c);
    x_acc = nan(size(x_con));
    for i_con = 1:length(x_con)
        ii_con       = ( stair.vb_c == x_con(i_con) );
        x_acc(i_con) = mean(stair.resp_cor(ii_con));
    end
    % functions
    f_con = @(p,acc) -log(2*(1 - acc))/p(2) + p(1);
    f_acc = @(p,con) (con<=p(1)) .* 0.5 + (con>p(1)) .* (1 - .5*exp(-p(2)*(con-p(1))));
    % fitting
    p = nlinfit(x_con,x_acc,f_acc,[0,1]);
    % return
    con = f_con(p,acc);
    if con<0
        error('tools_getcontrast: error. con<0');
    end
end