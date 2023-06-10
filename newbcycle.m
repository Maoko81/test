
clc
clear all
close all

f = fred;
startdate = '1995-01-01';
enddate = '2022-01-01';


%%
realGDP_JPN = fetch(f,'JPNRGDPEXP',startdate,enddate);      %Real Gross Domestic Product
JPN = realGDP_JPN.Data(:,2);

realGDP_ESP = fetch(f,'CLVMNACSCAB1GQES',startdate,enddate);      %Real Gross Domestic Product
year = realGDP_ESP.Data(:,1);
ESP = realGDP_ESP.Data(:,2);
% load y.mat
% year = linspace(1, 261, 261);


%[trend, cycle] = hpfilter(log(y), 1600);
[cycle_JPN, trend_JPN] = qmacro_hpfilter(log(JPN), 1600);

% compute sd(y) (from detrended series)
ysd1 = std(cycle_JPN)*100;

disp(['Percent standard deviation of detrended log real GDP for Japan: ', num2str(ysd1),'.']); disp(' ')


%[trend, cycle] = hpfilter(log(y), 1600);
[cycle_ESP, trend_ESP] = qmacro_hpfilter(log(ESP), 1600);

% compute sd(y) (from detrended series)
ysd2 = std(cycle_ESP)*100;
corryc = corrcoef(cycle_JPN,cycle_ESP);corryc = corryc(1,2);
disp(['Percent standard deviation of detrended log real GDP for Spain: ', num2str(ysd2),'.']); disp(' ')
disp(['Contemporaneous correlation between detrended log real GDP in Japan and Spain: ', num2str(corryc),'.'])

dates = 1995.1/4:2022.1/4; 
figure
title('Detrended log(real GDP) 1955Q1-2022Q1'); hold on
plot(year, cycle_JPN,'b', year, cycle_ESP,'r')
datetick('x', 'yyyy-qq')
legend("JPN","ESP")

function [ytilde,tauGDP] = qmacro_hpfilter(y, lam)

T = size(y,1);

% Hodrick-Prescott filter
A = zeros(T,T);

% unusual rows
A(1,1)= lam+1; A(1,2)= -2*lam; A(1,3)= lam;
A(2,1)= -2*lam; A(2,2)= 5*lam+1; A(2,3)= -4*lam; A(2,4)= lam;

A(T-1,T)= -2*lam; A(T-1,T-1)= 5*lam+1; A(T-1,T-2)= -4*lam; A(T-1,T-3)= lam;
A(T,T)= lam+1; A(T,T-1)= -2*lam; A(T,T-2)= lam;

% generic rows
for i=3:T-2
    A(i,i-2) = lam; A(i,i-1) = -4*lam; A(i,i) = 6*lam+1;
    A(i,i+1) = -4*lam; A(i,i+2) = lam;
end

tauGDP = A\y;

% detrended GDP
ytilde = y-tauGDP;

end

