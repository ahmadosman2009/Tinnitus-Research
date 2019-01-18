function [sumrsp, sumref, Dsmp, cyc, NBlocks, durCyc, durSmp] = getPhaseblockedBlock(fnms, fnmr, mf, Fs, dur)
if nargin < 4
    Fs = 24414.0625*4/20;
end

if nargin < 5
    dur = 20;
end

if mf > 40
    cyc = round(250/1000*mf);
else
    cyc = 10;
end

refa = PreadDAT(fnmr);
rspa = PreadDAT(fnms);

smp = round(Fs*20/mf*cyc);
Dsmp = round(smp/20);

durCyc = cyc*dur;

durSmp = Dsmp*dur;


Nsmp = floor(length(refa)/Dsmp);

adjSmp = Nsmp*Dsmp;

newREF = zeros(adjSmp, 1);
newRSP = zeros(adjSmp, 1);

refCP = reshape(refa(1:adjSmp), Dsmp, Nsmp);
rspCP = reshape(rspa(1:adjSmp), Dsmp, Nsmp);

Ssmp = round(Dsmp/cyc);
Hsmp = floor(Ssmp/2);

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

    newREF(indx + Dsmp*(mmm-1)) = tmprefR;

    newRSP(indx + Dsmp*(mmm-1)) = tmprspR;
end

NBlocks = floor(length(newREF)/durSmp);

if NBlocks < 1
    sumref = newREF;
    sumrsp = newRSP;
else
    sumref = zeros(durSmp, NBlocks);
    sumrsp = zeros(durSmp, NBlocks);
    
    indx = 1:durSmp;
    
    for nnn = 1:NBlocks
        sumref(:, nnn) = newREF(indx + (nnn-1)*durSmp);
        sumrsp(:, nnn) = newRSP(indx + (nnn-1)*durSmp);
    end
end
    