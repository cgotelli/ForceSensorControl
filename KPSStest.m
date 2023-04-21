function [h, pValue, stat] = KPSStest(series)
% Generate a non-stationary time series


% Kwiatkowski-Phillips-Schmidt-Shin (KPSS) test
[h, pValue, stat] = kpsstest(series);
disp(['KPSS test statistic: ', num2str(stat)]);
disp(['p-value: ', num2str(pValue)]);
if h == 0
    disp('The time series is stationary');
else
    disp('The time series is non-stationary');
end
end 