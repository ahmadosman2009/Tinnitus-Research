function mLA = modulationLevelAdj(epa, depth, mf, Fs)

if epa == 1
    ep = 1;
else
    ep = 2.^(epa - 2);
end

tdur = round(2/mf*10*Fs);
t = (0:tdur-1)/Fs;

y = 2*depth*(((1+sin(2*pi*mf*t))/2).^ep-0.5)+1;

if epa == 1
    y = (y-1);
    y(y<0) = 0;
    y = (2*y + (1-depth));
end

mLA = 1./get_RMS(y, 0); 