function [h, pValue, stat] =  PPtest(series)
% Phillips-Perron (PP) test
[h, pValue, stat] = pptest(series);
disp(['PP test statistic: ', num2str(stat)]);
disp(['p-value: ', num2str(pValue)]);
if h == 0
    disp('The time series is stationary');
else
    disp('The time series is non-stationary');
end
end