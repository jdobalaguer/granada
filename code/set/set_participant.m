
%% participant info
disp('Participant')
participant = struct();

if ~parameters.flag_debug
    participant.age  = input('  Age:      ','s');
    participant.sex  = input('  Sex:      ','s');
    participant.hand = input('  Hand:     ','s');
else
    participant.age  = '';
    participant.sex  = '';
    participant.hand = '';
end

%% experiment info
disp('Experiment')
participant.id = str2double(input('  Id: ','s'));
while isnan(participant.id)
    participant.id = str2double(input('  Id (introduce a valid number): ','s'));
end
