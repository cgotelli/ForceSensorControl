function [bedloadTable, aggTable]= getBedload(Path, plotSedRate, ...
    plotCumSed, originaldt, lag)
% GETBEDLOAD
% This function reads a file and returns two timetables: the raw table with
% the default dt (10 seconds), and other with a frequency defined by the
% user. The columns in these tables include the instantaneous bedload rate,
% the measured weight transformed from voltage values, and the delta of
% weight from one measurement to the next.

inputTable = readtimetable(Path);
if any("ExtraVar1" == string(inputTable.Properties.VariableNames))
    inputTable = removevars(inputTable,"ExtraVar1");
end

values = inputTable.Value.*26.718-3.7752; % Conversion to kilograms
values = values*1000; % Conversion to grams
inputTable = addvars(inputTable,values,'NewVariableNames','Weight'); % New column with weight in kg
inputTable = addvars(inputTable,values-values(1),'NewVariableNames', 'CumBedload'); % New column with the accumulated weight gained since the beggining.
inputTable = addvars(inputTable,inputTable.CumBedload,'NewVariableNames','GlobalCumBedload'); % Variable for stocking global cumulative bed load transport.

% % Second table with different dt
aggTable = inputTable(1:lag:end,:); % take one value each "lag" delta t
% aggTable = retime(aggTable,'regular', 'spline','SampleRate',1/newdt); % Interpolation routine (not used anymore).

% Adding new columns for bedload rates.
% We start computing bed load rates first for the full time resolution table.
bedloadVar = diff(inputTable.Weight); % We compute the instant variation [kg]
bedloadTable = addvars(inputTable,[0;bedloadVar],'NewVariableNames',...
    'deltaBedload');
bedloadTable = addvars(bedloadTable, bedloadTable.deltaBedload./originaldt,...
    'NewVariableNames','BedloadRate');
bedloadVar(bedloadVar(:)<0) = 0; % We remove negative variations and make them zero
bedloadTable = addvars(bedloadTable,[0;bedloadVar],'NewVariableNames',...
    'PositiveDeltaBedload'); % New column
bedloadTable = addvars(bedloadTable,bedloadTable.PositiveDeltaBedload./originaldt,...
    'NewVariableNames','PositiveBedloadRate');
bedloadTable = addvars(bedloadTable, time(between(bedloadTable.Time(1),...
    bedloadTable.Time(:))),'NewVariableNames','dt');


% Now for the new table with different dt.
bedloadVar = diff(aggTable.Weight); % We compute the instant variation [V]
aggTable = addvars(aggTable,[0;bedloadVar],'NewVariableNames','deltaBedload');
aggTable = addvars(aggTable,aggTable.deltaBedload./lag,...
    'NewVariableNames','BedloadRate');

bedloadVar(bedloadVar(:)<0) = 0; % We remove negative variations
aggTable = addvars(aggTable,[0;bedloadVar],'NewVariableNames',...
    'PositiveDeltaBedload');
aggTable = addvars(aggTable,aggTable.PositiveDeltaBedload./lag,...
    'NewVariableNames','PositiveBedloadRate');
aggTable = addvars(aggTable, time(between(aggTable.Time(1),...
    aggTable.Time(:))),'NewVariableNames','dt');


% Plotting
if plotSedRate
    figure()
    plot(aggTable.Time,aggTable.PositiveBedloadRate, ...
        DisplayName=strcat("Bedload Rate Agg at ",num2str(lag), "s"))
    title(Path(end-11:end))
    xlabel("Time [hh:mm]")
    ylabel("Bedload rate [g/s]")
end

if plotCumSed
    figure()
    plot(aggTable.Time,aggTable.CumBedload, ...
        DisplayName=strcat("Bedload Rate Agg at ",num2str(lag), "s"))
    title(Path(end-11:end))
    xlabel("Time [hh:mm]")
    ylabel("Accumulated Bedload")

end
end
