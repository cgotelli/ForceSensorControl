function [bedloadTable, aggTable]= getBedload(Path, plotBoth, dt)
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
inputTable = addvars(inputTable,values-values(1),'NewVariableNames','CumBedload');

% Second table with different dt
aggTable = inputTable;
aggTable = retime(aggTable,'regular', 'spline','SampleRate',1/dt); 

% Adding new columns for bedload rates. 
% First in the original table.
bedloadVar = diff(inputTable.Weight); % We compute the instant variation [V]
bedloadTable = addvars(inputTable,[0;bedloadVar],'NewVariableNames','deltaBedload');
bedloadTable = addvars(bedloadTable,bedloadTable.deltaBedload./10,'NewVariableNames','BedloadRate');

bedloadVar(bedloadVar(:)<0) = 0; % We remove negative variations
bedloadTable = addvars(bedloadTable,[0;bedloadVar],'NewVariableNames','PositiveDeltaBedload');
bedloadTable = addvars(bedloadTable,bedloadTable.PositiveDeltaBedload./10,'NewVariableNames','PositiveBedloadRate');



% Now for the new table with different dt.
bedloadVar = diff(aggTable.Weight); % We compute the instant variation [V]
aggTable = addvars(aggTable,[0;bedloadVar],'NewVariableNames','deltaBedload');
aggTable = addvars(aggTable,aggTable.deltaBedload./dt,'NewVariableNames','BedloadRate');

bedloadVar(bedloadVar(:)<0) = 0; % We remove negative variations
aggTable = addvars(aggTable,[0;bedloadVar],'NewVariableNames','PositiveDeltaBedload');
aggTable = addvars(aggTable,aggTable.PositiveDeltaBedload./dt,'NewVariableNames','PositiveBedloadRate');


% Plotting
plot(bedloadTable.Time,bedloadTable.BedloadRate, DisplayName="Bedload Rate Original")
xlabel("Time [hh:mm]")
ylabel("Bedload rate [g/s]")
if plotBoth
    disp("Plotting both")
    hold on
    plot(aggTable.Time,aggTable.BedloadRate, DisplayName=strcat("Bedload Rate Agg at ",num2str(dt), "s"))
    legend()
end
end
