function [h, pValue, stat] = ADFtest(timeSeries)

% Augmented Dickey-Fuller (ADF) test
[h, pValue, stat] = adftest(timeSeries);

disp(['ADF test statistic: ', num2str(stat)]);
disp(['p-value: ', num2str(pValue)]);
if h == 0
    disp('The time series is non-stationary');
else
    disp('The time series is stationary');
end
end