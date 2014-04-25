
%% set performance levels
u_contrast  = unique(data.vb_contrast);
nb_contrast = length(u_contrast);
performance = nan(1,nb_contrast);
for i_contrast = 1:nb_contrast
    performance(i_contrast) = mean(data.resp_correct(data.vb_contrast == u_contrast(i_contrast)));
end

%% fit psychophysical curve
f_acc = @(p,con) (con<=p(1)) .* 0.5 + (con>p(1)) .* (1 - .5*exp(-p(2)*(con-p(1))));
f_con = @(p,acc) -log(2*(1 - acc))/p(2) + p(1);

p = nlinfit(u_contrast,performance,f_acc,[0,1/mean(u_contrast)]);

figure();

subplot(1,2,1);
hold on;
plot(u_contrast,performance,'+r');
t = linspace(0,max(u_contrast),100);
y = f_acc(p,t);
plot(t,y,'+b');
xlim([0,u_contrast(end)]);
ylim([0,1]);

subplot(1,2,2);
hold on;
plot(performance,u_contrast,'+r');
y(y==0.5) = [];
t = f_con(p,y);
plot(y,t,'+b');
xlim([0,1]);
ylim([0,u_contrast(end)]);

%% print levels
parameters.results = [];
for i = 1:length(parameters.stair_performance)
    parameters.results(i) = f_con(p,parameters.stair_performance(i));
    fprintf('contrast(%.2f) = %.4f\n',parameters.stair_performance(i),parameters.results(i));
end

%% clean
data_clear;