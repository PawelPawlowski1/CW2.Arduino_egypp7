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

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Part A, no actual code- picture of setup

%%  Task 2 Part b:


% Temperature Monitoring, part b is a flowchart showing the logic of the
% function

%%  Task 2 Part C:

clear
clear a;

a = arduino;
Time = 0;

%function Therm_Monitor

while true
      Time = Time + 1; % Measures elapsed time (for graph)
    % Sets pin powering Thermistor to High 
    writeDigitalPin(a, 'D13',1);
   % Reads the temperature dependant voltage and displays it alongside the
   % indicated temperature
    Therm_Voltage = readVoltage(a,"A5");
   fprintf('The Voltage is : %.2f V\n',Therm_Voltage)
   Therm_Temperature = (Therm_Voltage - 0.5)/0.01;
   fprintf('The Temperature is %.2f C\n\n',Therm_Temperature)
   pause(1)

     % Part D of Task 2 integrated into Part C
 TemperatureData = Therm_Temperature;
Elapsed_Time = Time;

% plots temperature vs time on a live graph
plot(Elapsed_Time,TemperatureData,'rx')
hold on
xlabel("Elapsed Time (sec)")
ylabel("Cabin Temperature (° C)")
grid on
% Apply axis limits on y axis (to better visaulize the temperature change)
ylim([0,50])

if       (24>=Therm_Temperature) && (18<=Therm_Temperature )
        % Turns on Green LED (Temperature is within acceptable bounds)
        writeDigitalPin(a, 'D9',1);
         %Deactivates Amber or Red light (if previously on) (D10 is amber)
        writeDigitalPin(a, 'D10',0);
          writeDigitalPin(a, 'D11',0);

    elseif Therm_Temperature < 18
        % deactivates other lights (if they where on) and flashes amber
        % light (too cold)
        writeDigitalPin(a, 'D9',0);
         writeDigitalPin(a, 'D11',0);

          % makes Amber LED flash at 0.5 second intervals
          writeDigitalPin(a, 'D10',1);
          pause(0.5)
           writeDigitalPin(a, 'D10',0);
         
         
    elseif Therm_Temperature > 24
        %  % deactivates other lights (if they where on) and Rapidly
        %  Flashes Red light (too Hot)

          writeDigitalPin(a, 'D9',0);
           writeDigitalPin(a, 'D10',0);
          
           % Turns on red LED
          writeDigitalPin(a, 'D11',1);
          pause(0.25)
          writeDigitalPin(a, 'D11',0);
end
end

%% Task 2 part g:

% Would not allow to run next section if function wasnt disabled with %,
% remove % to use function

%function Doc_Temp_Control

 text = sprintf("The Function 'Temp_Monitor' records temperature data and plots it in real-time.\nA TO-92 Thermistor is used to collect the temperature data by reading the temperature dependant voltage\n" + ...
    "and using it to calculate the indicated cabin temperature, the data is stored and depending on its value 1 of 3 coloured LED's will activate,\nGreen if the temperature is within acceptable limits(18<=T<=24°C), Flashing Amber if it is too low(T<18°C)\n and rapidly flashing Red if it is too hot (T>24°C)\n" + ...
    "The function provides a visual representation of temperature variations over time, allowing users to monitor temperature trends and make informed decisions based on the data.\n\n");
disp(text);

%end

%% TASK 3 – ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

clear
clear a
a = arduino;
time = 0;

% To achieve this task, we need to calculate the rate of change of temperature over time, 
% which is the derivative of the temperature data

%function temp_prediction

clear a
a = arduino;
time = 0;

% Specify time program runs for (helps with calculating Change Rate)
while time < 1000

    time = time + 1;
    writeDigitalPin(a,'D13',1)
    Volt = readVoltage(a,"A5");
    temp(time) = (Volt - 0.5)/0.01;
    pause(1)
    
    % Starts calculating Change rate of temperature once there are atleast
    % 2 recorded data points
    if time > 2
        % Calculating Temperature Change
        ChangeR(time) = temp(time) - temp(time-1);
        % smoothing out sudden temperature spikes
        Smoothed_ChangeR = movmean(ChangeR,10);
        % Taking an average
        Avg_ChangeR = mean(Smoothed_ChangeR);

         % Displaying Temperature change rate
        fprintf('The Temperature is %.2f & The Average Temperature Rate of change is %.2f °C/sec\n',temp(time),Avg_ChangeR)

        pred_Temp = temp(time) + (Avg_ChangeR * 300);
        fprintf('The Temperature will be %.2f C in 5 minutes.\n\n',pred_Temp)
        pause(1)

        PerMin = (Avg_ChangeR * 60);
         
        % If TempR/min is greater than 4 Red light activates
        if PerMin > 4

            writeDigitalPin(a,'D10',0);
            writeDigitalPin(a,'D9',0);
            writeDigitalPin(a,'D11',1);

        elseif PerMin < -4
            % if TempR/min greater than -4 amber light shows

            writeDigitalPin(a,'D11',0);
            writeDigitalPin(a,'D9',0);
            writeDigitalPin(a,'D10',1);

        elseif  (24>= temp(time)) && (18<=temp(time))
           
            writeDigitalPin(a,'D9',1);
        end

    end
end

% Works but the equipment is very sensitive, fix ??

%% TASK 3 PART e:

function Doc_Temp_Prediction

 TEXT = sprintf(['The function "temp_prediction" Calculates the rate of change of temperature each second.\nIt then calculates a temperature prediction in the next 5 minutes\nbased on the rate of change ' ...
     'of temperature/sec.\n If the temperature is kept within a comfortable range between 18 deg C < temperature <24 deg C a constant green light will show.\n Alternatively if the rate of change of temperature/min is greater than\n+4deg C' ...
     ' a constant red light will show and if the rate of change of temperature/ min is less than -4deg/ min a constant amber light will show.\n\n ']);
disp(TEXT);

end

%%




