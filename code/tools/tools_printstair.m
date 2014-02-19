
accs = [.5 : .1 : 1];

%% plot staircase
% stair values
u_con = unique(stair.vb_c);
u_acc = nan(size(u_con));
for i_con = 1:length(u_con)
    ii_con       = ( stair.vb_c == u_con(i_con) );
    u_acc(i_con) = mean(stair.resp_cor(ii_con));
end
% plot values
x_con = 0:0.01:1;
x_acc = 0.5:0.01:1;
% functions
f_con = @(p,acc) -log(2*(1 - acc))/p(2) + p(1);
f_acc = @(p,con) (con<=p(1)) .* 0.5 + (con>p(1)) .* (1 - .5*exp(-p(2)*(con-p(1))));

p = nlinfit(u_con,u_acc,f_acc,[0,1])

figure;

subplot(1,2,1);
hold on;
plot(u_con,u_acc,'+r');
plot(x_con,f_acc(p,x_con));
%xlim([ 0,1]);
ylim([.5,1]);

subplot(1,2,2);
hold on;
plot(u_acc,u_con,'+r');
plot(x_acc,f_con(p,x_acc));
xlim([.5,1]);
%ylim([ 0,1]);

for i_accs = 1:length(accs)
    fprintf('tools_printstair: contrast(accuracy = %.2f) = %.4f\n',accs(i_accs),f_con(p,accs(i_accs)));
end
