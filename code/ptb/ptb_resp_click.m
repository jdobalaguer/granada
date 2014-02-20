
% initialise
kdown = 0;

% press
while ~kdown
    kdown = KbCheck();
end

% release
while kdown
    kdown = KbCheck();
end

clear kdown;