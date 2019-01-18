function [Results, Cxy, freqFactor] = get_coherence(response, reference, Fsa, nDown, sgmN)
%reference: AM signal
%response: recording

%for each epoch (with nPeriodsperEpoch)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');
thndl = get(hndl.testFig, 'Userdata');

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

[vm, pm] = min(abs(freqFactor - hndl.py.results.currentParameter(3)));

cohst = pm - floor((hndl.py.criteria.Ncoh-1)/2);
cohed = pm + floor(hndl.py.criteria.Ncoh/2);
cohIndx = (cohst:cohed);

diffIndx = zeros(1, sum(hndl.py.criteria.Ndiff));

if hndl.py.criteria.Ndiff(1) > 0
    diffLed = cohst - (hndl.py.criteria.Nomit+1);
    diffLst = diffLed - hndl.py.criteria.Ndiff(1) + 1;
    diffIndx(1:hndl.py.criteria.Ndiff(1)) = (diffLst:diffLed);
end
if hndl.py.criteria.Ndiff(2) > 0
    diffRst = cohed + (hndl.py.criteria.Nomit+1);
    diffRed = diffRst + hndl.py.criteria.Ndiff(2) - 1;
    diffIndx(hndl.py.criteria.Ndiff(1) + (1:hndl.py.criteria.Ndiff(2))) = (diffRst:diffRed);
end

stdIndx = zeros(1, sum(hndl.py.criteria.Nstd));

if hndl.py.criteria.Nstd(1) > 0
    stdLed = cohst - (hndl.py.criteria.Nomit+1);
    stdLst = stdLed - hndl.py.criteria.Nstd(1) + 1;
    stdIndx(1:hndl.py.criteria.Nstd(1)) = (stdLst:stdLed);
end
if hndl.py.criteria.Nstd(2) > 0
    stdRst = cohed + (hndl.py.criteria.Nomit+1);
    stdRed = stdRst + hndl.py.criteria.Nstd(2) - 1;
    stdIndx(hndl.py.criteria.Nstd(1) + (1:hndl.py.criteria.Nstd(2))) = (stdRst:stdRed);
end

tmpCD = Cxy(cohIndx);
TCD = mean([tmpCD(:); Cxy(pm)]);
TDF = mean(Cxy(diffIndx));
TSD = std(Cxy(stdIndx));

Strength = (TCD-TDF)/TSD;

Passed = 0;

if hndl.py.criteria.selection(1)
    Passed = (Passed || (((TCD >= hndl.py.criteria.cohz) && (Strength >= hndl.py.criteria.Zsd))));
end
if hndl.py.criteria.selection(2)
    Passed = (Passed || (TCD >= hndl.py.criteria.coha));
end
if hndl.py.criteria.selection(3)
    Passed = (Passed || (Strength > hndl.py.criteria.Zsda));
end

Results = [freqFactor(pm), TCD, TDF, TSD, Strength, Passed];    

set(hndl.testFig, 'CurrentAxes',thndl.uicontrol.plots.PRE_MagSquarCoh_AX);

plot(freqFactor, Cxy, 'Color', rand(1, 3)), hold on;
axis([hndl.py.results.currentParameter(3)/sqrt(2), hndl.py.results.currentParameter(3)*sqrt(2), 0, 1]), drawnow, 