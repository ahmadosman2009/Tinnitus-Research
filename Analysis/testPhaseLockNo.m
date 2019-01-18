function [Results, cyc, Dsmp, Nsmp] = testPhaseLockNo(fnmr, fnms, mf, pFig)

if nargin < 4
    pFig = 0;
end

Fs = 24414.0625*4/20;

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
% 
[b, a] = butter(2, mf*[2.^(-1/2), 2.^(1/2)]/(Fs/2));
% zi = zeros(max(length(b), length(a))-1, 1);

refCP = reshape(refa, Dsmp, Nsmp);
rspCP = reshape(rspa, Dsmp, Nsmp);

% Ssmp = round(Dsmp/cyc);
% Hsmp = floor(Ssmp/2);

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

    tmprefR = tmpREF;
    tmprspR = tmpRSP;

    if pFig
        figure(pFig),
        cr = rand(1, 3);
        subplot(3, 2, 1), plot(tmprefR, 'color', cr), hold on;
        subplot(3, 2, 2), plot(tmprspR, 'color', cr), hold on;
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
        
        if pFig
            cr = rand(1, 3);
            figure(pFig),
            subplot(3, 2, [3 4]), plot(sumref, 'color', cr);
            subplot(3, 2, [5 6]), plot(filter(b, a, sumrsp), 'color', cr);
        end
        
        sumref2 = zeros(size(sumref2));
        sumrsp2 = zeros(size(sumrsp2));

        pause(1);

        Results(NBlock, :) = get_COH(sumrsp, sumref, Fs, 1, NEpoch, mf);

    end
end

if pFig
    figure(pFig)
    
    for nnn = 1:2
        subplot(3,2,nnn), hold off;
    end
    
    figure(pFig+40),
    
    hndl = get(gcf, 'Userdata');

    if isfield(hndl, 'Results')
        set(hndl.Results, 'String', num2str(Results));
    else
        hndl.Results = uicontrol('Style', 'edit', 'String', num2str(Results), ...
            'Units', 'normalized', 'max', 3, ...
            'Fontsize', 10, 'Position', [0.2 0.3 0.6 0.7]);
        set(gcf, 'Userdata', hndl);
    end
        
end