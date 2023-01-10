function [bedloadTable, bedloadTableAgg]= getBedload(Path, plotBoth)
%GETBEDLOAD
%
%

inputTable = readtimetable(Path);
values = inputTable.Value.*26.647-4.9557;
values = values*1000;
inputTable = addvars(inputTable,values,'NewVariableNames','Weight');
inputTable = addvars(inputTable,values-values(1),'NewVariableNames','CumBedload');
bedloadVar = diff(inputTable.Value); % We compute the instant variation [V]
bedloadVar = bedloadVar.*26.647; % We transform the variation to Kg [Kg]
bedloadVar = bedloadVar.*1000; % Then to grams. [g]
bedloadTable = addvars(inputTable,[0;bedloadVar],'NewVariableNames','deltaBedload');

bedloadVar(bedloadVar(:)<0) = 0; % We remove negative variations
bedloadTable = addvars(bedloadTable,bedloadTable.deltaBedload./10,'NewVariableNames','BedloadRate');

bedloadTable = addvars(bedloadTable,[0;bedloadVar],'NewVariableNames','PositiveDeltaBedload');
bedloadTable = addvars(bedloadTable,bedloadTable.PositiveDeltaBedload./10,'NewVariableNames','PositiveBedloadRate');

% bedloadTable = addvars(bedloadTable,[movmean(bedloadTable.PositiveInstantBedload,6)],'NewVariableNames','MovmeanInstantBedload');

%bedloadTableAgg = retime(bedloadTable,'minutely','mean');

plot(bedloadTable.Time,bedloadTable.BedloadRate, DisplayName="Bedload Rate")
xlabel("Time [hh:mm]")
ylabel("Bedload rate [g/s]")
if plotBoth
    disp("Plotting both")
    hold on
    plot(bedloadTable.Time,bedloadTable.PositiveBedloadRate, DisplayName="Positive Bedload Rate")
    legend()
end
end
