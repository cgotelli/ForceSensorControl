% This code processes at the same time all the Logfiles that are stored in
% one folder. Then, it computes the sediment transport rate at the
% specified frequency and builds a time series for the experiment
% represented by these files. 
% It plots the time series of sediment transport rates and accumulated 
% transport for the entire experiment. 
% Optional: Allows you to plot the time series of sediment transport rates 
% and accumulated transport for each file. 

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             PARAMETERS                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filesPath = "C:\Users\admin\Documents\GitHub\ForceSensorControl\logfiles"; % Where the Logfiles are stored

plotSedRate = false;         % Plot sediment rate timeseries for each file
plotCumSed = false;          % Plot accumulated sediment timeseries for each file
plotBoth = false;            % Plot the smoothed series in addition to the original
originalTimeWindow = 1;     % What is the frequency at which the data was written in the logfile
lag = 60;                   % The frequency at which the smoothness will be performed


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   DO NOT MODIFY FROM THIS POINT DOWN                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filenames = dir(fullfile(filesPath, '*.txt')); % List of logfiles to process
allBLTable = [];    % Empty output table
allAggTable = [];   % Empty output table

for i=1:length(filenames)
    % Create ensembled timetable and plot individual plots for each serie
    [bedloadTable, aggTable] = getBedload(fullfile(filenames(i).folder, ...
        filenames(i).name(1:end-4)), plotSedRate, plotCumSed, ...
        plotBoth, originalTimeWindow, lag);

    if i==1 % The first one is copied intact
        allBLTable = [allBLTable; bedloadTable];
        allAggTable = [allAggTable; aggTable];
    else    % For the rest we modify the time to make it a continuous time serie
        bedloadTable.dt = bedloadTable.dt+allBLTable.dt(end)+ ...
            seconds(originalTimeWindow);
        aggTable.dt = aggTable.dt+allAggTable.dt(end)+ ...
            seconds(lag);

        allBLTable = [allBLTable; bedloadTable];
        allAggTable = [allAggTable; aggTable];
    end
end

%% 
% Plotting the resulting complete time series for the experiment
% Bed load rate
figure()
area(allAggTable.Time(1)+allAggTable.dt, allAggTable.PositiveBedloadRate,...
        DisplayName=strcat("Bedload Rate each ",num2str(lag),...
        "s"), FaceColor="#77AC30",EdgeColor="none", FaceAlpha=0.5)

hold on 
% plot(datetime("today")+allBLTable.dt, zeros(height(allBLTable),1).*...
%     mean(allAggTable.PositiveBedloadRate),...
%         'k--', DisplayName='Zero')
plot(allAggTable.Time(1)+allAggTable.dt, ones(height(allAggTable),1)*...
    mean(allAggTable.PositiveBedloadRate),'r-', ...
    DisplayName='Mean sample each 1 min')
plot(allAggTable.Time(1)+allAggTable.dt, ones(height(allAggTable),1)*...
    (allBLTable.CumBedload(end)-allBLTable.CumBedload(1))/...
    length(allBLTable.PositiveBedloadRate),...
        'k--', DisplayName='Mean 1st and last values')
xlabel("Time [hh:mm]")
ylabel("Bedload rate [g/s]")
legend(Location="northwest")


%% Accumulated bed load
figure()
plot(allBLTable.Time(1)+allBLTable.dt, allBLTable.CumBedload, ...
    DisplayName="All values")
hold on
plot(allBLTable.Time(1)+allBLTable.dt(1:60:end), ...
    allBLTable.CumBedload(1:60:end), ...
    DisplayName="1 each 60s")

xlabel("Time [hh:mm]")
ylabel("Accumulated Bedload")
legend(Location="northwest")

save("timeSeries.mat","allBLTable","allAggTable");