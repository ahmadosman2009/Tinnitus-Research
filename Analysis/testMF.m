clc
pth = 'C:\AMFR\data\16-104';

Fs = 24414.0625*4/20;
% 
% mf = 42.9;
% mf = 171.6;
% mf = 432.4;
mf = 343.2;

fn = filen(pth, '*43*01A*.sgn');
fnmr = fullfile(pth, '16-104MT5MF17-432HzMS3_CT2CF22E01CBW2_LV50_screw_16-05AREF.sgn');
% fnms = fullfile(pth, fn{6});
fnms = fullfile(pth, '16-104MT5MF17-432HzMS3_CT2CF22E01CBW2_LV50_screw_16-05ARSP.sgn');

refa = PreadDAT(fnmr);
rspa = PreadDAT(fnms);

if mf > 40
    cyc = round(250/1000*mf);
else
    cyc = 10;
end

smp = round(Fs*20/mf*cyc);
Dsmp = round(smp/20);

Nsmp = floor(length(refa)/Dsmp);

[b, a] = butter(2, mf*[2.^(-1/2), 2.^(1/2)]/(Fs/2));

% rspa = filter(b, a, rspa);

refCP = reshape(refa, Dsmp, Nsmp);
rspCP = reshape(rspa, Dsmp, Nsmp);

Ssmp = round(Dsmp/cyc);
Hsmp = floor(Ssmp/2);

sumrefF = zeros(size(refCP(:, 1)));
sumrspF = zeros(size(sumCF));
sumrefCF = zeros(size(sumCF));
sumrspCF = zeros(size(sumCF));

zi = zeros(max(length(b), length(a))-1, 1);

for mmm = 1:Nsmp
    tmpref = refCP(1:Ssmp, mmm);
    [mx, mp] = max(tmpref);
    
    tmprefF = (refCP(:, mmm));
    [tmprspF, zi] = filter(b, a, (rspCP(:, mmm)), zi);
    sumrefCF = sumrefCF + tmprefF;
    sumrspCF = sumrspCF + tmprspF;
    
    if mp > Hsmp
        MvP = mp - Hsmp;
        tmprefR = tmprefF;
        tmprspR = tmprspF;
        tmprefR(1:end-MvP) = tmprefF(MvP+1:end);
        tmprefR(end-MvP+1:end) = tmprefF(1:MvP);
        tmprspR(1:end-MvP) = tmprspF(MvP+1:end);
        tmprspR(end-MvP+1:end) = tmprspF(1:MvP);
    elseif mp < Hsmp
        MvP = Hsmp - mp;
        tmprefR = tmprefF;
        tmprspR = tmprspF;
        tmprefR(MvP+1:end) = tmprefF(1:end-MvP);
        tmprefR(1:MvP) = tmprefF(end-MvP+1:end);
        tmprspR(MvP+1:end) = tmprspF(1:end-MvP);
        tmprspR(1:MvP) = tmprspF(end-MvP+1:end);
    else
        tmprefR = tmprefF;
        tmprspR = tmprspF;
    end
    
    sumrefF = tmprefR + sumrefF;
    sumrspF = tmprspR + sumrspF;
    
    figure(6), plot(tmprefR), hold on;
    figure(7), plot(tmprefF), hold on;
    figure(3), plot(tmprspR), hold on;
    figure(2), plot(tmprspF), hold on;
end
figure(6), hold off;
figure(7), hold off;
figure(2), hold off;
figure(3), hold off;

figure(4)
for nnn = 1:8
    subplot(2, 4, nnn);
    cr = rand(1, 3);
    plot(rspCP(:, nnn), 'color', cr);
end

figure(8), plot([sumrefF/500, sumrspF])
figure(9), plot([sumrefCF/500, sumrspCF])
