function PA = getToneSPL(Tonecf, CALfreq, CALpower, CALtoneadj)

PA = zeros(size(Tonecf));

for mmm = 1:length(Tonecf)
    [p, toneP] = min(abs(CALfreq - Tonecf(mmm)));
    PA(mmm) = 10*log10(CALpower(toneP)) + CALtoneadj;
end