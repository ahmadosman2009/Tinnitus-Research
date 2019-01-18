[mfA, fn] = getSGNFileName(pth, fst)

Res = cell(4, 1);

for Nmf = 2:2

    Res = cell(4, 1);

    mf = mfA(Nmf);
    fnmr = fullfile(pth, fn{2*Nmf-1});
    fnms = fullfile(pth, fn{2*Nmf});
    [Results, Strength, Amp, Phase] = testPhaseLockNo(fnmr, fnms, mf, Nmf);
    Res{1} = Results(:, [2 5 6]);
    [Results, Strength, Amp, Phase] = testPhaseLockDetrend(fnmr, fnms, mf, Nmf+20);
    Res{2} = Results(:, [2 5 6]);
    
    tmp = [Res{1}, Res{2}]
end