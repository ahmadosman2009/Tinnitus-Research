[mfA, fn] = getSGNFileName(pth, fst);

Res = cell(4, 1);

for Nmf = 7:7

    Res = cell(4, 1);

    mf = mfA(Nmf);
    fnmr = fullfile(pth, fn{2*Nmf-1});
    fnms = fullfile(pth, fn{2*Nmf});
    [Results, Strength, Amp, Phase] = testPhaseLockNo(fnmr, fnms, mf, Nmf);
    Res{1} = [Results(:, [2 5 6]), Strength, Amp, Phase];
    [Results, Strength, Amp, Phase] = testPhaseLockDetrend(fnmr, fnms, mf, Nmf);
    Res{2} = [Results(:, [2 5 6]), Strength, Amp, Phase];
end