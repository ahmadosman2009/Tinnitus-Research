%testReadSGN
pth = 'C:\Tinnitus\Data';
fn = filen(pth, '*syu*-S*.sgn');

for mmm = 1:length(fn)
    fnm = fullfile(pth, fn{mmm});
    sig = PreadSGN(fnm);
    [mmm, std(sig(1:1e4))]
    subplot(3,2,mmm), plot(sig);
end