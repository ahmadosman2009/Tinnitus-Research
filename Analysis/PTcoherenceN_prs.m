function PTcoherenceN_prs2(obj, evt)

hndl = get(gcf, 'Userdata');

set(hndl.uicontrol.control.waveN, 'Enable', 'off');

set(hndl.uicontrol.control.FFTN, 'Enable', 'off');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'off');

set(hndl.uicontrol.control.phaseN, 'Enable', 'off');

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*rsp.sgn']));

fnp = {fin.name}';

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*ref.sgn']));

fnr = {fin.name}';

fin = dir(fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN '*Cohere*.xls']));

fnx = {fin.name}';

if isempty(fnx)
    CohereXC = fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN 'Cohere' char(65) '.xls']);
else
    CohereXC = fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN 'Cohere' char(65 + length(fnx)) '.xls']);
end

axes(hndl.uicontrol.plots.display_AX);

if isempty(fnp)
    set(hndl.uicontrol.control.headLine_TX, 'String', 'None File');
else
    for mmm = 1:length(fnp)

        cla;
        try
            set(hndl.uicontrol.control.mf_ED, 'String', hndl.general.setting.mf(mmm));

            set(hndl.uicontrol.control.headLine_TX, 'String', fnp{mmm});

            fnmr = fullfile(hndl.general.file.PathN, fnr{mmm});

            fnms = fullfile(hndl.general.file.PathN, fnp{mmm});

            [sumrsp, sumref, Dsmp, cyc, NBlocks, durCyc, durSmp] = ...
                getPhaseblockedBlock(fnms, fnmr, hndl.general.setting.mf(mmm), hndl.general.setting.FsP, hndl.setting.criteria.perBlock);


            for rrr= 1:NBlocks
                refa = sumref(:, rrr);
                rspa = sumrsp(:, rrr);

                Nsmp = floor(length(refa)/Dsmp);

                NEpoch = 8;

                seg = floor(Nsmp/8);

                rst = zeros(seg, 5, hndl.setting.criteria.NCriteria);  %seg, %coh, diff, sd, strength, checkpass, %criteria

                refCP = zeros(Dsmp, Nsmp);
                rspCP = zeros(Dsmp, Nsmp);

                indxT = 1:Dsmp;
                for ttt = 1:Nsmp
                    refCP(:, ttt) = refa(indxT+(ttt-1)*Dsmp);
                    rspCP(:, ttt) = rspa(indxT+(ttt-1)*Dsmp);
                end

                Ssmp = round(Dsmp/cyc);
                Hsmp = floor(Ssmp/2);

                sumref2 = zeros(Dsmp*NEpoch, 1);
                sumrsp2 = zeros(Dsmp*NEpoch, 1);
                sumref = zeros(size(sumref2));
                sumrsp = zeros(size(sumrsp2));

                offset = 0;
                NBlock = 0;

                indx = 1:Dsmp;

                qqq = 0;

                passedrst = zeros(hndl.setting.criteria.NCriteria, 1);

                for nnn = 1:Nsmp

                    tmpREF = refCP(:, nnn);

                    tmpRSP = detrend(rspCP(:, nnn));

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

                    if mod(nnn, NEpoch) == 0
                        qqq = qqq + 1;

                        offset = 0;
                        NBlock = NBlock + 1;

                        sumref = sumref + sumref2;
                        sumrsp = sumrsp + sumrsp2;

                        sumref2 = zeros(size(sumref2));
                        sumrsp2 = zeros(size(sumrsp2));

                        nWin = round(length(sumrsp)/NEpoch);

                        nOverlap = fix(nWin/2);

                        nFFT = max(round(2.^(nextpow2(nWin))), 128);

                        [Cxy, freqFactor] = mscohere(sumrsp, sumref, hamming(nWin), nOverlap, nFFT, hndl.general.setting.FsP);

                        [vm, pm] = min(abs((freqFactor - hndl.general.setting.mf(mmm))));

                        tstr = '';

                        for kkk = 1:hndl.setting.criteria.NCriteria

                            cohst = pm - floor((hndl.setting.criteria.NPoints(kkk, 1) - 1)/2);
                            cohed = pm + floor(hndl.setting.criteria.NPoints(kkk, 1)/2);
                            cohIndx = (cohst:cohed);

                            diffIndx = zeros(1, sum(hndl.setting.criteria.NPoints(kkk, 3:4)));

                            if hndl.setting.criteria.NPoints(kkk, 3) > 0
                                diffLed = cohst - (hndl.setting.criteria.NPoints(kkk, 2)+1);
                                diffLst = diffLed - hndl.setting.criteria.NPoints(kkk, 3) + 1;
                                diffIndx(1:hndl.setting.criteria.NPoints(kkk, 3)) = (diffLst:diffLed);
                            end
                            if hndl.setting.criteria.NPoints(kkk, 4) > 0
                                diffRst = cohed + (hndl.setting.criteria.NPoints(kkk, 2)+1);
                                diffRed = diffRst + hndl.setting.criteria.NPoints(kkk, 4) - 1;
                                diffIndx(hndl.setting.criteria.NPoints(kkk, 3) + (1:hndl.setting.criteria.NPoints(kkk, 4))) = (diffRst:diffRed);
                            end

                            stdIndx = zeros(1, sum(hndl.setting.criteria.NPoints(kkk, 5:6)));

                            if hndl.setting.criteria.NPoints(kkk, 5) > 0
                                stdLed = cohst - (hndl.setting.criteria.NPoints(kkk, 2)+1);
                                stdLst = stdLed - hndl.setting.criteria.NPoints(kkk, 5) + 1;
                                stdIndx(1:hndl.setting.criteria.NPoints(kkk, 5)) = (stdLst:stdLed);
                            end
                            if hndl.setting.criteria.NPoints(kkk, 6) > 0
                                stdRst = cohed + (hndl.setting.criteria.NPoints(kkk, 2)+1);
                                stdRed = stdRst + hndl.setting.criteria.NPoints(kkk, 6) - 1;
                                stdIndx(hndl.setting.criteria.NPoints(kkk, 5) + (1:hndl.setting.criteria.NPoints(kkk, 6))) = (stdRst:stdRed);
                            end

                            tmpCD = Cxy(cohIndx);
                            rst(qqq, 1, kkk) = mean([tmpCD(:); Cxy(pm)]);
                            rst(qqq, 2, kkk) = mean(Cxy(diffIndx));
                            rst(qqq, 3, kkk) = std(Cxy(stdIndx));
                            rst(qqq, 4, kkk) = (rst(qqq, 1, kkk)-rst(qqq, 2, kkk))/rst(qqq, 3, kkk);

                            Passed = 0;

                            if hndl.setting.criteria.selection(1)
                                Passed = (Passed || (((rst(qqq, 1, kkk) >= hndl.setting.criteria.cohz) && ...
                                    (rst(qqq, 4, kkk) >= hndl.setting.criteria.Zsd))));
                            end
                            if hndl.setting.criteria.selection(2)
                                Passed = (Passed || ((rst(qqq, 1, kkk) >= hndl.setting.criteria.coha)));
                            end
                            if hndl.setting.criteria.selection(3)
                                Passed = (Passed || (rst(qqq, 4, kkk) > hndl.setting.criteria.Zsda));
                            end

                            rst(qqq, 5, kkk) =  Passed;

                            if Passed
                                passedrst(kkk) = passedrst(kkk) + 1;
                            else
                                passedrst(kkk) = 0;
                            end
                        end

                        if 1
                            plot(freqFactor, Cxy, 'Color', rand(1, 3)); hold on;

                            xlim(hndl.general.setting.mf(mmm)*[2.^(-hndl.general.setting.bandwidth/2), 2.^(hndl.general.setting.bandwidth/2)]);
                            ylim([0, 1]);

                            xlabel('Frequency (Hz)');
                            ylabel('Coherence');

                            grid on;

                            drawnow;
                            pause(0.5);
                        end
                    end
                end

                for kkk = 1:hndl.setting.criteria.NCriteria
                    tstr = sprintf('%s%d-P%d; ', tstr, kkk, passedrst(kkk) >= hndl.setting.criteria.NBlocks);
                end

                text(hndl.general.setting.mf(mmm)/1.4, 0.9, tstr, 'FontSize', 18);

                drawnow; pause(0.1);
            end
        catch
            set(hndl.uicontrol.control.headLine_TX, 'String', 'Data problem');
        end
        hold off;
    end
end

set(hndl.uicontrol.control.waveN, 'Enable', 'on');

set(hndl.uicontrol.control.FFTN, 'Enable', 'on');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'on');

set(hndl.uicontrol.control.phaseN, 'Enable', 'on');