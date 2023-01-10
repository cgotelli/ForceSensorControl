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
bedloadTable = addvars(inputTable,[0;bedloadVar],'NewVariableNames','InstantBedload');
bedloadVar(bedloadVar(:)<0) = 0; % We remove negative variations
bedloadTable = addvars(bedloadTable,[0;bedloadVar],'NewVariableNames','PositiveInstantBedload');
% bedloadTable = addvars(bedloadTable,[movmean(bedloadTable.PositiveInstantBedload,6)],'NewVariableNames','MovmeanInstantBedload');


bedloadTableAgg = retime(bedloadTable,'minutely','mean');

plot(bedloadTable.Time,bedloadTable.InstantBedload, DisplayName="Instantaneous")
if plotBoth
    disp("Plotting both")
    hold on
    plot(bedloadTable.Time,bedloadTable.PositiveInstantBedload, DisplayName="Positive")
%     plot(bedloadTable.Time,bedloadTable.MovmeanInstantBedload, DisplayName= "Positive + movmean Minute")
    plot(bedloadTableAgg.Time,bedloadTableAgg.PositiveInstantBedload, DisplayName="Agg by minute")
    legend()
end
end
