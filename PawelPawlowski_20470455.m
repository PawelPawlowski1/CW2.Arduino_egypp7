%% Pawel J Pawlowski
% egypp7@nottingham.ac.uk

%% Preliminary Task

clear
clear a

a = arduino;

%Blinker Code

while true

    writeDigitalPin(a,'D13',1);
    writeDigitalPin(a,'D13',0);
    pause(1)
   
end

%%
