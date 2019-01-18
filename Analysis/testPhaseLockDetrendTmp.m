function [Results, Strength, Amplitude, phaseD, cyc, Dsmp, Nsmp] = testPhaseLockDetrendTmp(Nmf, mfA, fst, pth)

if nargin < 1
    Nmf = 5;
end

pFig = 1;
pFig2 = 0;
pFig3 = 0;

if nargin < 2
    mfA = [85.8, 27, 171.6, 432.4, 343.2, 34.1, 21.5, 54.1, 108.1, 17, 136.2, 216.2, 42.9, 272.4, 68.1]';
end

if nargin < 3
%     fst = '16-104MT5MF17-432HzMS3_CT2CF22E01CBW2_LV50_screw_16-';
    fst = '16-105MT5MF17-545HzMS3_CT2CF24E01CBW2_LV70_screw_15-';
end
if nargin < 4
    pth = 'C:\AMFR\data\16-105';
end

Fs = 24414.0625*4/20;

mf = mfA(Nmf);

% fn = filen(pth, '*43*01A*.sgn');
% fnms = fullfile(pth, fn{6});

tmpstr = sprintf('%s%02dAREF.sgn', fst, Nmf);
fnmr = fullfile(pth, tmpstr);

tmpstr = sprintf('%s%02dARSP.sgn', fst, Nmf);
fnms = fullfile(pth, tmpstr);

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

NEpoch = 8;

[b, a] = butter(2, mf*[2.^(-1/2), 2.^(1/2)]/(Fs/2));
zi = zeros(max(length(b), length(a))-1, 1);

refCP = reshape(refa, Dsmp, Nsmp);
rspCP = reshape(rspa, Dsmp, Nsmp);

if cyc > 20
    Ssmp = round(Dsmp/cyc*2);
    Hsmp = floor(round(Ssmp/2)/2);
elseif cyc > 40
    Ssmp = round(Dsmp/cyc*4);
    Hsmp = floor(round(Ssmp/4)/2);
elseif cyc > 80
    Ssmp = round(Dsmp/cyc*8);
    Hsmp = floor(round(Ssmp/8)/2);
else
    Ssmp = round(Dsmp/cyc);
    Hsmp = floor(Ssmp/2);
end

sumref2 = zeros(Dsmp*NEpoch, 1);
sumrsp2 = zeros(Dsmp*NEpoch, 1);
sumref = zeros(size(sumref2));
sumrsp = zeros(size(sumrsp2));

offset = 0;
NBlock = 0;

Results = zeros(floor(Nsmp/NEpoch), 6);

indx = 1:Dsmp;

for mmm = 1:Nsmp

    tmpREF = refCP(:, mmm);

    tmpRSP = detrend(rspCP(:, mmm));

    
    tmpref = tmpREF((1:Hsmp*2));
    [mx, mp] = max(tmpref);

    tmprefR = tmpREF;
    tmprspR = tmpRSP;
    
    if mp > Hsmp
        MvP = mp - Hsmp;

        tmprefR(1:end-MvP) = tmpREF(MvP+1:end);
        tmprefR(end-MvP+1:end) = tmpREF(1:MvP);

        tmprspR(1:end-MvP) = tmpRSP(MvP+1:end);
        tmprspR(end-MvP+1:end) = tmpRSP(1:MvP);
    elseif mp < Hsmp
        MvP = Hsmp - mp;

        tmprefR(MvP+1:end) = tmpREF(1:end-MvP);
        tmprefR(1:MvP) = tmpREF(end-MvP+1:end);

        tmprspR(MvP+1:end) = tmpRSP(1:end-MvP);
        tmprspR(1:MvP) = tmpRSP(end-MvP+1:end);
    end

    if pFig
        figure(22),
        cr = rand(1, 3);
        subplot(211), plot(tmprefR/100, 'color', cr), hold on;
        
%         [tpr, zi] = filter(b, a, tmprspR, zi);
%         subplot(212), plot(tmprspR, 'color', cr); hold on;
        subplot(212), plot(filter(b, a, tmprspR), 'color', cr); hold on;
        pause(0.5)
    end

    sumref2(indx + Dsmp*offset) = sumref2(indx + Dsmp*offset) + tmprefR;

    sumrsp2(indx + Dsmp*offset) = sumrsp2(indx + Dsmp*offset) + tmprspR;

    offset = offset + 1;

    if mod(mmm, NEpoch) == 0
        offset = 0;
        NBlock = NBlock + 1;

        sumref = sumref + sumref2;
        sumrsp = sumrsp + sumrsp2;

        if pFig3
            cr = rand(1, 3);
            figure(21),
            subplot(2,1,1), plot(sumref, 'color', cr), hold on;
            subplot(2,1,2), plot(sumrsp, 'color', cr), hold on;
        end

        sumref2 = zeros(size(sumref2));
        sumrsp2 = zeros(size(sumrsp2));

        pause(1)

        Results(NBlock, :) = get_COH(sumrsp, sumref, Fs, 1, NEpoch, mf);

    end
end

indx = 1:Ssmp;

MC = zeros(cyc, 1);
AMP = zeros(cyc, 1);
PH = zeros(cyc, 1);

if pFig2
    figure(Nmf);
end

if mf < 80
    singlesumRSP = sum(reshape(sumrsp, Dsmp, 8), 2);
    singlesumREF = sum(reshape(sumref, Dsmp, 8), 2);

    for kkk = 1:cyc-1
        tmpsumRSP = filtfilt(b, a, singlesumRSP(indx + (kkk-1)*Ssmp));
        tmpsumREF = singlesumREF(indx + (kkk-1)*Ssmp);

        [tmpMC, MC(kkk)] = max(tmpsumREF);
        [AMP(kkk), PH(kkk)] = max(tmpsumRSP);

        if pFig2
            cr = rand(1, 3);
            subplot(211), plot(tmpsumREF, 'color', cr), hold on;
            subplot(212), plot(tmpsumRSP, 'color', cr), hold on;
        end

    end

    tmpsumRSP = filtfilt(b, a, singlesumRSP((cyc-1)*Ssmp+1:end));
    tmpsumREF = singlesumREF((cyc-1)*Ssmp+1:end);

    if pFig2
        cr = rand(1, 3);
        subplot(211), plot(tmpsumREF, 'color', cr), hold off;
        subplot(212), plot(tmpsumRSP, 'color', cr), hold off;
    end

    [tmpMC, MC(cyc)] = max(tmpsumREF);
    [AMP(cyc), PH(cyc)] = max(tmpsumRSP);

    Strength = VectorStrength((PH-MC), Ssmp);
    Amplitude = mean(AMP);
    phaseD = mean((2*pi*(mod((PH-MC), Ssmp))/Ssmp)*(180/pi));
else
    Strength = 0;
    Amplitude = 0;
    phaseD = 0;
end

if pFig
    figure(22), subplot(211), hold off; subplot(212), hold off;
end
if pFig3    
    figure(21), subplot(211), hold off; subplot(212), hold off;
end