function ticks = autoTickMarks(Min,Max)
% Compute sensibly spaced tickmarks from Min to Max
%
% Written by Ludger Starke; Max Delbrück Center for Molecular Medicine in
% the Helmholtz Association, Berlin; 19-06-13
%
% License: GNU GPLv3 


diff = Max - Min;

Sign = sign(log10(diff));

if Sign == 1
    order = floor(log10(diff));
elseif Sign == -1
    order = -ceil(abs(log10(diff)));
elseif Sign == 0
    order = 0;
end

tempDiff = diff*10^(-order);


if tempDiff < 1
    tickSep = 0.1;
elseif tempDiff < 2
    tickSep = 0.2;
elseif tempDiff < 2.5
    tickSep = 0.25;
elseif tempDiff < 5
    tickSep = 0.5;
else
    tickSep = 1;
end

tickSep = tickSep*10^order;
ticks = Min:tickSep:Max;









