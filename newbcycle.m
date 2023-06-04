
clc
clear all
close all


f = fred
startdate = '01/01/1955';
enddate = '01/01/2022';


%%
realGDP1 = fetch(f,'JPNRGDPEXP',startdate,enddate)      %Real Gross Domestic Product
year1 = realGDP1.Data(:,1);
y1 = realGDP1.Data(:,2);

% load y.mat
% year = linspace(1, 261, 261);

figure
plot(year1, log(y1))
datetick('x', 'yyyy')
ylabel('Log of real GDP (billions of chained 2012 dollars)')
xlabel('')
grid on

%[trend, cycle] = hpfilter(log(y), 1600);
[cycle1, trend1] = qmacro_hpfilter(log(y1), 1600);

% compute sd(y) (from detrended series)
ysd1 = std(cycle1)*100;

disp(['Percent standard deviation of detrended log real GDP: ', num2str(ysd1),'.']); disp(' ')

figure
subplot(2,1,1);
plot(year1, trend1,'b')
datetick('x', 'yyyy')
xlabel('Time')
title('Trend components')
grid on

subplot(2,1,2);
plot(year1, cycle1,'r')
datetick('x', 'yyyy')
xlabel('Time')
title('Cyclical components')
grid on;

realGDP2 = fetch(f,'CLVMNACSCAB1GQES',startdate,enddate)      %Real Gross Domestic Product
year2 = realGDP2.Data(:,1);
y2 = realGDP2.Data(:,2);

% load y.mat
% year = linspace(1, 261, 261);

figure
plot(year2, log(y2))
datetick('x', 'yyyy')
ylabel('Log of real GDP (billions of chained 2012 dollars)')
xlabel('')
grid on

%[trend, cycle] = hpfilter(log(y), 1600);
[cycle2, trend2] = qmacro_hpfilter(log(y2), 1600);

% compute sd(y) (from detrended series)
ysd2 = std(cycle2)*100;

disp(['Percent standard deviation of detrended log real GDP: ', num2str(ysd2),'.']); disp(' ')

figure
subplot(2,1,1);
plot(year2, trend2,'b')
datetick('x', 'yyyy')
xlabel('Time')
title('Trend components')
grid on

subplot(2,1,2);
plot(year2, cycle2,'r')
datetick('x', 'yyyy')
xlabel('Time')
title('Cyclical components')
grid on;

figure
plot(year1, cycle1,year2, cycle2,'b')
datetick('x', 'yyyy')
xlabel('Time')
title('Trend components')
grid on
