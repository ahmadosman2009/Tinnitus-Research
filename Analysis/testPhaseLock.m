function [cyc, Dsmp, Nsmp] = testPhaseLock(Nmf)

if nargin < 1
    Nmf = 5;
end

mfA = [85.8, 27, 171.6, 432.4, 343.2, 34.1, 21.5, 54.1, 108.1, 17, 136.2, 216.2, 42.9, 272.4, 68.1]';

clc
pth = 'C:\AMFR\data\16-104';

Fs = 24414.0625*4/20;

mf = mfA(Nmf);

% fn = filen(pth, '*43*01A*.sgn');
% fnms = fullfile(pth, fn{6});

tmpstr = sprintf('16-104MT5MF17-432HzMS3_CT2CF22E01CBW2_LV50_screw_16-%02dAREF.sgn', Nmf);
fnmr = fullfile(pth, tmpstr);

tmpstr = sprintf('16-104MT5MF17-432HzMS3_CT2CF22E01CBW2_LV50_screw_16-%02dARSP.sgn', Nmf);
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

Ssmp = round(Dsmp/cyc);
Hsmp = floor(Ssmp/2);

sumref2 = zeros(Dsmp*NEpoch, 1);
sumrsp2 = zeros(Dsmp*NEpoch, 1);
sumref = zeros(size(sumref2));
sumrsp = zeros(size(sumrsp2));

offset = 0;
NBlock = 0;

indx = 1:Dsmp;

for mmm = 1:Nsmp
    sumref2(indx + Dsmp*offset) = sumref2(indx + Dsmp*offset) + refCP(:, mmm);
    
    [tmpRSP, zi] = filter(b, a, rspCP(:, mmm), zi);    
    sumrsp2(indx + Dsmp*offset) = sumrsp2(indx + Dsmp*offset) + tmpRSP;
    
    offset = offset + 1;
    
    if mod(mmm, NEpoch) == 0
        offset = 0;
        NBlock = NBlock + 1;

        tmpref = sumref2(1:Ssmp);
        [mx, mp] = max(tmpref);

        if mp > Hsmp
            MvP = mp - Hsmp;

            tmprefR = sumref2;
            tmprefR(1:end-MvP) = sumref2(MvP+1:end);
            tmprefR(end-MvP+1:end) = sumref2(1:MvP);

            tmprspR = sumrsp2;
            tmprspR(1:end-MvP) = sumrsp2(MvP+1:end);
            tmprspR(end-MvP+1:end) = sumrsp2(1:MvP);
        elseif mp < Hsmp
            MvP = Hsmp - mp;
            tmprefR = sumref2;
            tmprefR(MvP+1:end) = sumref2(1:end-MvP);
            tmprefR(1:MvP) = sumref2(end-MvP+1:end);

            tmprspR = sumrsp2;
            tmprspR(MvP+1:end) = sumrsp2(1:end-MvP);
            tmprspR(1:MvP) = sumrsp2(end-MvP+1:end);
        else
            tmprefR = sumref2;
            tmprspR = sumrsp2;
        end
        
        sumref = sumref + tmprefR;
        sumrsp = sumrsp + tmprspR;
        
        figure(2),
        for nnn = 1:NEpoch
            cr = rand(1, 3);
            subplot(2,1,1), plot(tmprefR(indx + (nnn-1)*Dsmp), 'color', cr), hold on;
            subplot(2,1,2), plot(tmprspR(indx + (nnn-1)*Dsmp), 'color', cr), hold on;
            pause(0.5)
        end
        
        cr = rand(1, 3);
        figure(1), 
        subplot(2,1,1), plot(tmprefR, 'color', cr), hold on;
        subplot(2,1,2), plot(tmprspR, 'color', cr), hold on;        
        
        sumref2 = zeros(size(sumref2));
        sumrsp2 = zeros(size(sumrsp2));
        
        pause(1)
    end
end

figure(1), subplot(211), hold off; subplot(212), hold off;
figure(2), subplot(211), hold off; subplot(212), hold off;