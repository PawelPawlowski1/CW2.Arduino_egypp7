%% Pawel J Pawlowski
% egypp7@nottingham.ac.uk

%% Preliminary Task

clear
clear a

a = arduino;

%Blinker Code

for n = 1:60

    writeDigitalPin(a,'D13',1);
    writeDigitalPin(a,'D13',0);
    pause(1)
   
end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MAR

% Part a:

%Thermistor input voltage pin connected to D13, sets D13 to high turning
%thermistor on
writeDigitalPin(a, 'D13',1);
% reads the temperature dependant voltage
Thermistor_Voltage = readVoltage(a,"A5");

%Converts the voltage into the corresponding temperature and prints onto
%screen
Corresponding_Temperature = (Thermistor_Voltage - 0.5)/0.01;

fprintf('The Temperature is %.2f °C\n',Corresponding_Temperature)

%% part b:

clear
clear a

a = arduino;

% Define duration of recording
duration = 600; % in seconds

% Initialize arrays to store acquired data
time = zeros(1, duration); % Time array
voltage = zeros(1, duration); % Voltage array

% Temperature sensor characteristics
TC = 0.01; % Temperature coefficient
V0_C = 0.5; % Voltage at 0 degrees Celsius

% Simulate reading voltage values from the temperature sensor every 1 second for 10 minutes
for t = 1:duration

    writeDigitalPin(a, 'D13',1);
   
    % Read voltage at analog channel
    voltage(t) = readVoltage(a, "A5");

    time(t) = t;
    
    pause(1);
end

% Convert voltage values to temperature values
temperature = (voltage - V0_C) / TC;

% Record Points pf interest
minimum_temp = min(temperature);
maximum_temp = max(temperature);
average_temp = mean(temperature);

% Display results
fprintf('Minimum temperature: %.2f °C\n', minimum_temp)
fprintf('Maximum temperature: %.2f °C\n', maximum_temp)
fprintf('Average temperature: %.2f °C\n', average_temp)

%%  Task 1 Part c :

% Plot temperature versus time
plot(time, temperature, 'b');
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Temperature vs. Time');

%% Task 1 part d :

% Extract data for each minute
increment = 60;
num_sets = numel(temperature) / increment;
extracted_data = cell(1, num_sets);

for i = 1:num_sets
    start_index = (i - 1) * increment + 1;
    end_index = i * increment;
    extracted_data{i} = temperature(start_index:end_index);
end

% Calculate the mean value for each minute
mean_values = zeros(1, num_sets);
for i = 1:num_sets
    mean_values(i) = mean(extracted_data{i});
end

% Creating loop to print Average temperature for each minute

set =[1 2 3 4 5 6 7 8 9 10];
for i = 1:length(mean_values)
   
    fprintf('Minute\t\t%d\nTemperature\t%.2f C\n\n',set(i),mean_values(i))
end


% printing max, min and mean values onto screen

fprintf('Max Temperature\t%.2f C\nMin Temperature\t%.2f C\nAverage Temperature\t%.2f C\n\nData Logging Terminated',maximum_temp,minimum_temp,average_temp);

%% Task 1 Part e:

% write data to file

fopen('Cabin_Temperature.txt','w');
fileID = fopen('Cabin_Temperature.txt','w');

% print the text data to screen
set =[1 2 3 4 5 6 7 8 9 10];
for i = 1:length(mean_values)
   
    fprintf(fileID,'Minute\t\t%d\nTemperature\t%.2f C\n\n',set(i),mean_values(i));
end

fprintf(fileID,'Max Temperature\t%.2f C\nMin Temperature\t%.2f C\nAverage Temperature\t%.2f C\n\nData Logging Terminated',maximum_temp,minimum_temp,average_temp);

% Close the file
fclose(fileID);



