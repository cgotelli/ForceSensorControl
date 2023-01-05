% 19.12.2022
% Clemente Gotelli
% 
% This script gets the voltage input from a force sensor connected to a 
% National Instruments (TM) USB-6001 DAQ USB Device and registers it to a
% Logfile. It gives the option of showing the evolution in time.
%
% Last edited by C. Gotelli (January, 2023)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      EXECUTE THIS SECTION FIRST                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Time window for compute mean and register in text file.
twindow = 10;
drate = 1000;
SavePath = "C:\Users\admin\Desktop"; % Where to save the LogFiles.
% Decide if plotting or not data in real time.
plotting = true;

%%%%%%%%%%%%%%%%%%% DO NOT MODIFY FROM THIS POINT DOWN %%%%%%%%%%%%%%%%%%%%

% Reset workspace
close all
daqreset
imaqreset

% Initiation of Data Acquisition device.
d = daq("ni");
addinput(d,"Dev1","ai0","Voltage");
% Acquisition rate from sensor.
d.Rate=drate;
%#ok<*AGROW>

% Empty variables for plotting.
Dev1_data = [];
plot_time = [];
n = ceil(d.Rate);

% Gets the initial date and time
c = clock; 
% We creat the Logfile with date and time in the name
fid = fopen(fullfile(SavePath, strcat('LogFileForceSensor_', ...
    sprintf('%d',c(1)), sprintf('%02.0f',c(2)), sprintf('%02.0f',c(3)), ...
    sprintf('%02.0f',c(4)), sprintf('%02.0f',c(5)), '.txt')), 'a');
fprintf(fid,'%s %s', "Time", "Value"); % Writes the file's heading

% We start the measurement process.
start(d,"continuous")

% We register the mean value in the file with the exact moment on which it
% was measured.
while true 
    data = read(d,n*twindow);
    data_mean = mean(data.Dev1_ai0);
    
    %     disp(strcat("",num2str(data.height)))
    c = clock;

    % Write to file the time and registered discharge value
    fprintf(fid, '\n%s %02.5f ',  strcat(sprintf('%d',c(1)),...
        sprintf('%02.0f',c(2)), sprintf('%02.0f',c(3)), ...
        sprintf('%02.0f',c(4)), sprintf('%02.0f',c(5)), ...
        sprintf('%02.0f',c(6))), data_mean);

    % Plotting the data in real time along with the mean value in the
    % window
    if plotting

        plot_time = [plot_time; data.Time];
        Dev1_data = [Dev1_data; data];
        plot(data.Time, data.Dev1_ai0) % Plot time series
        hold on
        plot(data.Time, ones(length(data.Time),1)*mean(data.Dev1_ai0),...
            "Color","black") % Plot mean value as straight line

        % Plot settings
        xlim([0 max(data.Time)])
        xlabel("Time (s)")
        ylabel("Amplitude")
        legend(data.Properties.VariableNames)
    end
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           EXECUTE THIS SECTION SECOND (AFTER PRESSING CTRL + C)         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stop(d)

% Once it goes out of the loop it closes the file
disp('Closing LogFile')
% Makes the closure of the LogFile.
fclose(fid);

% Clean Up
% Clear all DataAcquisition and channel objects.
clear d
