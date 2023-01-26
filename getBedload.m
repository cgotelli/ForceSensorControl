function [bedloadTable, aggTable]= getBedload(Path, plotSedRate, ...
    plotCumSed, plotBoth, originaldt, newdt)
% GETBEDLOAD
% This function reads a file and returns two timetables: the raw table with
% the default dt (10 seconds), and other with a frequency defined by the
% user. The columns in these tables include the instantaneous bedload rate,
% the measured weight transformed from voltage values, and the delta of
% weight from one measurement to the next.

inputTable = readtimetable(Path);
values = inputTable.Value.*26.649-4.9605;
values = values*1000;
inputTable = addvars(inputTable,values,'NewVariableNames','Weight');
inputTable = addvars(inputTable,values-values(1),'NewVariableNames',...
    'CumBedload');

% Second table with different dt
aggTable = inputTable;
aggTable = retime(aggTable,'regular', 'spline','SampleRate',1/newdt);

% Adding new columns for bedload rates.
% First in the original table.
bedloadVar = diff(inputTable.Weight); % We compute the instant variation [V]
bedloadTable = addvars(inputTable,[0;bedloadVar],'NewVariableNames',...
    'deltaBedload');
bedloadTable = addvars(bedloadTable,bedloadTable.deltaBedload./originaldt,...
    'NewVariableNames','BedloadRate');

bedloadVar(bedloadVar(:)<0) = 0; % We remove negative variations
bedloadTable = addvars(bedloadTable,[0;bedloadVar],'NewVariableNames',...
    'PositiveDeltaBedload');
bedloadTable = addvars(bedloadTable,bedloadTable.PositiveDeltaBedload./originaldt,...
    'NewVariableNames','PositiveBedloadRate');
bedloadTable = addvars(bedloadTable, time(between(bedloadTable.Time(1),...
    bedloadTable.Time(:))),'NewVariableNames','dt');


% Now for the new table with different dt.
bedloadVar = diff(aggTable.Weight); % We compute the instant variation [V]
aggTable = addvars(aggTable,[0;bedloadVar],'NewVariableNames','deltaBedload');
aggTable = addvars(aggTable,aggTable.deltaBedload./newdt,...
    'NewVariableNames','BedloadRate');

bedloadVar(bedloadVar(:)<0) = 0; % We remove negative variations
aggTable = addvars(aggTable,[0;bedloadVar],'NewVariableNames',...
    'PositiveDeltaBedload');
aggTable = addvars(aggTable,aggTable.PositiveDeltaBedload./newdt,...
    'NewVariableNames','PositiveBedloadRate');
aggTable = addvars(aggTable, time(between(aggTable.Time(1),...
    aggTable.Time(:))),'NewVariableNames','dt');


% Plotting
if plotSedRate
    figure()
    plot(bedloadTable.Time,bedloadTable.BedloadRate,...
        DisplayName="Bedload Rate Original")
    title(Path(end-11:end))
    xlabel("Time [hh:mm]")
    ylabel("Bedload rate [g/s]")
    if plotBoth
        disp("Plotting both")
        hold on
        plot(aggTable.Time,aggTable.BedloadRate, ...
            DisplayName=strcat("Bedload Rate Agg at ",num2str(newdt), "s"))
        legend()
    end
end

if plotCumSed
    figure()
    plot(datetime("today")+bedloadTable.dt,bedloadTable.CumBedload,...
        DisplayName="Bedload Rate Original")
    title(Path(end-11:end))
    xlabel("Time [hh:mm]")
    ylabel("Accumulated Bedload")
    if plotBoth
        disp("Plotting both")
        hold on
        plot(datetime("today")+aggTable.dt,aggTable.CumBedload, ...
            DisplayName=strcat("Bedload Rate Agg at ",num2str(newdt), "s"))
        legend()
    end

end
end
