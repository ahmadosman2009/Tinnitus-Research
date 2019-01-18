function [Results, Cxy, freqFactor] = get_COH(response, reference, Fsa, nDown, sgmN, mf)
%reference: AM signal
%response: recording

%for each epoch (with nPeriodsperEpoch)

if nargin < 4
    nDown = 1;
end

if nDown == 1
else
    reference = resample(reference, 1, nDown);
    response = resample(response, 1, nDown);
    Fsa = Fsa/nDown;
end

if nargin < 5
    sgmN = 8;
end

nWin = round(length(response)/sgmN);

nOverlap = fix(nWin/2);

nFFT = max(round(2.^(nextpow2(nWin))), 128);

[Cxy, freqFactor] = mscohere(response, reference, hamming(nWin), nOverlap, nFFT, Fsa);

[vm, pm] = min(abs(freqFactor - mf));

Ncoh = 3;

cohst = pm - floor((Ncoh-1)/2);
cohed = pm + floor(Ncoh/2);
cohIndx = (cohst:cohed);

Ndiff = [3 3];
Nomit = 1;

diffIndx = zeros(1, sum(Ndiff));

if Ndiff(1) > 0
    diffLed = cohst - (Nomit+1);
    diffLst = diffLed - Ndiff(1) + 1;
    diffIndx(1:Ndiff(1)) = (diffLst:diffLed);
end
if Ndiff(2) > 0
    diffRst = cohed + (Nomit+1);
    diffRed = diffRst + Ndiff(2) - 1;
    diffIndx(Ndiff(1) + (1:Ndiff(2))) = (diffRst:diffRed);
end

Nstd = [3 3];

stdIndx = zeros(1, sum(Nstd));

if Nstd(1) > 0
    stdLed = cohst - (Nomit+1);
    stdLst = stdLed - Nstd(1) + 1;
    stdIndx(1:Nstd(1)) = (stdLst:stdLed);
end
if Nstd(2) > 0
    stdRst = cohed + (Nomit+1);
    stdRed = stdRst + Nstd(2) - 1;
    stdIndx(Nstd(1) + (1:Nstd(2))) = (stdRst:stdRed);
end

tmpCD = Cxy(cohIndx);
TCD = mean([tmpCD(:); Cxy(pm)]);
TDF = mean(Cxy(diffIndx));
TSD = std(Cxy(stdIndx));

Strength = (TCD-TDF)/TSD;

Passed = 0;

cohz = 0.25;
Zsd = 3;

coha = 0.5;
Zsda = 30;

selection = [1 1 0];

if selection(1)
    Passed = (Passed || (((TCD >= cohz) && (Strength >= Zsd))));
end
if selection(2)
    Passed = (Passed || (TCD >= coha));
end
if selection(3)
    Passed = (Passed || (Strength > Zsda));
end

Results = [freqFactor(pm), TCD, TDF, TSD, Strength, Passed];    

if 0
    cr = rand(1, 3);
    figure(10), plot(freqFactor, Cxy, 'color', cr); hold on;
end