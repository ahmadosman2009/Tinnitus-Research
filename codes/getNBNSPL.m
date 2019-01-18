function PA = getNBNSPL(NBNcfL, NBNcfR, CALfreq, CALpower, CALnsadj)

PA = zeros(size(NBNcfL));

for mmm = 1:length(NBNcfL)
    [p, q1] = min(abs(CALfreq - NBNcfL(mmm)));
    [p, q2] = min(abs(CALfreq - NBNcfR(mmm)));
    PA(mmm) = 10*log10(sum(CALpower(q1:q2))) + CALnsadj;
end
