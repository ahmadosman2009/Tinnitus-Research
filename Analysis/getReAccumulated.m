function [sumrsp, sumref, Dsmp, cyc, NBlocks] = getReAccumulated(fnms, fnmr, mf, Fs)
if nargin < 4
    Fs = 24414.0625*4/20;
end

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

refCP = reshape(refa, Dsmp, Nsmp);
rspCP = reshape(rspa, Dsmp, Nsmp);

Ssmp = round(Dsmp/cyc);
Hsmp = floor(Ssmp/2);

sumref2 = zeros(Dsmp*NEpoch, 1);
sumrsp2 = zeros(Dsmp*NEpoch, 1);
sumref = zeros(size(sumref2));
sumrsp = zeros(size(sumrsp2));

offset = 0;
NBlocks = 0;

indx = 1:Dsmp;

for mmm = 1:Nsmp

    tmpREF = refCP(:, mmm);

    tmpRSP = detrend(rspCP(:, mmm));
    
    tmprefR = tmpREF;
    tmprspR = tmpRSP;

    tmpref = tmpREF((1:Ssmp));
    [mx, mp] = max(tmpref);

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

    sumref2(indx + Dsmp*offset) = sumref2(indx + Dsmp*offset) + tmprefR;

    sumrsp2(indx + Dsmp*offset) = sumrsp2(indx + Dsmp*offset) + tmprspR;

    offset = offset + 1;

    if mod(mmm, NEpoch) == 0
        offset = 0;
        NBlocks = NBlocks + 1;

        sumref = sumref + sumref2;
        sumrsp = sumrsp + sumrsp2;
        
        sumref2 = zeros(size(sumref2));
        sumrsp2 = zeros(size(sumrsp2));
    end
end

if NBlocks < 1
    sumref = sumref + sumref2;
    sumrsp = sumrsp + sumrsp2;
end
    